use [CFC_DW]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].sp_populate_date_dim'))
DROP PROC [dbo].sp_populate_date_dim
go
create PROC sp_populate_date_dim (@pyear char(4)) as
begin
set nocount on
declare @yyyy  char(4)
declare @dtcur	date
declare @datedetail table ([DateKey] [int] NOT NULL,
	[DateVal] [date] NULL,
	[DateDesc] [varchar](50) NULL,
	[CalenderMonth] [int] NULL,
	[CalenderMonthDesc] [varchar](50) NULL,
	[CalenderQuarter] [varchar](50) NULL,
	[CalenderQuarterDesc] [varchar](50) NULL,
    [CalenderYear] [int]  null);
	 
if not exists(select * from [dbo].[Dim_Date] where [CalenderYear]= @pyear)
begin

set @dtcur=@pyear+'0101'

while (datepart(year, @dtcur)=@pyear)
begin
insert into @datedetail (
[DateKey], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear])
select 
format(@dtcur,'yyyyMMdd'),
@dtcur,
format(@dtcur,'MMM dd, yyyy'),
DATEPART(MM,@dtcur),
Datename(MM,@dtcur),
case when DATEPART(MM,@dtcur) between 1 and 3 then 1
when DATEPART(MM,@dtcur) between 4 and 6 then 2 
when DATEPART(MM,@dtcur) between 7 and 9 then 3 else 4 end ,
case when DATEPART(MM,@dtcur) between 1 and 3 then 'Q1'
when DATEPART(MM,@dtcur) between 4 and 6 then 'Q2' 
when DATEPART(MM,@dtcur) between 7 and 9 then 'Q3' else 'Q4' end,
DATEPART(YEAR,@dtcur) ;

set @dtcur = DATEADD(D,1, @dtcur)
end

insert into [dbo].[Dim_Date] ([Date_Key], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear]
	 )
select [DateKey], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear]
	
	 from @datedetail
end
set nocount off
end