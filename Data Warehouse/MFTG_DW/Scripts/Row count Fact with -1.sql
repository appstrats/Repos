select 'TransactionHourKey',count(TransactionHourKey)  from dbo.MFTGSummary_F where [TransactionHourKey] = -1
union all
select 'SerialNumberKey',count(SerialNumberKey) from dbo.MFTGSummary_F where SerialNumberKey = -1
union all
select 'MFTGSummaryKey',count(MFTGSummaryKey) from dbo.MFTGSummary_F where MFTGSummaryKey = -1
union all
select 'MFTGSummaryCount',count(MFTGSummaryCount) from dbo.MFTGSummary_F where MFTGSummaryCount = -1
union all
select 'SafemodeVersionKey',count(SafemodeVersionKey) from dbo.MFTGSummary_F where SafemodeVersionKey = -1
union all
select 'ROMVersionKey',count(ROMVersionKey) from dbo.MFTGSummary_F where ROMVersionKey = -1
union all
select 'FirmwareVersionKey',count(FirmwareVersionKey) from dbo.MFTGSummary_F where FirmwareVersionKey = -1
union all
select 'RegulatoryModelKey',count(RegulatoryModelKey) from dbo.MFTGSummary_F where RegulatoryModelKey = -1
union all
select 'TransactionDateKey',count(TransactionDateKey) from dbo.MFTGSummary_F where TransactionDateKey = -1
union all
select 'TransactionMinuteKey',count(TransactionMinuteKey) from dbo.MFTGSummary_F where TransactionMinuteKey = -1
union all
select 'DataSourceKey',count(DataSourceKey) from dbo.MFTGSummary_F where DataSourceKey = -1
union all
select 'SKUKey',count(SKUKey) from dbo.MFTGSummary_F where SKUKey= -1
union all
select 'StepIndex',count(StepIndex) from dbo.MFTGSummary_F where StepIndex = -1
union all
select 'ProcessStepData',count(ProcessStepData) from dbo.MFTGSummary_F where ProcessStepData  = -1
union all
select 'StepResultCodeKey',count(StepResultCodeKey) from dbo.MFTGSummary_F where StepResultCodeKey = -1
union all
select 'LocationKey',count(LocationKey) from dbo.MFTGSummary_F where LocationKey = -1
union all
select 'PartNumberKey',count(PartNumberKey) from dbo.MFTGSummary_F where PartNumberKey = -1
union all
select 'AssemblyKey',count(AssemblyKey) from dbo.MFTGSummary_F where AssemblyKey = -1
union all
select 'WorkOrderKey',count(WorkOrderKey) from dbo.MFTGSummary_F where WorkOrderKey = -1
union all
select 'IsRMAKey',count(IsRMAKey) from dbo.MFTGSummary_F where IsRMAKey= -1
union all
select 'IRVKey',count(IRVKey) from dbo.MFTGSummary_F where IRVKey = -1
union all
select 'ProcessDate',count(ProcessDate) from dbo.MFTGSummary_F where ProcessDate  = -1
union all
select 'StationTypeKey',count(StationTypeKey) from dbo.MFTGSummary_F where StationTypeKey = -1
union all
select 'StationKey',count(StationKey) from dbo.MFTGSummary_F where StationKey = -1
union all
select 'DateCodeKey',count(DateCodeKey) from dbo.MFTGSummary_F where DateCodeKey = -1
union all
select 'MIDGroupKey',count(MIDGroupKey) from dbo.MFTGSummary_F where MIDGroupKey = -1

