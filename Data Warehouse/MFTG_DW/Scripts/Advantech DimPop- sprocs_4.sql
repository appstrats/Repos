
--exec sp_pop_assembly_advantech 7
use [MFTG_DW]
go
create PROC sp_pop_assembly_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_Assem as
(select distinct data_value udv from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(data_attribute)like 'label field Assembly'  and  (sd.datestamp between @startdate and @enddate )
)

insert into [MFTG_DW].[dbo].[Assembly_D]([AssemblyKey],[AssemblyNumber])
select distinct isnull((select max([AssemblyKey]) from [MFTG_DW].[dbo].[Assembly_D] where [AssemblyKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.udv ), s.udv 
from T_Assem s
left outer join [MFTG_DW].dbo.[Assembly_D] d on s.udv  = d.[AssemblyNumber]
where d.[AssemblyNumber] is null
end
end;

go
--exec sp_pop_serialnumber_advantech 7
create PROC sp_pop_serialnumber_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_SN as
(select distinct serial_number from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where 
len(serial_number) = 12 and
 (serial_number like '0006B1%' or serial_number like '0017C5%' or  serial_number like 'FFFFFF%'
or serial_number like 'C0EAE4%' or serial_number like '18B169%' or serial_number like '004010%') and (sr.datestamp between @startdate and @enddate)),
T_Label_Auth as
(select serial_number, max(data_value) Authcode from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field AuthCode'  and (sd.datestamp between @startdate and @enddate)
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
end
go

--Manufacturing_ID
--exec sp_pop_manufacturing_id_advantech 7
create PROC sp_pop_manufacturing_id_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SN as
(select distinct serial_number from SHOPFLOOR_ADVANTECH.dbo.process_step_result where 
len(serial_number) = 12 and
 (serial_number like '0006B1%' or serial_number like '0017C5%' or  serial_number like 'FFFFFF%'
or serial_number like 'C0EAE4%' or serial_number like '18B169%' or serial_number like '004010%') ),
M_ID as
(select distinct  s.sn1
from [SHOPFLOOR_ADVANTECH].[dbo].sn_relation s
inner join T_SN sn on s.sn2 = sn.serial_number)
insert into [MFTG_DW].[dbo].[ManufacturingId_D]([MIDKey],[MID])
select isnull((select max([MIDKey]) from [MFTG_DW].dbo.[ManufacturingId_D] where [MIDKey]>-1),0)+
ROW_NUMBER() over (ORDER BY m.sn1), m.sn1
from M_ID m
left outer join [MFTG_DW].dbo.[ManufacturingId_D] d on m.sn1 = d.[MID]
where d.[MID] is null
end
end
go

--Firmware version
go


-- exec sp_pop_firmversion_advantech 7
create PROC sp_pop_firmversion_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_FirmW as
(select distinct Data_Value FW from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'FirmwareVersion' and Data_Value is not null and (sd.datestamp between @startdate and @enddate) 
)
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
-- exec sp_pop_romversion_advantech 7
create PROC sp_pop_romversion_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_ROMv as
(select distinct Data_Value RV from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'ROMVersion' and (sd.datestamp between @startdate and @enddate )
)
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
-- exec sp_pop_safemodeversion_advantech 7
create PROC sp_pop_safemodeversion_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SMV as
(select distinct Data_Value SMV from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(Data_Attribute )like 'SafeModeVersion' and (sd.datestamp between @startdate and @enddate )
)
insert into [MFTG_DW].[dbo].[SafemodeVersion_D]([SafemodeVersionKey],[SafemodeVersion])
select  distinct isnull((select max([SafemodeVersionKey])from [MFTG_DW].dbo.[SafemodeVersion_D] where [SafemodeVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.SMV),s.SMV from T_SMV s
left outer join [MFTG_DW].dbo.[SafemodeVersion_D] d on s.SMV  = d.[SafemodeVersion]
where d.[SafemodeVersion] is null
end
end;
go

-- exec sp_pop_IRV_advantech 7
create PROC sp_pop_IRV_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_IRV as
(select distinct Data_Value IRV from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(Data_Attribute) like 'IRV' and (sd.datestamp between @startdate and @enddate )
)

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
-- exec sp_pop_regulatorymodel_advantech 7
create PROC sp_pop_regulatorymodel_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_RM as
(select distinct Data_Value RM from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where rtrim(Data_Attribute )like 'RegCode' and (sd.datestamp between @startdate and @enddate )
)
insert into [MFTG_DW].[dbo].RegulatoryModel_D(RegulatoryModelKey,RegulatoryModel)
select  distinct isnull((select max(RegulatoryModelKey)from [MFTG_DW].dbo.RegulatoryModel_D where RegulatoryModelKey>-1),0)+
 ROW_NUMBER() over (ORDER BY s.RM),s.RM from T_RM s
left outer join [MFTG_DW].dbo.RegulatoryModel_D d on s.RM  = d.RegulatoryModel
where d.RegulatoryModel is null
end
end;
go

go
-- exec sp_pop_station_advantech 7
create PROC sp_pop_station_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_S as
(select distinct(Station_id) STA from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate )
)

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



--SKU
--exec sp_pop_SKU_advantech 7
create PROC sp_pop_SKU_advantech (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SKU as
(select distinct  data_value SKU from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where data_attribute like 'label field SKU'   and 
data_value not like '01-SSC-4321%' and data_value not like '01-SSC-1234%'  and (sd.datestamp between @startdate and @enddate )
)

insert into [MFTG_DW].[dbo].[SKU_D]([SKUKey],[SKU],[SKUDescription])
select distinct isnull((select max([SKUKey]) from [MFTG_DW].dbo.[SKU_D] where [SKUKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.SKU), s.SKU,s.SKU
from T_SKU s
left outer join [MFTG_DW].dbo.[SKU_D] d on s.SKU = d.[SKU]
where  d.[SKU] is null
end
end
go 


--exec sp_pop_Stationtype_advantech 7
create PROC sp_pop_Stationtype_advantech (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_STC as
(select distinct (cast(station_type_code as varchar)) STC  from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate)) 

insert into [MFTG_DW].[dbo].StationType_D(StationTypeKey,StationType)
select  isnull((select max(StationTypeKey) from [MFTG_DW].[dbo].StationType_D where StationTypeKey>-1),0) + ROW_NUMBER() over (ORDER BY s.STC ), s.STC
from T_STC s
left outer join [MFTG_DW].dbo.StationType_D d on s.STC  = d.StationType
where d.StationType is null
end
end;
go

--exec sp_pop_StepResultCode_advantech 7
create PROC sp_pop_StepResultCode_advantech (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SRC as
(select distinct (Step_Result_Code) SRC  from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate)) 

insert into [MFTG_DW].[dbo].StepResultCode_D(StepResultCodeKey,StepResultValue,[Description])
select  isnull((select max(StepResultCodeKey) from [MFTG_DW].[dbo].StepResultCode_D where StepResultCodeKey>-1),0) + ROW_NUMBER() over (ORDER BY s.SRC ), s.SRC,-1
from T_SRC s
left outer join [MFTG_DW].dbo.StepResultCode_D d on s.SRC  = d.StepResultValue
where d.StepResultValue is null
end
end;
go

--exec sp_pop_pn_Code_advantech 7
create PROC sp_pop_pn_Code_advantech (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_PNC as
(select distinct (PN_Code) PNC  from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate)) 

insert into [MFTG_DW].[dbo].PartNumber_D(PartNumberKey,PartNumberCode,PartNumber,Revision,[Description])
select  isnull((select max(PartNumberKey) from [MFTG_DW].[dbo].PartNumber_D where PartNumberKey>-1),0) + ROW_NUMBER() over (ORDER BY s.PNC), s.PNC, s.PNC,-1,-1
from T_PNC s
left outer join [MFTG_DW].dbo.PartNumber_D d on s.PNC  = d.PartNumberCode
where d.PartNumberCode is null
end
end;
go

--exec sp_pop_Location_Code_advantech 7
create PROC sp_pop_Location_Code_advantech (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_LC as
(select distinct (Location_Code) LC  from SHOPFLOOR_ADVANTECH.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate)) 

insert into [MFTG_DW].[dbo].Location_D(LocationKey,LocationCode,Location,Country)
select  isnull((select max(LocationKey) from [MFTG_DW].[dbo].Location_D where LocationKey>-1),0) + ROW_NUMBER() over (ORDER BY s.LC), s.LC, s.LC,-1
from T_LC s
left outer join [MFTG_DW].dbo.Location_D d on s.LC  = d.LocationCode
where d.LocationCode is null
end
end;
go

