use [MFTG_DW]
GO
--Assembly
-- exec sp_pop_assembly_UK 3
Create PROC sp_pop_assembly_UK (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_Label_Assem as
(select distinct data_value udv from MFGTESTC_UK.dbo.process_step_data sr
where data_attribute like 'label field Assembly' and  (sr.datestamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].[Assembly_D]([AssemblyKey],[AssemblyNumber])
select distinct isnull((select max([AssemblyKey]) from [MFTG_DW].[dbo].[Assembly_D] where [AssemblyKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.udv ), s.udv 
from T_Label_Assem s
left outer join [MFTG_DW].dbo.[Assembly_D] d on s.udv  = d.[AssemblyNumber]
where d.[AssemblyNumber] is null
end
end;

go

-- exec sp_pop_serialnum_UK 3
Create PROC sp_pop_serialnum_UK (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_SN as
(select distinct serial_number from MFGTESTC_UK.dbo.process_step_result sr where 
len(serial_number) = 12 and
 (serial_number like '0006B1%' or serial_number like '0017C5%' or  serial_number like 'FFFFFF%'
or serial_number like 'C0EAE4%' or serial_number like '18B169%' or serial_number like '004010%') and (sr.datestamp between @startdate and @enddate)),
T_Label_Auth as
(select serial_number, max(data_value) Authcode from MFGTESTC_UK.dbo.process_step_data 
where data_attribute like 'label field AuthCode'
group by serial_number),
sndata as
(select sn.serial_number,A.Authcode
from T_SN sn left outer join T_Label_Auth A on sn.serial_number = A.serial_number
)

insert into [MFTG_DW].[dbo].[SerialNumber_D]([SerialNumberKey],[SerialNumber],[AuthCode])
select  isnull((select max([SerialNumberKey]) from [MFTG_DW].dbo.[SerialNumber_D] where [SerialNumberKey]>-1),0) +
ROW_NUMBER() over (ORDER BY sn.serial_number), sn.serial_number,sn.Authcode
from sndata sn 
left outer join [MFTG_DW].dbo.[SerialNumber_D] d on sn.serial_number = d.[SerialNumber]
where d.[SerialNumber] is null

end
end;
go

--Manufacturing_ID
-- exec sp_pop_Manufacturing_ID_Senao 5
create PROC sp_pop_Manufacturing_ID_UK (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
select distinct r.sn2,r.sn1 into #snr from MFGTESTC_UK.dbo.sn_relation r;

with all_mid (sn, sn_1, lvl) as
(select distinct r.sn2, r.sn1 , 0 lvl
from MFGTESTC_UK.dbo.process_step_result sr
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

select distinct sn1 into #mids from #sn_mid

insert into [MFTG_DW].[dbo].[ManufacturingId_D]([MIDKey],[MID])
select isnull((select max([MIDKey]) from [MFTG_DW].dbo.[ManufacturingId_D] where [MIDKey]>-1),0)+
ROW_NUMBER() over (ORDER BY m.sn1), m.sn1
from #mids m
left outer join [MFTG_DW].dbo.[ManufacturingId_D] d on m.sn1 = d.[MID]
where d.[MID] is null
end
end;
go

--SKU
--exec sp_pop_SKU_UK 4
create PROC sp_pop_SKU_UK (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SKU as
(select distinct data_value SKU  from MFGTESTC_UK.dbo.process_step_data
where data_attribute ='label assembly part number' and  data_value like '01-SSC%'
and step_index in
(select step_index from MFGTESTC_UK.dbo.process_step_result where station_type_code in(1,4))
)

insert into [MFTG_DW].[dbo].[SKU_D]([SKUKey],[SKU],[SKUDescription])
select distinct isnull((select max([SKUKey]) from [MFTG_DW].dbo.[SKU_D] where [SKUKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.SKU), s.SKU,s.SKU
from T_SKU s
left outer join [MFTG_DW].dbo.[SKU_D] d on s.SKU = d.[SKU]
where  d.[SKU] is null
end
end;
go 


--Regulatory Model
--exec sp_pop_Regulatory_Model_UK 3
Create PROC sp_pop_Regulatory_Model_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_RM as
(select distinct data_value RM from MFGTESTC_UK.dbo.process_step_data sd
where data_attribute like 'label field RM' and (sd.datestamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].[RegulatoryModel_D]([RegulatoryModelKey],[RegulatoryModel])
select  isnull((select max([RegulatoryModelKey]) from [MFTG_DW].[dbo].[RegulatoryModel_D] where 
[RegulatoryModelKey]>-1),0) + ROW_NUMBER() over (ORDER BY s.RM ), s.RM
from T_RM s
left outer join [MFTG_DW].dbo.[RegulatoryModel_D] d on s.RM  = d.[RegulatoryModel]
where d.[RegulatoryModel] is null
end
end;
go



--Part number 
--exec sp_pop_Partnum_UK 3
Create PROC sp_pop_Partnum_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with newrows as
(
select distinct s.part_number, s.[description]
from MFGTESTC_UK.dbo.part_number s
left outer join [MFTG_DW].dbo.PartNumber_D d on s.part_number = d.PartNumber and s.[description] = d.[description]
where d.PartNumber is null and d.[description] is null
)

insert into [MFTG_DW] .[dbo].PartNumber_D(PartNumberKey,PartNumberCode,PartNumber,[Description])
select distinct isnull((select max([PartNumberKey]) from [MFTG_DW].dbo.[PartNumber_D] where [PartNumberKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.part_number),s.part_number,s.part_number, s.[description]
from newrows s

end
end;
go


--Location
--exec sp_Location_UK 3
Create PROC sp_Location_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
insert into [MFTG_DW].dbo.Location_D(LocationKey,LocationCode, Location,Country)
select distinct isnull((select max([LocationKey]) from [MFTG_DW].dbo.[Location_D] where [LocationKey]>-1),0) +
 ROW_NUMBER() over (ORDER BY s.location_name), s.location_code, s.location_name, s.country 
from [MFGTESTC_UK].[dbo].[mfg_location] s
left outer join [MFTG_DW].dbo.Location_D d on s.location_name = d.Location
where d.Location is null
end
end;
go


--Step result Code
--exec sp_Stepresult_code_UK 8
Create PROC sp_Stepresult_code_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
insert into [MFTG_DW].[dbo].[StepResultCode_D]([StepResultCodeKey],[StepResultValue],[Description])
select distinct isnull((select max([StepResultCodeKey]) from [MFTG_DW].dbo.[StepResultCode_D] where [StepResultCodeKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.[step_result_code]), s.[step_result_code],s.[description] 
from [MFGTESTC_UK].[dbo].[step_result_code] s
left outer join [MFTG_DW].dbo.[StepResultCode_D] d on s.[step_result_code] = d.[StepResultValue]
where d.[StepResultValue] is null
end
end;
go

--exec sp_pop_Firmware_UK 3
Create PROC sp_pop_Firmware_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_FirmW as
(select distinct data_value FW from MFGTESTC_UK.dbo.process_step_data sd 
where data_attribute like 'FirmwareVersion'  and (sd.datestamp between @startdate and @enddate))

insert into [MFTG_DW].[dbo].[FirmwareVersion_D]([FirmwareVersionKey],[FirmwareVersion])
select distinct isnull((select max(FirmwareVersionKey) 
from [MFTG_DW].dbo.[FirmwareVersion_D] where [FirmwareVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.FW),s.FW
from T_FirmW s
left outer join [MFTG_DW].dbo.[FirmwareVersion_D] d on s.FW = d.[FirmwareVersion]
where d.[FirmwareVersion] is null
end
end;
go

--exec sp_pop_ROMV_UK 3
Create PROC sp_pop_ROMV_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_ROMv as
(select distinct data_value RV from MFGTESTC_UK.dbo.process_step_data sd
where data_attribute like 'ROMVersion'  and (sd.datestamp between @startdate and @enddate))

insert into [MFTG_DW].dbo.ROMVersion_D(ROMVersionKey,ROMVersion)
select distinct isnull((select max([ROMVersionKey])from [MFTG_DW].dbo.[ROMVersion_D] where [ROMVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.RV),s.RV 
from T_ROMv s
left outer join [MFTG_DW].dbo.ROMVersion_D d on s.RV = d.ROMVersion
where d.ROMVersion is null
end
end;
go



--exec sp_pop_safemodever_UK 3
Create PROC sp_pop_safemodever_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SMV as
(select distinct data_value SMV from MFGTESTC_UK.dbo.process_step_data sd
where data_attribute like 'SafeModeVersion' and (sd.datestamp between @startdate and @enddate))
insert into [MFTG_DW].[dbo].[SafemodeVersion_D]([SafemodeVersionKey],[SafemodeVersion])
select  distinct isnull((select max([SafemodeVersionKey])from [MFTG_DW].dbo.[SafemodeVersion_D] where [SafemodeVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.SMV),s.SMV from T_SMV s
left outer join [MFTG_DW].dbo.[SafemodeVersion_D] d on s.SMV  = d.[SafemodeVersion]
where d.[SafemodeVersion] is null
end
end;
go


--exec sp_pop_Station_UK 3
Create PROC sp_pop_Station_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_S as
(select distinct(Station_id) STA from MFGTESTC_UK.dbo.process_step_result sr  where (sr.datestamp between @startdate and @enddate))

insert into [MFTG_DW].[dbo].Station_D(StationKey,Station)
select  isnull((select max(StationKey) from [MFTG_DW].[dbo].Station_D where 
StationKey>-1),0) + ROW_NUMBER() over (ORDER BY s.STA ), s.STA
from T_S s
left outer join [MFTG_DW].dbo.Station_D d on s.STA  = d.Station
where d.Station is null

end
end;
go


create PROC sp_pop_Stationtype_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_STC as
(select distinct(convert (varchar ,sr.station_type_code)) STC  from MFGTESTC_UK.dbo.process_step_result sr  
where (sr.datestamp between @startdate and @enddate))

insert into [MFTG_DW].[dbo].StationType_D(StationTypeKey,StationType)
select  isnull((select max(StationTypeKey) from [MFTG_DW].[dbo].StationType_D where StationTypeKey>-1),0) + ROW_NUMBER() over (ORDER BY s.STC ), s.STC
from T_STC s
left outer join [MFTG_DW].dbo.StationType_D d on s.STC  = d.StationType
where d.StationType is null
end
end;
go




--exec sp_pop_datecode_UK 3
Create PROC sp_pop_datecode_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_DC as
(select distinct format(datestamp,'yyyyMMdd') DC  from MFGTESTC_UK.dbo.process_step_result sr  where (sr.datestamp between @startdate and @enddate) )

insert into [MFTG_DW].[dbo].DateCode_D(DateCodeKey,DateCode)
select  isnull((select max(DateCodeKey) from [MFTG_DW].[dbo].DateCode_D where 
DateCodeKey>-1),0) + ROW_NUMBER() over (ORDER BY s.DC ), s.DC
from T_DC s
left outer join [MFTG_DW].dbo.DateCode_D d on s.DC  = d.DateCode
where d.DateCode is null

end
end;
go

--exec sp_pop_RFID_UK 8
create PROC sp_pop_RFID_UK (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_RFID as
(select distinct  data_value RFID from MFGTESTC_UK.dbo.process_step_data sd
where data_attribute like '%RFID%'   and 
data_value not like '01-SSC-4321%' and data_value not like '01-SSC-1234%'  and (sd.datestamp between @startdate and @enddate )
)

insert into [MFTG_DW].[dbo].[RFID_D]([RFIDKey],[RFID],[RFIDDescription])
select distinct isnull((select max([RFIDKey]) from [MFTG_DW].dbo.[RFID_D] where [RFIDKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.RFID), s.RFID,s.RFID
from T_RFID s
left outer join [MFTG_DW].dbo.[RFID_D] d on s.RFID = d.[RFID]
where  d.[RFID] is null
end
end;
go