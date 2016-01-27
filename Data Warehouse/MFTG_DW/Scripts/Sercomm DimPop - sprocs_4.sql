
--exec sp_pop_assembly_Sercomm 6
use [MFTG_DW]
go
alter PROC sp_pop_assembly_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_Label_Assem as
(select distinct data_value udv from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(data_attribute)like 'label field Assembly' and  (sd.datastamp between @startdate and @enddate )) 

insert into [MFTG_DW].[dbo].[Assembly_D]([AssemblyKey],[AssemblyNumber])
select distinct isnull((select max([AssemblyKey]) from [MFTG_DW].[dbo].[Assembly_D] where [AssemblyKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.udv ), s.udv 
from T_Label_Assem s
left outer join [MFTG_DW].dbo.[Assembly_D] d on s.udv  = d.[AssemblyNumber]
where d.[AssemblyNumber] is null
end
end;

go
--sp_pop_serialnumber_Sercomm 6
alter PROC sp_pop_serialnumber_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_SN as
(select distinct snta.Mac_Id from MES2_SERCOMM.dbo.sn_travel_assembly snta
left outer join MES2_SERCOMM.dbo.process_step_data sd on sd.Serial_Number=snta.Mac_Id 
 where 
len(snta.Mac_Id) = 12 and
 (snta.Mac_Id like '0006B1%' or snta.Mac_Id like '0017C5%' or  snta.Mac_Id like 'FFFFFF%'
or snta.Mac_Id like 'C0EAE4%' or snta.Mac_Id like '18B169%' or snta.Mac_Id like '004010%') and (sd.datastamp between @startdate and @enddate ) )

insert into [MFTG_DW].[dbo].[SerialNumber_D]([SerialNumberKey],[SerialNumber],[AuthCode])
select  isnull((select max([SerialNumberKey]) from [MFTG_DW].dbo.[SerialNumber_D] where [SerialNumberKey]>-1),0) +
ROW_NUMBER() over (ORDER BY sn.Mac_Id), sn.Mac_Id,'U'
from T_SN sn 
left outer join [MFTG_DW].dbo.[SerialNumber_D] d on sn.Mac_Id = d.[SerialNumber]
where d.[SerialNumber] is null
end
end;
go

--Manufacturing_ID
--sp_pop_manufacturing_id_Sercomm 6
alter PROC sp_pop_manufacturing_id_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

select Serial_Number into #snr from 
(select distinct sr.Serial_Number from MES2_SERCOMM.dbo.process_step_result sr
union 
select distinct snta.Serial_Number from MES2_SERCOMM.dbo.sn_travel_assembly snta ) a


insert into [MFTG_DW].[dbo].[ManufacturingId_D]([MIDKey],[MID])
select isnull((select max([MIDKey]) from [MFTG_DW].dbo.[ManufacturingId_D] where [MIDKey]>-1),0)+
ROW_NUMBER() over (ORDER BY m.Serial_Number), m.Serial_Number
from #snr m
left outer join [MFTG_DW].dbo.[ManufacturingId_D] d on m.Serial_Number = d.[MID]
where d.[MID] is null
end
end;
go

--Firmware version
go


-- exec sp_pop_firmversion_Sercomm 6
alter PROC sp_pop_firmversion_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_FirmW as
(select distinct Data_Value FW from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'FirmwareVersion' and Data_Value is not null and (sd.datastamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].FirmwareVersion_D (FirmwareVersionKey,FirmwareVersion)
select distinct isnull((select max(FirmwareVersionKey)from [MFTG_DW].dbo.[FirmwareVersion_D] where [FirmwareVersionKey]>-1),0)+
ROW_NUMBER() over (ORDER BY s.FW),s.FW
from T_FirmW s
left outer join [MFTG_DW].dbo.[FirmwareVersion_D] d on s.FW = d.[FirmwareVersion]
where d.[FirmwareVersion] is null
end
end;
go

--ROM version

go
-- exec sp_pop_romversion_Sercomm 6
alter PROC sp_pop_romversion_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_ROMv as
(select distinct Data_Value RV from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'ROMVersion'and (sd.datastamp between @startdate and @enddate ))

insert into [MFTG_DW].dbo.ROMVersion_D(ROMVersionKey,ROMVersion)
select distinct isnull((select max([ROMVersionKey])from [MFTG_DW].dbo.[ROMVersion_D] where [ROMVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.RV),s.RV 
from T_ROMv s
left outer join [MFTG_DW].dbo.ROMVersion_D d on s.RV = d.ROMVersion
where d.ROMVersion is null
end
end;
go

go
--Safemode version
-- exec sp_pop_safemodeversion_Sercomm 6
alter PROC sp_pop_safemodeversion_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SMV as
(select distinct Data_Value SMV from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute )like 'SafeModeVersion'and (sd.datastamp between @startdate and @enddate ))
insert into [MFTG_DW].[dbo].[SafemodeVersion_D]([SafemodeVersionKey],[SafemodeVersion])
select  distinct isnull((select max([SafemodeVersionKey])from [MFTG_DW].dbo.[SafemodeVersion_D] where [SafemodeVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.SMV),s.SMV from T_SMV s
left outer join [MFTG_DW].dbo.[SafemodeVersion_D] d on s.SMV  = d.[SafemodeVersion]
where d.[SafemodeVersion] is null
end
end;
go

-- exec sp_pop_IRV_Sercomm 6
ALTER PROC sp_pop_IRV_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_IRV as
(select distinct Data_Value IRV from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'IRV' and (sd.datastamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].[IRV_D]([IRVKey],[IRV])
select distinct isnull((select max(IRVKey) 
from [MFTG_DW].dbo.[IRV_D] where [IRVKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.IRV),s.IRV
from T_IRV s
left outer join [MFTG_DW].dbo.[IRV_D] d on s.IRV = d.[IRV]
where d.[IRV] is null
end
end;
go


go
--Regmode
-- exec sp_pop_regulatorymodel_Sercomm 6
alter PROC sp_pop_regulatorymodel_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_RM as
(select distinct Data_Value RM from MES2_SERCOMM.dbo.process_step_data sd
where rtrim(Data_Attribute )like 'RegCode'and (sd.datastamp between @startdate and @enddate ))
insert into [MFTG_DW].[dbo].RegulatoryModel_D(RegulatoryModelKey,RegulatoryModel)
select  distinct isnull((select max(RegulatoryModelKey)from [MFTG_DW].dbo.RegulatoryModel_D where RegulatoryModelKey>-1),0)+
 ROW_NUMBER() over (ORDER BY s.RM),s.RM from T_RM s
left outer join [MFTG_DW].dbo.RegulatoryModel_D d on s.RM  = d.RegulatoryModel
where d.RegulatoryModel is null
end
end;
go

go
-- exec sp_pop_station_Sercomm 6
alter PROC sp_pop_station_Sercomm (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_S as
(select distinct(Station_id) STA from MES2_SERCOMM.dbo.process_step_result sr where (sr.datastamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].Station_D(StationKey,Station)
select  isnull((select max(StationKey) from [MFTG_DW].[dbo].Station_D where 
StationKey>-1),0) + ROW_NUMBER() over (ORDER BY s.STA ), s.STA
from T_S s
left outer join [MFTG_DW].dbo.Station_D d on s.STA  = d.Station
where d.Station is null
end
end;
go

go
