/****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*) Count_AssemblyKey_1  FROM [MFTG_DW].[dbo].[Assembly_D]
  where AssemblyKey=-1
SELECT count(*) Count_DateCodeKey_1  FROM [MFTG_DW].[dbo].DateCode_D
  where DateCodeKey=-1
SELECT count(*) Count_FirmwareVersionKey_1  FROM [MFTG_DW].[dbo].FirmwareVersion_D
  where FirmwareVersionKey=-1
SELECT count(*) Count_IRVKey_1  FROM [MFTG_DW].[dbo].IRV_D
  where IRVKey=-1
 SELECT count(*) Count_IsRMAKey_1  FROM [MFTG_DW].[dbo].IsRMA_D
  where IsRMAKey=-1
SELECT count(*) Count_LocationKey_1  FROM [MFTG_DW].[dbo].Location_D
  where LocationKey=-1
SELECT count(*) Count_MIDKey_1  FROM [MFTG_DW].[dbo].ManufacturingID_D
  where MIDKey=-1
SELECT count(*) Count_PartNumberKey_1  FROM [MFTG_DW].[dbo].PartNumber_D
  where PartNumberKey=-1
  SELECT count(*) Count_RegulatoryModelKey_1  FROM [MFTG_DW].[dbo].RegulatoryModel_D
  where RegulatoryModelKey=-1
 SELECT count(*) Count_ROMVersionKey_1  FROM [MFTG_DW].[dbo].ROMVersion_D
  where ROMVersionKey=-1
SELECT count(*) Count_SafemodeVersionKey_1  FROM [MFTG_DW].[dbo].SafemodeVersion_D
  where SafemodeVersionKey=-1
SELECT count(*) Count_SerialNumberKey_1  FROM [MFTG_DW].[dbo].SerialNumber_D
  where SerialNumberKey=-1
SELECT count(*) Count_SKUKey_1  FROM [MFTG_DW].[dbo].SKU_D
  where SKUKey=-1
  
  SELECT count(*) Count_StationKey_1  FROM [MFTG_DW].[dbo].Station_D
  where StationKey=-1
SELECT count(*) Count_StationTypeKey_1  FROM [MFTG_DW].[dbo].StationType_D
  where StationTypeKey=-1
  SELECT count(*) Count_StepResultCodeKey_1  FROM [MFTG_DW].[dbo].StepResultCode_D
  where StepResultCodeKey=-1
 SELECT count(*) Count_WorkOrderKey_1  FROM [MFTG_DW].[dbo].WorkOrder_D
  where WorkOrderKey=-1