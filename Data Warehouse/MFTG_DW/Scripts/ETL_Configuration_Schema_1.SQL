EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ETL_Configuration'
GO
USE [master]
GO
ALTER DATABASE [ETL_Configuration] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
DROP DATABASE [ETL_Configuration]
GO

USE Master
GO
CREATE DATABASE [ETL_Configuration]
GO
USE [ETL_Configuration]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataLoad_Log]') AND type in (N'U'))
    DROP TABLE [dbo].[DataLoad_Log]
GO
CREATE TABLE [dbo].[DataLoad_Log] (
[LoadDescription] varchar(50)  NULL  
, [DataSource] varchar(50)  NULL  
, [LoadID] int  NOT NULL  
, [StartDate] datetime  NULL  
, [EndDate] datetime  NULL  
, [Status] bit  NULL  
, [LoadStart] datetime  NULL  
, [LoadEnd] datetime  NULL  
)
GO

ALTER TABLE [dbo].[DataLoad_Log] ADD CONSTRAINT [DataLoad_Log_PK] PRIMARY KEY CLUSTERED (
[LoadID]
)
GO
GO

GO

