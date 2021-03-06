use [MFTG_DW]
go
-- sp_populate_trandate '2021'
Create PROC sp_populate_trandate (@pyear char(4)) as
begin
set nocount on
declare @yyyy  char(4)
declare @dtcur	date
declare @datedetail table ([TransactionDateKey] [int] NOT NULL,
	[TransactionDate] [date] NULL,
	[TransactionDateDesc] [varchar](50) NULL,
	[TransactionMonth] [int] NULL,
	[TransactionMonthDesc] [varchar](50) NULL,
	[TransactionQuarter] [varchar](50) NULL,
	[TransactionQuarterDesc] [varchar](50) NULL,
    [TransactionYear] [int]  null ,
	[TransactionDellQuarter] [varchar](50) NULL,
	[TransactionDellQuarterDesc] [varchar](50) NULL,
	[TransactionDellYar] [int] );
	 
if not exists(select * from [dbo].[TransactionDate_D] where [TransactionYear]= @pyear)
begin

set @dtcur=@pyear+'0101'

while (datepart(year, @dtcur)=@pyear)
begin
insert into @datedetail ([TransactionDateKey], [TransactionDate],[TransactionDateDesc], [TransactionMonth], [TransactionMonthDesc],[TransactionQuarter],
[TransactionQuarterDesc],[TransactionYear],[TransactionDellQuarter],[TransactionDellQuarterDesc],[TransactionDellYar])
select format(@dtcur,'yyyyMMdd'),@dtcur ,format(@dtcur,'MMM dd, yyyy'),DATEPART(MM,@dtcur),Datename(MM,@dtcur),case when DATEPART(MM,@dtcur) between 2 and 4 then 1
when DATEPART(MM,@dtcur) between 5 and 7 then 2 when DATEPART(MM,@dtcur) between 8 and 10 then 3 else 4 end , case when DATEPART(MM,@dtcur) between 2 and 4 then 'Q1'
when DATEPART(MM,@dtcur) between 5 and 7 then 'Q2' when DATEPART(MM,@dtcur) between 8 and 10 then 'Q3' else 'Q4' end,DATEPART(YEAR,@dtcur),
DATENAME(QUARTER,@dtcur) ,DATEPART(QUARTER,@dtcur),DATEPART(YEAR,@dtcur)+1 ;


set @dtcur = DATEADD(D,1, @dtcur)
end

insert into [dbo].[TransactionDate_D] ([TransactionDateKey] ,
	[TransactionDate] ,
	[TransactionDateDesc] ,
	[TransactionMonth] ,
	[TransactionMonthDesc],
	[TransactionQuarter] ,
	[TransactionQuarterDesc],
	[TransactionYear],
	[TransactionDellQuarter] ,
	[TransactionDellQuarterDesc],
	[TransactionDellYar]
	 )
select [TransactionDateKey] ,
	[TransactionDate] ,
	[TransactionDateDesc] ,
	[TransactionMonth] ,
	[TransactionMonthDesc],
	[TransactionQuarter] ,
	[TransactionQuarterDesc],
	[TransactionYear],
    [TransactionDellQuarter],
	[TransactionDellQuarterDesc],
	[TransactionDellYar]
	
	 from @datedetail
end
set nocount off
end

go
--select dbo.fn_getdatavalue(2,'0006B12E7D3F') 
create function dbo.fn_getdatavalue(@pstep_idx as int, @psn as varchar(100)) returns varchar(4000) as
begin
declare @data_att_val varchar(4000)
set @data_att_val = ''
select @data_att_val = @data_att_val + sd.data_attribute + ':' + sd.data_value + ';' from MFGTESTC_FREMONT.dbo.process_step_data sd
where sd.step_index = @pstep_idx and sd.serial_number = @psn
return @data_att_val
end

go

use [ETL_Configuration]

go
--exec sp_create_Load 'MFGTESTC_FREMONT'

Create PROC sp_create_Load (@pDatasource varchar(50)) as
begin
set nocount on
declare @startdate  datetime
declare @enddate	datetime
declare @maxLoadID	int

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


End

go