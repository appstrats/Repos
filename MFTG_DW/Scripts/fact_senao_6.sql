use MFTG_DW
GO
--exec sp_populate_fact_senao 5
Create PROC sp_populate_fact_senao (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime
declare @intFactCount int

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID

if (@startdate is not null and @enddate is not null)
begin

update etl_configuration.[dbo].[DataLoad_Log] set status =0, loadstart = getdate() where loadid = @pLoadID;
select distinct r.serial_number,r.combination_serial_number into #snr from SENAO_MFGTESTC_TAIWAN.dbo.serial_number_relations r;

with all_mid (sn, c_sn, lvl) as
(select distinct r.serial_number, r.combination_serial_number , 0 lvl
from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr
inner join #snr r
on sr.serial_number = r.serial_number 
where (sr.datestamp between @startdate and @enddate)  and
len(sr.serial_number) = 12  and  
(sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%')
union all
select all_mid.sn, l.combination_serial_number, all_mid.lvl +1 from #snr l
inner join all_mid on all_mid.c_sn = l.serial_number  and all_mid.lvl < 5
)
select * into #t from all_mid

select a.sn,a.c_sn, min(a.lvl) l_lvl into #t_l from #t a 
group by a.sn, a.c_sn

select sn, max(l_lvl) l_lvl into #t_f from #t_l group by sn

select #t_l.sn serial_number, #t_l.c_sn combination_serial_number into #sn_mid from #t_l inner join #t_f on #t_l.sn = #t_f.sn and #t_l.l_lvl= #t_f.l_lvl 

select sn.SerialNumberKey, isnull(mid.[MIDKey],-1) MIDKey into  #sl_mid
from #sn_mid bt
left outer join ManufacturingId_D mid
on bt.combination_serial_number = mid.MID
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

select @intFactCount  = count(*) from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate)  and len(sr.serial_number) = 12  and 
  (sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
  or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%');

select step_index,  data_value SMV into #T_SMV from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data 
where rtrim(data_attribute )like 'Safemode_Version' and (datestamp between @startdate and @enddate) 

select step_index, data_value RV into #T_ROMv from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data 
where rtrim(data_attribute )like 'ROM_Version'  and (datestamp between @startdate and @enddate) 

select step_index, data_value RFID into #T_RFID from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data 
where rtrim(data_attribute )like 'label field RFID'  and (datestamp between @startdate and @enddate) 

select step_index, data_value FW into #T_FirmW from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data 
where rtrim(data_attribute )like 'Firmware_Version'  and (datestamp between @startdate and @enddate) 

 select step_index, data_value udv into #T_Label_Assem from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data 
where rtrim(data_attribute)like 'label_field_Assembly'  and (datestamp between @startdate and @enddate)

select distinct part_number, part_description, serial_number,process_date into #T_PartNum from SENAO_MFGTESTC_TAIWAN.dbo.process_results 
where (process_date between @startdate and @enddate) 

select sr.serial_number, 
 smv.SMV,
 romv.RV,
 fwv.FW,
 format(sr.datestamp,'yyyyMMdd') T_datekey,
 datepart(MI,sr.datestamp) T_min,
 datepart(HH,sr.datestamp) T_hour,
 sr.step_index,
 dbo.fn_getdatavalue(sr.step_index, sr.serial_number,2) psdata, 
 pn.part_number PartNumber, 
 pn.part_description pn_desc,
 ass.udv assem,
 sr.datestamp processdate,
 convert (varchar ,sr.station_type_code) STC,
 sr.Station_id STA,
 format(sr.datestamp,'yyyyMMdd') DC,
 rfid.RFID
 into #T_fact
  from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr 
  left outer join #T_SMV smv on sr.step_index = smv.step_index --and sr.serial_number = smv.serial_number
  left outer join #T_ROMv romv on sr.step_index = romv.step_index --and sr.serial_number = romv.serial_number
  left outer join #T_RFID rfid on sr.step_index = rfid.step_index --and sr.serial_number = rfid.serial_number
  left outer join #T_FirmW fwv on sr.step_index = fwv.step_index --and sr.serial_number = fwv.serial_number
  left outer join #T_Label_Assem ass on sr.step_index = ass.step_index --and sr.serial_number = ass.serial_number
  left outer join #T_PartNum pn on sr.serial_number = pn.serial_number and convert(varchar,sr.datestamp ,112) = pn.process_date
    
  where (sr.datestamp between @startdate and @enddate)  and len(sr.serial_number) = 12  and 
  (sr.serial_number like '0006B1%' or sr.serial_number like '0017C5%' or  sr.serial_number like 'FFFFFF%'
  or sr.serial_number like 'C0EAE4%' or sr.serial_number like '18B169%' or sr.serial_number like '004010%')

    if (@intFactCount <> (select count(*) from #T_fact))
	return

  select isnull((select max(MFTGSummaryKey) from [MFTG_DW].dbo.MFTGSummary_F),0) + 
  ROW_NUMBER() over (ORDER BY T_fact.step_index) [MFTGSummaryKey],
  1 MFTGSummaryCount,
  isnull(sn.SerialNumberKey, -1) SerialNumberKey,
  isnull(smv.SafemodeVersionKey, -1) SafemodeVersionKey,
  isnull (rv.ROMVersionKey,-1) [ROMVersionKey],
  isnull(fwv.FirmwareVersionKey, -1) FirmwareVersionKey,
  -1 RegulatoryModelKey,
  T_fact.T_datekey TransactionDateKey,
  T_fact.T_min TransactionMinuteKey,
  T_fact.T_hour TransactionHourKey,
  2 datasourcekey,
   -1 [SKUKey],
    T_fact.step_index StepIndex,
  T_fact.psdata ProcessStepData,
  -1 [StepResultCodeKey],
  -1 [LocationKey],
  isnull(pn.PartNumberKey, -1) PartNumberKey,
  isnull(a.AssemblyKey, -1) AssemblyKey,
  -1 [WorkOrderKey],
  -1 [IsRMAKey],
  -1 [IRVKey],
  T_fact.processdate,
   isnull(stc.StationTypeKey,-1) StationTypeKey,
   isnull(sta.StationKey,-1) StationKey,
   isnull(dc.DateCodeKey,-1) DateCodeKey,
   isnull(rfid.RFIDKey,-1) RFIDKey
 
  into #MFTGSummary_F
  from #T_fact T_fact 
  left outer join SerialNumber_D sn on T_fact.serial_number = sn.SerialNumber
  left outer join SafemodeVersion_D smv on T_fact.SMV = smv.SafemodeVersion
  left outer join ROMVersion_D rv on T_fact.RV = rv.ROMVersion 
  left outer join RFID_D rfid on T_fact.RFID = rfid.RFID
  left outer join FirmwareVersion_D fwv on T_fact.FW = fwv.FirmwareVersion
  left outer join Assembly_D a on T_fact.assem = a.AssemblyNumber
  left outer join Station_D sta on T_fact.STA = sta.Station
  left outer join StationType_D stc on T_fact.STC = stc.StationType
  left outer join DateCode_D dc on T_fact.DC = dc.DateCode
  left outer join PartNumber_D pn on T_fact.part_number = pn.PartNumber and T_fact.pn_desc = pn.[Description];

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
	processdate,
	StationTypeKey,
	StationKey,
	[DateCodeKey],
	checksum(g.gmid) [MIDGroupKey],
	[RFIDKey]
	from #MFTGSummary_F tf
	left outer join #grp g on tf.SerialNumberKey = g.SerialNumberKey ;

   
   update etl_configuration.[dbo].[DataLoad_Log] set status =1, loadend = getdate() where loadid = @pLoadID;
  end
  end;