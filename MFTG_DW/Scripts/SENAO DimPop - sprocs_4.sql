-- exec sp_pop_assembly_Senao 2
use [MFTG_DW]
go
Create PROC sp_pop_SENAO_Assembly_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_Label_Assem as
(select distinct data_value udv from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sr
where rtrim(data_attribute)like 'label_field_Assembly' and  (sr.datestamp between @startdate and @enddate )) 

insert into [MFTG_DW].[dbo].[Assembly_D]([AssemblyKey],[AssemblyNumber])
select distinct isnull((select max([AssemblyKey]) from [MFTG_DW].[dbo].[Assembly_D] where [AssemblyKey]>-1),0) +
ROW_NUMBER() over (ORDER BY s.udv ), s.udv 
from T_Label_Assem s
left outer join [MFTG_DW].dbo.[Assembly_D] d on s.udv  = d.[AssemblyNumber]
where d.[AssemblyNumber] is null
end
end;

go
-- exec sp_pop_serialnum_Senao 2
Create PROC sp_pop_SENAO_SerialNumber_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_SN as
(select distinct serial_number from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr where 
len(serial_number) = 12 and
 (serial_number like '0006B1%' or serial_number like '0017C5%' or  serial_number like 'FFFFFF%'
or serial_number like 'C0EAE4%' or serial_number like '18B169%' or serial_number like '004010%') and (sr.datestamp between @startdate and @enddate ) )

insert into [MFTG_DW].[dbo].[SerialNumber_D]([SerialNumberKey],[SerialNumber],[AuthCode])
select  isnull((select max([SerialNumberKey]) from [MFTG_DW].dbo.[SerialNumber_D] where [SerialNumberKey]>-1),0) +
ROW_NUMBER() over (ORDER BY sn.serial_number), sn.serial_number,'unknown'
from T_SN sn 
left outer join [MFTG_DW].dbo.[SerialNumber_D] d on sn.serial_number = d.[SerialNumber]
where d.[SerialNumber] is null
end
end;
go

--Manufacturing_ID
-- exec sp_pop_SENAO_ManufacturingID_D 5
create PROC sp_pop_SENAO_ManufacturingID_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
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

select distinct combination_serial_number into #mids from #sn_mid

insert into [MFTG_DW].[dbo].[ManufacturingId_D]([MIDKey],[MID])
select isnull((select max([MIDKey]) from [MFTG_DW].dbo.[ManufacturingId_D] where [MIDKey]>-1),0)+
ROW_NUMBER() over (ORDER BY m.combination_serial_number), m.combination_serial_number
from #mids m
left outer join [MFTG_DW].dbo.[ManufacturingId_D] d on m.combination_serial_number = d.[MID]
where d.[MID] is null
end
end;
go

--Part number process_date
go
-- exec sp_pop_Partnum_Senao 2
Create PROC sp_pop_SENAO_PartNumber_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_PART as 
(select distinct part_number PN ,part_description from SENAO_MFGTESTC_TAIWAN.dbo.process_results s 
where (s.process_date between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].PartNumber_D(PartNumberKey,PartNumberCode,PartNumber,Revision,[Description])
select distinct isnull((select max([PartNumberKey]) from [MFTG_DW].dbo.[PartNumber_D] where [PartNumberKey]>-1),0)+
ROW_NUMBER() over (ORDER BY s.PN),-1 pn_Code, s.PN, 'u', s.part_description
from T_PART s
left outer join [MFTG_DW].dbo.PartNumber_D d on s.PN = d.PartNumber
where d.PartNumber is null 
end
end;
go


--Firmware version
go


-- exec sp_pop_Firmware_Senao 2
Create PROC sp_pop_SENAO_FirmwareVersion_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_FirmW as
(select distinct data_value FW from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sd
where rtrim(data_attribute )like 'Firmware_Version' and (sd.datestamp between @startdate and @enddate ))

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

--ROM version

go
-- exec sp_pop_ROMV_Senao 2
Create PROC sp_pop_SENAO_ROMVersion_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_ROMv as
(select distinct data_value RV from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sd
where rtrim(data_attribute )like 'ROM_Version'and (sd.datestamp between @startdate and @enddate ))

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
-- exec sp_pop_safemodever_Senao 2
Create PROC sp_pop_SENAO_SafemodeVersion_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_SMV as
(select distinct data_value SMV from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sd
where rtrim(data_attribute )like 'Safemode_Version'and (sd.datestamp between @startdate and @enddate ))
insert into [MFTG_DW].[dbo].[SafemodeVersion_D]([SafemodeVersionKey],[SafemodeVersion])
select  distinct isnull((select max([SafemodeVersionKey])from [MFTG_DW].dbo.[SafemodeVersion_D] where [SafemodeVersionKey]>-1),0)+
 ROW_NUMBER() over (ORDER BY s.SMV),s.SMV from T_SMV s
left outer join [MFTG_DW].dbo.[SafemodeVersion_D] d on s.SMV  = d.[SafemodeVersion]
where d.[SafemodeVersion] is null
end
end;
go

go
-- exec sp_pop_Station_Senao 2
Create PROC sp_pop_SENAO_Station_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_S as
(select distinct(Station_id) STA from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr where (sr.datestamp between @startdate and @enddate ))

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
--Station TYPE
-- exec sp_pop_Stationtype_Senao 2
Create PROC sp_pop_SENAO_StationType_D (@pLoadID int) as
begin
set nocount on

declare @startdate  datetime
declare @enddate	datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin

with T_STC as
(select distinct(station_type_code) STC  from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result sr 
where (sr.datestamp between @startdate and @enddate ))

insert into [MFTG_DW].[dbo].StationType_D(StationTypeKey,StationType)
select  isnull((select max(StationTypeKey) from [MFTG_DW].[dbo].StationType_D 
where StationTypeKey>-1),0) + ROW_NUMBER() over (ORDER BY s.STC ), s.STC
from T_STC s
left outer join [MFTG_DW].dbo.StationType_D d on s.STC  = d.StationTypeKey
where d.StationType is null
end
end;
go

--exec sp_pop_SENAO_RFID_D 4
create PROC sp_pop_SENAO_RFID_D (@pLoadID int) as
begin
set nocount on
declare @startdate  datetime
declare @enddate  datetime

select @startdate = StartDate, @enddate = EndDate  from etl_configuration.dbo.DataLoad_Log where loadid = @pLoadID
if (@startdate is not null and @enddate is not null)
begin
with T_RFID as
(select distinct  data_value RFID from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sd
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


