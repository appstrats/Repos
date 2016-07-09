EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'MFTG_DW'
GO
USE [master]
GO
ALTER DATABASE [MFTG_DW] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
DROP DATABASE [MFTG_DW]
GO

USE Master
GO
CREATE DATABASE [MFTG_DW]
GO
USE [MFTG_DW]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Assembly_D]') AND type in (N'U'))
    DROP TABLE [dbo].[Assembly_D]
GO
CREATE TABLE [dbo].[Assembly_D] (
[AssemblyNumber] varchar(50)  NOT NULL  
, [AssemblyKey] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[Assembly_D] ADD CONSTRAINT [Assembly_D_PK] PRIMARY KEY CLUSTERED (
[AssemblyKey]
)
GO
CREATE UNIQUE  INDEX [Assembly_UQ] ON [dbo].[Assembly_D] (
[AssemblyNumber]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SerialNumber_D]') AND type in (N'U'))
    DROP TABLE [dbo].[SerialNumber_D]
GO
CREATE TABLE [dbo].[SerialNumber_D] (
[SerialNumberKey] int  NOT NULL  
, [SerialNumber] char(12)  NOT NULL  
, [AuthCode] char(10)  NULL  
)
GO

ALTER TABLE [dbo].[SerialNumber_D] ADD CONSTRAINT [SerialNumber_D_PK] PRIMARY KEY CLUSTERED (
[SerialNumberKey]
)
GO
CREATE UNIQUE  INDEX [SN_UQ] ON [dbo].[SerialNumber_D] (
[SerialNumber]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionHour_D]') AND type in (N'U'))
    DROP TABLE [dbo].[TransactionHour_D]
GO
CREATE TABLE [dbo].[TransactionHour_D] (
[TransactionHourKey] int  NOT NULL  
, [TransactionHour] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[TransactionHour_D] ADD CONSTRAINT [TransactionHour_D_PK] PRIMARY KEY CLUSTERED (
[TransactionHourKey]
)
GO
CREATE UNIQUE  INDEX [TransactionHour_UQ] ON [dbo].[TransactionHour_D] (
[TransactionHour]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ErrorLog]') AND type in (N'U'))
    DROP TABLE [dbo].[ErrorLog]
GO
CREATE TABLE [dbo].[ErrorLog] (
[ErrorLogKey] int  NOT NULL  
, [SerialNumber] char(30)  NOT NULL  
, [StepIndex] int  NOT NULL  
, [ProcessStepData] varchar(max)  NULL  
, [DataSourceKey] int  NOT NULL  
, [TransactionDateKey] int  NULL  
, [TransactionMinuteKey] int  NULL  
, [TransactionHourKey] int  NULL  
)
GO

ALTER TABLE [dbo].[ErrorLog] ADD CONSTRAINT [ErrorLog_PK] PRIMARY KEY CLUSTERED (
[ErrorLogKey]
)
GO
CREATE   INDEX [SerialNumber_IX] ON [dbo].[ErrorLog] (
[SerialNumber]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManufacturingID_D]') AND type in (N'U'))
    DROP TABLE [dbo].[ManufacturingID_D]
GO
CREATE TABLE [dbo].[ManufacturingID_D] (
[MIDKey] int  NOT NULL  
, [MID] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[ManufacturingID_D] ADD CONSTRAINT [ManufacturingID_D_PK] PRIMARY KEY CLUSTERED (
[MIDKey]
)
GO
CREATE UNIQUE  INDEX [MID_UQ] ON [dbo].[ManufacturingID_D] (
[MID]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionDate_D]') AND type in (N'U'))
    DROP TABLE [dbo].[TransactionDate_D]
GO
CREATE TABLE [dbo].[TransactionDate_D] (
[TransactionDateKey] int  NOT NULL  
, [TransactionDate] date  NOT NULL  
, [TransactionDateDesc] varchar(50)  NOT NULL  
, [TransactionMonth] int  NOT NULL  
, [TransactionMonthDesc] varchar(50)  NOT NULL  
, [TransactionQuarter] varchar(50)  NOT NULL  
, [TransactionQuarterDesc] varchar(50)  NOT NULL  
, [TransactionYear] int  NOT NULL  
, [TransactionDellQuarter] varchar(50)  NOT NULL  
, [TransactionDellQuarterDesc] varchar(50)  NOT NULL  
, [TransactionDellYar] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[TransactionDate_D] ADD CONSTRAINT [TransactionDate_D_PK] PRIMARY KEY CLUSTERED (
[TransactionDateKey]
)
GO
CREATE UNIQUE  INDEX [TransactionDate_UQ] ON [dbo].[TransactionDate_D] (
[TransactionDate]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrder_D]') AND type in (N'U'))
    DROP TABLE [dbo].[WorkOrder_D]
GO
CREATE TABLE [dbo].[WorkOrder_D] (
[WorkOrderKey] int  NOT NULL  
, [WorkOrderNumber] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[WorkOrder_D] ADD CONSTRAINT [WorkOrder_D_PK] PRIMARY KEY CLUSTERED (
[WorkOrderKey]
)
GO
CREATE UNIQUE  INDEX [Workorder_UQ] ON [dbo].[WorkOrder_D] (
[WorkOrderNumber]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SKU_D]') AND type in (N'U'))
    DROP TABLE [dbo].[SKU_D]
GO
CREATE TABLE [dbo].[SKU_D] (
[SKUKey] int  NOT NULL  
, [SKU] char(12)  NOT NULL  
, [SKUDescription] varchar(50)  NULL  
)
GO

ALTER TABLE [dbo].[SKU_D] ADD CONSTRAINT [SKU_D_PK] PRIMARY KEY CLUSTERED (
[SKUKey]
)
GO
CREATE UNIQUE  INDEX [SKU_UQ] ON [dbo].[SKU_D] (
[SKU]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionMinute_D]') AND type in (N'U'))
    DROP TABLE [dbo].[TransactionMinute_D]
GO
CREATE TABLE [dbo].[TransactionMinute_D] (
[TransactionMinuteKey] int  NOT NULL  
, [TransactionMinute] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[TransactionMinute_D] ADD CONSTRAINT [TransactionMinute_D_PK] PRIMARY KEY CLUSTERED (
[TransactionMinuteKey]
)
GO
CREATE UNIQUE  INDEX [TransactionMinute_UQ] ON [dbo].[TransactionMinute_D] (
[TransactionMinute]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MFTGSummary_F]') AND type in (N'U'))
    DROP TABLE [dbo].[MFTGSummary_F]
GO
CREATE TABLE [dbo].[MFTGSummary_F] (
[TransactionHourKey] int  NOT NULL  
, [SerialNumberKey] int  NOT NULL  
, [MFTGSummaryKey] bigint  NOT NULL  
, [MFTGSummaryCount] int  NOT NULL  
, [SafemodeVersionKey] int  NOT NULL  
, [ROMVersionKey] int  NOT NULL  
, [FirmwareVersionKey] int  NOT NULL  
, [RegulatoryModelKey] int  NOT NULL  
, [TransactionDateKey] int  NOT NULL  
, [TransactionMinuteKey] int  NOT NULL  
, [DataSourceKey] int  NOT NULL  
, [SKUKey] int  NOT NULL  
, [StepIndex] int  NOT NULL  
, [ProcessStepData] varchar(max)  NOT NULL  
, [StepResultCodeKey] int  NOT NULL  
, [LocationKey] int  NOT NULL  
, [PartNumberKey] int  NOT NULL  
, [AssemblyKey] int  NOT NULL  
, [WorkOrderKey] int  NOT NULL  
, [IsRMAKey] int  NOT NULL  
, [IRVKey] int  NOT NULL  
, [ProcessDate] datetime  NOT NULL  
, [StationTypeKey] int  NOT NULL  
, [StationKey] int  NOT NULL  
, [DateCodeKey] int  NOT NULL  
, [MIDGroupKey] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[MFTGSummary_F] ADD CONSTRAINT [MFTGSummary_F_PK] PRIMARY KEY CLUSTERED (
[TransactionHourKey]
, [SerialNumberKey]
, [MFTGSummaryKey]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsRMA_D]') AND type in (N'U'))
    DROP TABLE [dbo].[IsRMA_D]
GO
CREATE TABLE [dbo].[IsRMA_D] (
[IsRMAKey] int  NOT NULL  
, [IsRMA] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[IsRMA_D] ADD CONSTRAINT [IsRMA_D_PK] PRIMARY KEY CLUSTERED (
[IsRMAKey]
)
GO
CREATE UNIQUE  INDEX [IsRMA_UQ] ON [dbo].[IsRMA_D] (
[IsRMA]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StationType_D]') AND type in (N'U'))
    DROP TABLE [dbo].[StationType_D]
GO
CREATE TABLE [dbo].[StationType_D] (
[StationTypeKey] int  NOT NULL  
, [StationType] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[StationType_D] ADD CONSTRAINT [StationType_D_PK] PRIMARY KEY CLUSTERED (
[StationTypeKey]
)
GO
CREATE UNIQUE  INDEX [StationType_UQ] ON [dbo].[StationType_D] (
[StationType]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DateCode_D]') AND type in (N'U'))
    DROP TABLE [dbo].[DateCode_D]
GO
CREATE TABLE [dbo].[DateCode_D] (
[DateCodeKey] int  NOT NULL  
, [DateCode] varchar(10)  NOT NULL  
)
GO

ALTER TABLE [dbo].[DateCode_D] ADD CONSTRAINT [DateCode_D_PK] PRIMARY KEY CLUSTERED (
[DateCodeKey]
)
GO
CREATE UNIQUE  INDEX [DateCode_UQ] ON [dbo].[DateCode_D] (
[DateCode]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BridgeMIDGroup]') AND type in (N'U'))
    DROP TABLE [dbo].[BridgeMIDGroup]
GO
CREATE TABLE [dbo].[BridgeMIDGroup] (
[MIDKey] int  NOT NULL  
, [WeightFactor] decimal(3,2)  NOT NULL  
, [SerialNumberKey] bigint  NOT NULL  
, [MIDGroupKey] int  NOT NULL  
)
GO

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IRV_D]') AND type in (N'U'))
    DROP TABLE [dbo].[IRV_D]
GO
CREATE TABLE [dbo].[IRV_D] (
[IRVKey] int  NOT NULL  
, [IRV] varchar(20)  NOT NULL  
)
GO

ALTER TABLE [dbo].[IRV_D] ADD CONSTRAINT [IRV_D_PK] PRIMARY KEY CLUSTERED (
[IRVKey]
)
GO
CREATE UNIQUE  INDEX [IRV_UQ] ON [dbo].[IRV_D] (
[IRV]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RegulatoryModel_D]') AND type in (N'U'))
    DROP TABLE [dbo].[RegulatoryModel_D]
GO
CREATE TABLE [dbo].[RegulatoryModel_D] (
[RegulatoryModelKey] int  NOT NULL  
, [RegulatoryModel] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[RegulatoryModel_D] ADD CONSTRAINT [RegulatoryModel_D_PK] PRIMARY KEY CLUSTERED (
[RegulatoryModelKey]
)
GO
CREATE UNIQUE  INDEX [RegulatoryModel_UQ] ON [dbo].[RegulatoryModel_D] (
[RegulatoryModel]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Station_D]') AND type in (N'U'))
    DROP TABLE [dbo].[Station_D]
GO
CREATE TABLE [dbo].[Station_D] (
[StationKey] int  NOT NULL  
, [Station] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[Station_D] ADD CONSTRAINT [Station_D_PK] PRIMARY KEY CLUSTERED (
[StationKey]
)
GO
CREATE UNIQUE  INDEX [Station_UQ] ON [dbo].[Station_D] (
[Station]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataSource_D]') AND type in (N'U'))
    DROP TABLE [dbo].[DataSource_D]
GO
CREATE TABLE [dbo].[DataSource_D] (
[DataSourceKey] int  NOT NULL  
, [DataSource] varchar(50)  NOT NULL  
, [DataSourceDescription] varchar(50)  NULL  
, [Supplier] varchar(50)  NULL  
)
GO

ALTER TABLE [dbo].[DataSource_D] ADD CONSTRAINT [DataSource_D_PK] PRIMARY KEY CLUSTERED (
[DataSourceKey]
)
GO
CREATE   INDEX [Datasource_UQ] ON [dbo].[DataSource_D] (
[DataSource]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PartNumber_D]') AND type in (N'U'))
    DROP TABLE [dbo].[PartNumber_D]
GO
CREATE TABLE [dbo].[PartNumber_D] (
[PartNumberKey] int  NOT NULL  
, [PartNumberCode] int  NOT NULL  
, [PartNumber] varchar(250)  NULL  
, [Revision] varchar(250)  NULL  
, [Description] varchar(100)  NULL  
)
GO

ALTER TABLE [dbo].[PartNumber_D] ADD CONSTRAINT [PartNumber_D_PK] PRIMARY KEY CLUSTERED (
[PartNumberKey]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location_D]') AND type in (N'U'))
    DROP TABLE [dbo].[Location_D]
GO
CREATE TABLE [dbo].[Location_D] (
[LocationKey] int  NOT NULL  
, [LocationCode] varchar(50)  NOT NULL  
, [Location] varchar(50)  NOT NULL  
, [Country] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[Location_D] ADD CONSTRAINT [Location_D_PK] PRIMARY KEY CLUSTERED (
[LocationKey]
)
GO
CREATE UNIQUE  INDEX [Location_UQ] ON [dbo].[Location_D] (
[Location]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StepResultCode_D]') AND type in (N'U'))
    DROP TABLE [dbo].[StepResultCode_D]
GO
CREATE TABLE [dbo].[StepResultCode_D] (
[StepResultCodeKey] int  NOT NULL  
, [StepResultValue] int  NOT NULL  
, [Description] varchar(50)  NULL  
)
GO

ALTER TABLE [dbo].[StepResultCode_D] ADD CONSTRAINT [StepResultCode_D_PK] PRIMARY KEY CLUSTERED (
[StepResultCodeKey]
)
GO
CREATE UNIQUE  INDEX [StepResultValue_UQ] ON [dbo].[StepResultCode_D] (
[StepResultValue]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FirmwareVersion_D]') AND type in (N'U'))
    DROP TABLE [dbo].[FirmwareVersion_D]
GO
CREATE TABLE [dbo].[FirmwareVersion_D] (
[FirmwareVersionKey] int  NOT NULL  
, [FirmwareVersion] varchar(250)  NOT NULL  
)
GO

ALTER TABLE [dbo].[FirmwareVersion_D] ADD CONSTRAINT [FirmwareVersion_D_PK] PRIMARY KEY CLUSTERED (
[FirmwareVersionKey]
)
GO
CREATE UNIQUE  INDEX [FirmwareVersion_UQ] ON [dbo].[FirmwareVersion_D] (
[FirmwareVersion]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ROMVersion_D]') AND type in (N'U'))
    DROP TABLE [dbo].[ROMVersion_D]
GO
CREATE TABLE [dbo].[ROMVersion_D] (
[ROMVersionKey] int  NOT NULL  
, [ROMVersion] varchar(250)  NOT NULL  
)
GO

ALTER TABLE [dbo].[ROMVersion_D] ADD CONSTRAINT [ROMVersion_D_PK] PRIMARY KEY CLUSTERED (
[ROMVersionKey]
)
GO
CREATE UNIQUE  INDEX [ROMVersion_UQ] ON [dbo].[ROMVersion_D] (
[ROMVersion]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SafemodeVersion_D]') AND type in (N'U'))
    DROP TABLE [dbo].[SafemodeVersion_D]
GO
CREATE TABLE [dbo].[SafemodeVersion_D] (
[SafemodeVersionKey] int  NOT NULL  
, [SafemodeVersion] varchar(50)  NOT NULL  
)
GO

ALTER TABLE [dbo].[SafemodeVersion_D] ADD CONSTRAINT [SafemodeVersion_D_PK] PRIMARY KEY CLUSTERED (
[SafemodeVersionKey]
)
GO
CREATE UNIQUE  INDEX [SafemodeVersion_UQ] ON [dbo].[SafemodeVersion_D] (
[SafemodeVersion]
)
GO

GO

GO

GO

ALTER TABLE [dbo].[ErrorLog] WITH CHECK ADD CONSTRAINT [DataSource_D_ErrorLog_FK1] FOREIGN KEY (
[DataSourceKey]
)
REFERENCES [dbo].[DataSource_D] (
[DataSourceKey]
)
ALTER TABLE [dbo].[ErrorLog] WITH CHECK ADD CONSTRAINT [TransactionMinute_D_ErrorLog_FK1] FOREIGN KEY (
[TransactionMinuteKey]
)
REFERENCES [dbo].[TransactionMinute_D] (
[TransactionMinuteKey]
)
ALTER TABLE [dbo].[ErrorLog] WITH CHECK ADD CONSTRAINT [TransactionDate_D_ErrorLog_FK1] FOREIGN KEY (
[TransactionDateKey]
)
REFERENCES [dbo].[TransactionDate_D] (
[TransactionDateKey]
)
ALTER TABLE [dbo].[ErrorLog] WITH CHECK ADD CONSTRAINT [TransactionHour_D_ErrorLog_FK1] FOREIGN KEY (
[TransactionHourKey]
)
REFERENCES [dbo].[TransactionHour_D] (
[TransactionHourKey]
)
GO

GO

GO

GO

GO

GO

ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [SerialNumber_D_MFTGSummary_F_FK1] FOREIGN KEY (
[SerialNumberKey]
)
REFERENCES [dbo].[SerialNumber_D] (
[SerialNumberKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [Assembly_D_MFTGSummary_F_FK1] FOREIGN KEY (
[AssemblyKey]
)
REFERENCES [dbo].[Assembly_D] (
[AssemblyKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [TransactionDate_D_MFTGSummary_F_FK1] FOREIGN KEY (
[TransactionDateKey]
)
REFERENCES [dbo].[TransactionDate_D] (
[TransactionDateKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [TransactionHour_D_MFTGSummary_F_FK1] FOREIGN KEY (
[TransactionHourKey]
)
REFERENCES [dbo].[TransactionHour_D] (
[TransactionHourKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [WorkOrder_D_MFTGSummary_F_FK1] FOREIGN KEY (
[WorkOrderKey]
)
REFERENCES [dbo].[WorkOrder_D] (
[WorkOrderKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [TransactionMinute_D_MFTGSummary_F_FK1] FOREIGN KEY (
[TransactionMinuteKey]
)
REFERENCES [dbo].[TransactionMinute_D] (
[TransactionMinuteKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [StepResultCode_D_MFTGSummary_F_FK1] FOREIGN KEY (
[StepResultCodeKey]
)
REFERENCES [dbo].[StepResultCode_D] (
[StepResultCodeKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [PartNumber_D_MFTGSummary_F_FK1] FOREIGN KEY (
[PartNumberKey]
)
REFERENCES [dbo].[PartNumber_D] (
[PartNumberKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [Location_D_MFTGSummary_F_FK1] FOREIGN KEY (
[LocationKey]
)
REFERENCES [dbo].[Location_D] (
[LocationKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [DataSource_D_MFTGSummary_F_FK1] FOREIGN KEY (
[DataSourceKey]
)
REFERENCES [dbo].[DataSource_D] (
[DataSourceKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [SKU_D_MFTGSummary_F_FK1] FOREIGN KEY (
[SKUKey]
)
REFERENCES [dbo].[SKU_D] (
[SKUKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [StationType_D_MFTGSummary_F_FK1] FOREIGN KEY (
[StationTypeKey]
)
REFERENCES [dbo].[StationType_D] (
[StationTypeKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [DateCode_D_MFTGSummary_F_FK1] FOREIGN KEY (
[DateCodeKey]
)
REFERENCES [dbo].[DateCode_D] (
[DateCodeKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [RegulatoryModel_D_MFTGSummary_F_FK1] FOREIGN KEY (
[RegulatoryModelKey]
)
REFERENCES [dbo].[RegulatoryModel_D] (
[RegulatoryModelKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [IRV_D_MFTGSummary_F_FK1] FOREIGN KEY (
[IRVKey]
)
REFERENCES [dbo].[IRV_D] (
[IRVKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [IsRMA_D_MFTGSummary_F_FK1] FOREIGN KEY (
[IsRMAKey]
)
REFERENCES [dbo].[IsRMA_D] (
[IsRMAKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [ROMVersion_D_MFTGSummary_F_FK1] FOREIGN KEY (
[ROMVersionKey]
)
REFERENCES [dbo].[ROMVersion_D] (
[ROMVersionKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [FirmwareVersion_D_MFTGSummary_F_FK1] FOREIGN KEY (
[FirmwareVersionKey]
)
REFERENCES [dbo].[FirmwareVersion_D] (
[FirmwareVersionKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [Station_D_MFTGSummary_F_FK1] FOREIGN KEY (
[StationKey]
)
REFERENCES [dbo].[Station_D] (
[StationKey]
)
ALTER TABLE [dbo].[MFTGSummary_F] WITH CHECK ADD CONSTRAINT [SafemodeVersion_D_MFTGSummary_F_FK1] FOREIGN KEY (
[SafemodeVersionKey]
)
REFERENCES [dbo].[SafemodeVersion_D] (
[SafemodeVersionKey]
)
GO

GO

GO

GO

GO

GO

GO

GO

GO

GO

GO

GO

