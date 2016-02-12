--use MFTG_DW
--exec sp_populate_fact_SERCOMM 5
alter PROC sp_populate_fact_SERCOMM (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID

if (@startdate is not null and @enddate is not null)
begin

update etl_configuration.[dbo].[DataLoad_Log] set status =0 where loadid = @pLoadID;
select Serial_Number into #snr from 
(select distinct sr.Serial_Number from MES2_SERCOMM.dbo.process_step_result sr
union 
select distinct snta.Serial_Number from MES2_SERCOMM.dbo.sn_travel_assembly snta ) a

SELECT distinct snta.Mac_id ,r.Serial_Number into #snr1 FROM #snr r 
inner join MES2_SERCOMM.dbo.sn_travel_assembly snta on r.Serial_Number = snta.Serial_Number
where 
len(snta.Mac_Id) = 12 and
 (snta.Mac_Id like '0006B1%' or snta.Mac_Id like '0017C5%' or  snta.Mac_Id like 'FFFFFF%'
or snta.Mac_Id like 'C0EAE4%' or snta.Mac_Id like '18B169%' or snta.Mac_Id like '004010%')  and (snta.Out_Process_Time between @startdate and @enddate ) 

select sn.SerialNumberKey, isnull(mid.[MIDKey],-1) MIDKey into  #sl_mid
from #snr1 bt
left outer join ManufacturingId_D mid
on bt.Serial_Number = mid.MID
left outer join SerialNumber_D sn 
on bt.Mac_id = sn.SerialNumber

select sr.SerialNumberKey, (select  convert(varchar,d.MIDKey) + ','  from  
#sl_mid d 
 where sr.SerialNumberKey = d.SerialNumberKey order by d.MIDKey asc for xml path('')) gmid  into #grp
  from #sl_mid sr  
group by sr.SerialNumberKey

insert into BridgeMIDGroup ([MIDKey],[WeightFactor],[SerialNumberKey],[MIDGroupKey])
select  f.MIDKey, 1.0/ (len(g.gmid) - len(replace(g.gmid,',',''))) wf, f.SerialNumberKey,checksum(g.gmid) groupkey
from #sl_mid f
inner join #grp g on f.SerialNumberKey = g.SerialNumberKey
left outer join  [dbo].[BridgeMIDGroup] t on checksum(g.gmid) = t.[MIDGroupKey]
where t.[MIDGroupKey] is null;

select distinct Step_index, last_value(data_value) over (partition by step_index order by datastamp asc) SMV into #T_SMV from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(data_attribute )like 'SafeModeVersion' and (sd.datastamp between @startdate and @enddate) 

select distinct Step_index, last_value(data_value) over (partition by step_index order by datastamp asc) RV into #T_ROMv from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(data_attribute )like 'ROMVersion'  and (sd.datastamp between @startdate and @enddate)

select distinct Step_index, last_value(data_value) over (partition by step_index order by datastamp asc) FW into #T_FirmW from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'FirmwareVersion' and (sd.datastamp between @startdate and @enddate) 

-- select distinct step_index, last_value(data_value) over (partition by step_index order by datastamp asc) udv into #T_Label_Assem from MES2_SERCOMM.dbo.process_step_data sd 
--where rtrim(data_attribute)like 'label field Assembly'  and (sd.datastamp between @startdate and @enddate)
select distinct Step_index , data_value udv into #T_Label_Assem from MES2_SERCOMM.dbo.process_step_data sd 
where rtrim(data_attribute)like 'label field Assembly'  and  (sd.DataStamp between @startdate and @enddate )

select distinct step_index, last_value(data_value) over (partition by step_index order by datastamp asc) RM into #T_RegM from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute )like 'RegCode'and (sd.datastamp between @startdate and @enddate)

select distinct Serial_Number, last_value(Mac_Id) over (partition by Serial_Number order by snta.Out_Process_Time asc) Mac_Id into #T_ASS from MES2_SERCOMM.dbo.sn_travel_assembly snta
   where len(snta.Mac_Id) = 12 and
 (snta.Mac_Id like '0006B1%' or snta.Mac_Id like '0017C5%' or  snta.Mac_Id like 'FFFFFF%'
or snta.Mac_Id like 'C0EAE4%' or snta.Mac_Id like '18B169%' or snta.Mac_Id like '004010%') and snta.Mac_Id <> 'N/A';

 with psr as
(select format(datastamp,'yyyyMMdd') datastampf, step_index, datastamp, station_type_code, Station_id, Serial_Number,[PN_Code],[Step_Result_Code],[Location_Code]
from MES2_SERCOMM.dbo.process_step_result ) --where datastamp between @sdtae and @edate)

