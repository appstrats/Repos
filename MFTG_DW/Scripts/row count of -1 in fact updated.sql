select 'TransactionHourKey',datasourcekey,sum(case when [TransactionHourKey] = -1 then 1 else 0 end), count(*) totalcount from dbo.MFTGSummary_F group by datasourcekey 
union all  
select 'SerialNumberKey',datasourcekey,sum(case when SerialNumberKey = -1 then 1 else 0 end), count(*) totalcount  from dbo.MFTGSummary_F group by datasourcekey 
union all  
select 'MFTGSummaryKey',datasourcekey,sum(case when  MFTGSummaryKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F group by datasourcekey 
union all  
select 'MFTGSummaryCount',datasourcekey,sum(case when  MFTGSummaryCount = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'SafemodeVersionKey',datasourcekey,sum(case when SafemodeVersionKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F group by datasourcekey 
union all  
select 'ROMVersionKey',datasourcekey,sum(case when ROMVersionKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'FirmwareVersionKey',datasourcekey,sum(case when FirmwareVersionKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'RegulatoryModelKey',datasourcekey,sum(case when  RegulatoryModelKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'TransactionDateKey',datasourcekey,sum(case when  TransactionDateKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'TransactionMinuteKey',datasourcekey,sum(case when  TransactionMinuteKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'DataSourceKey',datasourcekey,sum(case when DataSourceKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'SKUKey',datasourcekey,sum(case when SKUKey= -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'StepIndex',datasourcekey,sum(case when StepIndex = -1 then 1 else 0 end), count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'ProcessStepData',datasourcekey,sum(case when ProcessStepData  is null then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'StepResultCodeKey',datasourcekey,sum(case when StepResultCodeKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'LocationKey',datasourcekey,sum(case when LocationKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'PartNumberKey',datasourcekey,sum(case when PartNumberKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'AssemblyKey',datasourcekey,sum(case when AssemblyKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'WorkOrderKey',datasourcekey,sum(case when WorkOrderKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'IsRMAKey',datasourcekey,sum(case when IsRMAKey= -1  then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F group by datasourcekey 
union all  
select 'IRVKey',datasourcekey,sum(case when IRVKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'ProcessDate',datasourcekey,sum(case when ProcessDate  = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'StationTypeKey',datasourcekey,sum(case when StationTypeKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'StationKey',datasourcekey,sum(case when StationKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'DateCodeKey',datasourcekey,sum(case when DateCodeKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
union all  
select 'MIDGroupKey',datasourcekey,sum(case when MIDGroupKey = -1 then 1 else 0 end) , count(*) totalcount  from dbo.MFTGSummary_F  group by datasourcekey 
