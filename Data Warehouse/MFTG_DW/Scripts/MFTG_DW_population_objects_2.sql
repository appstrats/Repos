use [MFTG_DW]
go
-- exec sp_populate_trandate '2007'
create PROC sp_populate_trandate (@pyear char(4)) as
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
--select dbo.fn_getdatavalue(2,'0006B12E7D3F',8) 
create function dbo.fn_getdatavalue(@pstep_idx as int, @psn as varchar(100),@pdatasource_id as int) returns varchar(4000) as
begin
declare @data_att_val varchar(4000)
set @data_att_val = ''
if (@pdatasource_id = 1)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MFGTESTC_FREMONT.dbo.process_step_data sd
where sd.step_index = @pstep_idx and sd.serial_number = @psn

end
if (@pdatasource_id = 2)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from SENAO_MFGTESTC_TAIWAN.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 3)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MFGTESTC_UK.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 4)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MES2_SERCOMM.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 8)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MFGTESTC_TAIWAN_SERCOMM.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 9)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MFGTESTC_ADVANTECH.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 10)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from SHOPFLOOR_ADVANTECH.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
if (@pdatasource_id = 11)
begin 
select @data_att_val = @data_att_val + sd.data_attribute + '¬' + sd.data_value + '¶' from MFGTESTC_TAIWAN.dbo.process_step_data sd
where sd.step_index = @pstep_idx 

end
return @data_att_val
end
go



create  VIEW [dbo].[MFTGSummary_MV]
WITH SCHEMABINDING
AS
    SELECT TransactionHourKey,SerialNumberKey , MFTGSummaryKey , MFTGSummaryCount , SafemodeVersionKey , ROMVersionKey ,
	FirmwareVersionKey,RegulatoryModelKey,TransactionDateKey,TransactionMinuteKey,DataSourceKey,SKUKey,StepIndex,ProcessStepData,
	StepResultCodeKey,LocationKey,PartNumberKey,AssemblyKey,WorkOrderKey,IsRMAKey,IRVKey,StationTypeKey,StationKey,DateCodeKey,MIDGroupKey
FROM (
 SELECT  TransactionHourKey,SerialNumberKey ,MFTGSummaryKey,MFTGSummaryCount,SafemodeVersionKey,
 ROMVersionKey,FirmwareVersionKey,	 RegulatoryModelKey,TransactionDateKey,TransactionMinuteKey,DataSourceKey,
 SKUKey,StepIndex,ProcessStepData,StepResultCodeKey,LocationKey,
	  PartNumberKey,AssemblyKey,WorkOrderKey,IsRMAKey,IRVKey,StationTypeKey,StationKey,DateCodeKey,MIDGroupKey,
  ROW_NUMBER() OVER (PARTITION BY SerialNumberKey ORDER BY TransactionDateKey DESC) Fact_Row_Num
 FROM dbo.MFTGSummary_F )
tmp WHERE Fact_Row_Num = 1

go