select ts.Mac_Id SRNUM, 
 smv.SMV,
 romv.RV,
 fwv.FW,
 rm.RM,
 format(sr.datastamp,'yyyyMMdd') T_datekey,
 datepart(MI,sr.datastamp) T_min,
 datepart(HH,sr.datastamp) T_hour,
 sr.step_index,
 --dbo.fn_getdatavalue(sr.step_index, snta.Mac_Id,4) psdata, 
 '' psdata, 
 sr.PN_Code PartNumber,
 sr.Location_Code LC,
 sr.Step_Result_Code SRC,  
 ass.udv assem,
 sr.datastamp processdate,
 convert (varchar ,sr.station_type_code) STC,
 sr.Station_id STA
 
 into #T_fact
  from psr sr 
  inner join #T_ASS ts on sr.Serial_Number = ts.Serial_Number 
  left outer join #T_SMV smv on sr.step_index = smv.step_index 
  left outer join #T_ROMv romv on sr.step_index = romv.step_index 
  left outer join #T_RegM rm on sr.step_index = rm.step_index 
  left outer join #T_FirmW fwv on sr.step_index = fwv.step_index
  left outer join #T_Label_Assem ass on sr.step_index = ass.step_index 
  where 
 (sr.datastamp between @startdate and @enddate ) 

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
  4 datasourcekey,
   -1 [SKUKey],
    T_fact.step_index StepIndex,
  T_fact.psdata ProcessStepData,
   isnull(srcd.[StepResultCodeKey], -1) [StepResultCodeKey],
   isnull(l.[LocationKey], -1) [LocationKey],
   isnull(pnc.[PartNumberKey], -1) [PartNumberKey],   
  isnull(a.AssemblyKey, -1) AssemblyKey,
  -1 [WorkOrderKey],
  -1 [IsRMAKey],
  -1 [IRVKey],
  T_fact.processdate,
   isnull(stc.StationTypeKey,-1) StationTypeKey,
   isnull(sta.StationKey,-1) StationKey,
   -1 DateCodeKey
 
 
  into #MFTGSummary_F
  from #T_fact T_fact 
  left outer join SerialNumber_D sn on T_fact.SRNUM = sn.SerialNumber
  left outer join SafemodeVersion_D smv on T_fact.SMV = smv.SafemodeVersion
  left outer join ROMVersion_D rv on T_fact.RV = rv.ROMVersion 
  left outer join FirmwareVersion_D fwv on T_fact.FW = fwv.FirmwareVersion
  left outer join Assembly_D a on T_fact.assem = a.AssemblyNumber
  left outer join [Location_D] l on T_fact.LC= l.LocationCode
  left outer join [PartNumber_D] pnc on T_fact.PartNumber = pnc.PartNumberCode
  left outer join [StepResultCode_D] srcd on T_fact.SRC= srcd.[StepResultValue]
  left outer join Station_D sta on T_fact.STA = sta.Station
  left outer join StationType_D stc on T_fact.STC = stc.StationType;

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
	[MIDGroupKey]
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
	checksum(g.gmid) [MIDGroupKey]
	from #MFTGSummary_F tf
	left outer join #grp g on tf.SerialNumberKey = g.SerialNumberKey ;

   
   update etl_configuration.[dbo].[DataLoad_Log] set status =1 where loadid = @pLoadID;
  end
  end;