--exec sp_populate_fact_ADVANTECH 1
create PROC sp_populate_fact_ADVANTECH (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime
declare @intFactCount int

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID


if (@startdate is not null and @enddate is not null)
begin

update etl_configuration.[dbo].[DataLoad_Log] set status =0, loadstart = getdate() where loadid = @pLoadID;
select distinct r.sn2,r.sn1 into #snr from SHOPFLOOR_ADVANTECH.dbo.sn_relation r;

with all_mid (sn, sn_1, lvl) as
(select distinct serial_number , r.sn1 , 0 lvl
from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr
inner join #snr r
on sr.serial_number = r.sn2 
where (sr.datestamp between @startdate and @enddate)  and
len(sr.serial_number) = 12  and  
(sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%')
union all
select all_mid.sn, l.sn1, all_mid.lvl +1 from #snr l
inner join all_mid on all_mid.sn_1 = l.sn2  and all_mid.lvl < 5
)
select * into #t from all_mid

select a.sn,a.sn_1, min(a.lvl) l_lvl into #t_l from #t a 
group by a.sn, a.sn_1

select sn, max(l_lvl) l_lvl into #t_f from #t_l group by sn

select #t_l.sn serial_number, #t_l.sn_1 sn1 into #sn_mid from #t_l inner join #t_f on #t_l.sn = #t_f.sn and #t_l.l_lvl= #t_f.l_lvl 

select sn.SerialNumberKey, isnull(mid.[MIDKey],-1) MIDKey into  #sl_mid
from #sn_mid bt
left outer join ManufacturingId_D mid
on bt.sn1 = mid.MID
left outer join SerialNumber_D sn 
on bt.serial_number = sn.SerialNumber

select sr.SerialNumberKey, (select  convert(varchar,d.MIDKey) + ','  from  
#sl_mid d 
 where sr.SerialNumberKey = d.SerialNumberKey order by d.MIDKey asc for xml path('')) gmid  into #grp
  from #sl_mid sr  
group by sr.SerialNumberKey


insert into BridgeMIDGroup ([MIDGroupKey],[MIDKey],[WeightFactor],[SerialNumberKey])
select checksum(g.gmid) groupkey, f.MIDKey, 1.0/ (len(g.gmid) - len(replace(g.gmid,',',''))) wf, f.SerialNumberKey

from #sl_mid f
inner join #grp g on f.SerialNumberKey = g.SerialNumberKey
left outer join  [dbo].[BridgeMIDGroup] t on checksum(g.gmid) = t.[MIDGroupKey]
where t.[MIDGroupKey] is null;


select @intFactCount  = count(*) from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr
where (sr.datestamp between @startdate and @enddate) and len(sr.serial_number) = 12 and
 (sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%');

with T_Label_Assem as
 (select  step_index, serial_number, data_value udv from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field Assembly' and (sd.datestamp between @startdate and @enddate) ),
T_SKU as
(select  step_index, serial_number, data_value SKU from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute ='label assembly part number' and  data_value like '01-SSC%'
and step_index in
(select step_index from SHOPFLOOR_ADVANTECH.dbo.process_step_result where station_type_code in(1,4))and (sd.datestamp between @startdate and @enddate)),
T_RM as
(select  step_index, serial_number, data_value RM from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field RM'and (sd.datestamp between @startdate and @enddate)),
T_RFID as
(select  step_index, serial_number, data_value RFID from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field RFID' and (sd.datestamp between @startdate and @enddate)),
T_FirmW as
(select  step_index, serial_number, data_value FW from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd 
where data_attribute like 'FirmwareVersion'and (sd.datestamp between @startdate and @enddate)),
T_ROMv as
(select  step_index, serial_number,data_value RV from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'ROMVersion'and (sd.datestamp between @startdate and @enddate)),
T_SMV as
(select  step_index, serial_number, data_value SMV from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'SafeModeVersion'and (sd.datestamp between @startdate and @enddate)),
T_RMA as
(select  step_index, serial_number, 'yes' RMA from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd 
where data_attribute like 'label part number' and data_value like 'RMA%' and (sd.datestamp between @startdate and @enddate)
union 
select  step_index, serial_number, 'yes' RMA from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field assembly' and (data_value like '%R' or data_value like '%D' and (sd.datestamp between @startdate and @enddate))),
T_fact as
(select  sr.serial_number, 
 smv.SMV,
 sku.SKU,
 romv.RV,
 fwv.FW,
 rm.RM,
 format(sr.datestamp,'yyyyMMdd') T_datekey,
 datepart(MI,sr.datestamp) T_min,
 datepart(HH,sr.datestamp) T_hour,
  10 datasourcekey, -- datasourcekey
 sr.step_index,
 dbo.fn_getdatavalue(sr.step_index, sr.serial_number,10) psdata, 
 sr.step_result_code,
 convert (varchar ,sr.location_code) LC,
 sr.pn_code,
 ass.udv assem,
 -1 Workorder, -- Workorder
 case when (rma.RMA is not null) then 1 else 2 end IsRMA,
 -1 IRV, -- IRV,
 sr.datestamp processdate,
 convert (varchar ,sr.station_type_code) STC,
 --sr.Station_type_code STC,
 sr.Station_id STA,
 rfid.RFID
 
  from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr 
  left outer join T_SMV smv on sr.step_index = smv.step_index and sr.serial_number = smv.serial_number
  left outer join T_ROMv romv on sr.step_index = romv.step_index and sr.serial_number = romv.serial_number
  left outer join T_FirmW fwv on sr.step_index = fwv.step_index and sr.serial_number = fwv.serial_number
  left outer join T_RM rm on sr.step_index = rm.step_index and sr.serial_number = rm.serial_number
  left outer join T_RFID rfid on sr.step_index = rfid.step_index and sr.serial_number = rfid.serial_number
  left outer join T_SKU sku on sr.step_index = sku.step_index and sr.serial_number = sku.serial_number
   left outer join T_Label_Assem ass on sr.step_index = ass.step_index and sr.serial_number = ass.serial_number
  left outer join T_RMA rma on sr.step_index = rma.step_index and sr.serial_number = rma.serial_number
  left outer join PartNumber_D pn on sr.pn_code = pn.PartNumberCode 
  left outer join SHOPFLOOR_ADVANTECH.dbo.sn_relation r on sr.serial_number = r.sn2 --and sr.station_id = r.station_id 
  left outer join [Location_D] l on sr.Location_Code= l.LocationCode
  where (sr.datestamp between @startdate and @enddate) and len(sr.serial_number) = 12 and
 (sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%'))
  

  select isnull((select max(MFTGSummaryKey) from [MFTG_DW].dbo.MFTGSummary_F),0) + 
  ROW_NUMBER() over (ORDER BY T_fact.step_index) [MFTGSummaryKey],
  1 MFTGSummaryCount,
  isnull(sn.SerialNumberKey, -1) SerialNumberKey,
  isnull(smv.SafemodeVersionKey, -1) SafemodeVersionKey,
  isnull(rv.ROMVersionKey,-1) ROMVersionKey,
  isnull(fwv.FirmwareVersionKey, -1) FirmwareVersionKey,
  isnull(rd.RegulatoryModelKey, -1) RegulatoryModelKey,
  T_fact.T_datekey TransactionDateKey,
  T_fact.T_min TransactionMinuteKey,
  T_fact.T_hour TransactionHourKey,
  T_fact.datasourcekey,
  isnull(sku.SKUKey, -1) SKUKey,
   T_fact.step_index StepIndex,
  T_fact.psdata ProcessStepData,
  isnull(src.StepResultCodeKey, -1) StepResultCodeKey,
  isnull(l.LocationKey, -1) LocationKey,
  isnull(pn.PartNumberKey, -1) PartNumberKey,
  isnull(a.AssemblyKey, -1) AssemblyKey,
  T_fact.Workorder WorkOrderKey,
  T_fact.IsRMA IsRMAKey,
  T_fact.IRV IRVKey,
  T_fact.processdate,
  isnull(stc.StationTypeKey,-1) StationTypeKey,
  isnull(sta.StationKey,-1) StationKey,
  -1 DateCodeKey,
  isnull(rfid.RFIDKey,-1) RFIDKey
 

  into #MFTGSummary_F
  from T_fact 
  left outer join SerialNumber_D sn on T_fact.serial_number = sn.SerialNumber
  left outer join SafemodeVersion_D smv on T_fact.SMV = smv.SafemodeVersion
  left outer join ROMVersion_D rv on T_fact.RV = rv.ROMVersion 
  left outer join RFID_D rfid on T_fact.RFID = rfid.RFID 
  left outer join FirmwareVersion_D fwv on T_fact.FW = fwv.FirmwareVersion
  left outer join RegulatoryModel_D rd on T_fact.RM = rd.RegulatoryModel 
  left outer join SKU_D sku on T_fact.SKU = sku.SKUDescription
  left outer join StepResultCode_D src on T_fact.step_result_code = src.StepResultValue 
  left outer join Location_D l on T_fact.LC = l.location 
  left outer join PartNumber_D pn on T_fact.pn_code = pn.PartNumberCode
  left outer join Assembly_D a on T_fact.assem = a.AssemblyNumber
  left outer join Station_D sta on T_fact.STA = sta.Station
  left outer join StationType_D stc on T_fact.STC = stc.StationType
  
  if (@intFactCount <> (select count(*) from #MFTGSummary_F))
	return

   insert into MFTG_DW.dbo.MFTGSummary_F(
	[MFTGSummaryKey],
	[MFTGSummaryCount],
	[SerialNumberKey],
	[SafemodeVersionKey],
	[ROMVersionKey],
	[FirmwareVersionKey],
	[RegulatoryModelKey],
	[TransactionDateKey],
	[TransactionMinuteKey],
	[TransactionHourKey],
	[DataSourceKey],
	[SKUKey],
	[StepIndex],
	[ProcessStepData],
	[StepResultCodeKey],
	[LocationKey],
	[PartNumberKey],
	[AssemblyKey],
	[WorkOrderKey],
	[IsRMAKey],
	[IRVKey],
	[ProcessDate],
	[StationTypeKey],
	[StationKey],
	[DateCodeKey],
	[MIDGroupKey],
	[RFIDKey]
	)
	select [MFTGSummaryKey],
	[MFTGSummaryCount],
	tf.[SerialNumberKey],
	[SafemodeVersionKey],
	[ROMVersionKey],
	[FirmwareVersionKey],
	[RegulatoryModelKey],
	[TransactionDateKey],
	[TransactionMinuteKey],
	[TransactionHourKey],
	[DataSourceKey],
	[SKUKey],
	[StepIndex],
	[ProcessStepData],
	[StepResultCodeKey],
	[LocationKey],
	[PartNumberKey],
	[AssemblyKey],
	[WorkOrderKey],
	[IsRMAKey],
	[IRVKey],
	[ProcessDate],
	[StationTypeKey],
	[StationKey],
	[DateCodeKey],
	checksum(g.gmid) [MIDGroupKey],
	RFIDKey
	from #MFTGSummary_F tf
	left outer join #grp g on tf.SerialNumberKey = g.SerialNumberKey ;

   
   update etl_configuration.[dbo].[DataLoad_Log] set status =1, loadend = getdate() where loadid = @pLoadID;
  end
  end;