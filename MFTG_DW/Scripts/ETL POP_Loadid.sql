--exec sp_create_Load 'MFGTESTC_TAIWAN'
declare @loadid as int
exec @loadid = sp_create_Load 'MFGTESTC_FREMONT'
print @loadid

alter PROC sp_create_Load (@pDatasource varchar(50)) as
begin
set nocount on
declare @startdate  datetime
declare @enddate	datetime
declare @loadid as int
declare @maxLoadID	int
if (@pDatasource ='MFGTESTC_FREMONT')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_FREMONT')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_FREMONT.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_FREMONT' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_FREMONT.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
end
end

if (@pDatasource ='SENAO_MFGTESTC_TAIWAN')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='SENAO_MFGTESTC_TAIWAN')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='SENAO_MFGTESTC_TAIWAN' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from SENAO_MFGTESTC_TAIWAN.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 
 if (@pDatasource ='MFGTESTC_UK')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_UK')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_UK.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_UK' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_UK.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 if (@pDatasource ='MES2_SERCOMM')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MES2_SERCOMM')
begin

select @startdate =min(datastamp), @enddate = max(datastamp) from MES2_SERCOMM.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MES2_SERCOMM' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datastamp), @enddate = max(datastamp) from MES2_SERCOMM.dbo.process_step_result
where datastamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 
 if (@pDatasource ='MFGTESTC_TAIWAN_SERCOMM')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_TAIWAN_SERCOMM')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_TAIWAN_SERCOMM.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_TAIWAN_SERCOMM' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datastamp), @enddate = max(datastamp) from MES2_SERCOMM.dbo.process_step_result
where datastamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 if (@pDatasource ='MFGTESTC_ADVANTECH')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_ADVANTECH')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_ADVANTECH.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_ADVANTECH' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_ADVANTECH.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
if (@pDatasource ='SHOPFLOOR_ADVANTECH')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='SHOPFLOOR_ADVANTECH')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from SHOPFLOOR_ADVANTECH.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='SHOPFLOOR_ADVANTECH' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from SHOPFLOOR_ADVANTECH.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 if (@pDatasource ='MFGTESTC_TAIWAN')
begin 
if not exists(select * From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_TAIWAN')
begin

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_TAIWAN.dbo.process_step_result

Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Initial Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)

end
else
begin
select @maxLoadID = max(loadid) From [dbo].[DataLoad_Log] where datasource ='MFGTESTC_TAIWAN' and [status]=1

select @enddate = EndDate from [dbo].[DataLoad_Log] where loadid = @maxLoadID

select @startdate =min(datestamp), @enddate = max(datestamp) from MFGTESTC_TAIWAN.dbo.process_step_result
where datestamp > @enddate
 
 if @startdate is not null and @enddate is not null
 begin
 Insert into [dbo].[DataLoad_Log](LoadDescription, DataSource, LoadID,StartDate,EndDate,Status)
values
('Incremental Load', @pDatasource, isnull((select max(LoadID) from [dbo].[DataLoad_Log]
 where LoadID>-1),0) + 1, @startdate, @enddate, null)
 end
 end
 end
 select max(LoadID) LoadID from [dbo].[DataLoad_Log]  where datasource = @pDatasource
end
go