select 'TransactionHourKey',count(TransactionHourKey)  from dbo.MFTGSummary_F 
union all
select 'SerialNumberKey',count(SerialNumberKey) from dbo.MFTGSummary_F 
union all
select 'MFTGSummaryKey',count(MFTGSummaryKey) from dbo.MFTGSummary_F 
union all
select 'MFTGSummaryCount',count(MFTGSummaryCount) from dbo.MFTGSummary_F 
union all
select 'SafemodeVersionKey',count(SafemodeVersionKey) from dbo.MFTGSummary_F 
union all
select 'ROMVersionKey',count(ROMVersionKey) from dbo.MFTGSummary_F 
union all
select 'FirmwareVersionKey',count(FirmwareVersionKey) from dbo.MFTGSummary_F 
union all
select 'RegulatoryModelKey',count(RegulatoryModelKey) from dbo.MFTGSummary_F 
union all
select 'TransactionDateKey',count(TransactionDateKey) from dbo.MFTGSummary_F 
union all
select 'TransactionMinuteKey',count(TransactionMinuteKey) from dbo.MFTGSummary_F 
union all
select 'DataSourceKey',count(DataSourceKey) from dbo.MFTGSummary_F 
union all
select 'SKUKey',count(SKUKey) from dbo.MFTGSummary_F 
union all
select 'StepIndex',count(StepIndex) from dbo.MFTGSummary_F 
union all
select 'ProcessStepData',count(ProcessStepData) from dbo.MFTGSummary_F 
union all
select 'StepResultCodeKey',count(StepResultCodeKey) from dbo.MFTGSummary_F 
union all
select 'LocationKey',count(LocationKey) from dbo.MFTGSummary_F 
union all
select 'PartNumberKey',count(PartNumberKey) from dbo.MFTGSummary_F 
union all
select 'AssemblyKey',count(AssemblyKey) from dbo.MFTGSummary_F 
union all
select 'WorkOrderKey',count(WorkOrderKey) from dbo.MFTGSummary_F 
union all
select 'IsRMAKey',count(IsRMAKey) from dbo.MFTGSummary_F 
union all
select 'IRVKey',count(IRVKey) from dbo.MFTGSummary_F 
union all
select 'ProcessDate',count(ProcessDate) from dbo.MFTGSummary_F 
union all
select 'StationTypeKey',count(StationTypeKey) from dbo.MFTGSummary_F 
union all
select 'StationKey',count(StationKey) from dbo.MFTGSummary_F 
union all
select 'DateCodeKey',count(DateCodeKey) from dbo.MFTGSummary_F 
union all
select 'MIDGroupKey',count(MIDGroupKey) from dbo.MFTGSummary_F 
union all
select 'Total count of Rows in F_Table' as keyname,count(*) from MFTGSummary_F 

