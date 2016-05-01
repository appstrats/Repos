if not exists(select * from [dbo].Account where Account_key = -1)
INSERT into [dbo].Account (Account_key, ACCOUNTID, ACCOUNT) values (-1, 'Unknown','Unknown');
go
if not exists(select * from [dbo].[Address] where ADDRESS_Key = -1)
INSERT INTO [dbo].[Address] ([ADDRESS_Key] ,[Addr1] ,[Addr2]) VALUES (-1, 'Unknown','Unknown')
GO
if not exists(select * from [dbo].[Dim_Date] where [Date_Key] = -1)
INSERT INTO [dbo].[Dim_Date] ([Date_Key]) VALUES (-1)
GO
if not exists(select * from [dbo].[Fiscal_Year] where [Fiscal_Year_Key] = -1)
INSERT INTO [dbo].[Fiscal_Year] ([Fiscal_Year_Key] ,[Fiscal_Year])  VALUES (-1, 'Unknown')
GO
if not exists(select * from [dbo].[Funding] where [Funding_Key] = -1)
INSERT INTO [dbo].[Funding] ([Funding_Key] ,[Funding]) VALUES (-1 ,'Unknown')
GO
if not exists(select * from [dbo].[Location] where [Location_key] = -1)
INSERT INTO [dbo].[Location] ([Location_key],[Postcode], [City],[State],[Country]) VALUES (-1, 'Unknown','Unknown','Unknown','Unknown')
GO
if not exists(select * from [dbo].[MDR_File_Type] where [MDR_File_Type_Key] = -1)
INSERT INTO [dbo].[MDR_File_Type] ([MDR_File_Type_Key],[MDR_File_Type]) VALUES (-1,'Unknown')
GO
if not exists(select * from [dbo].[Order_Method] where [Order_Method_Key] = -1)
INSERT INTO [dbo].[Order_Method] ([Order_Method_Key],[Order_Method]) VALUES (-1, 'Unknown')
GO
if not exists(select * from [dbo].[Order_Type] where [Order_Type_Key] = -1)
INSERT INTO [dbo].[Order_Type] ([Order_Type_Key],[Order_Type]) VALUES (-1, 'Unknown')
GO
if not exists(select * from [dbo].[Product] where [Product_Number_Key] = -1)
INSERT INTO [dbo].[Product] ([Product_Number_Key],[PRODUCT_Family],[PRODUCT_NUMBER],[PRODUCT_NAME])
     VALUES (-1,'Unknown', 'Unknown','Unknown')
GO
if not exists(select * from [dbo].[Region] where [Region_Key] = -1)
INSERT INTO [dbo].[Region] ([Region_Key],[Region]) VALUES (-1 , 'Unknown')
GO
if not exists(select * from [dbo].[Shipper] where [SHIPPER_Key] = -1)
INSERT INTO [dbo].[Shipper] ([SHIPPER_Key] ,[ShipName],[SHIPPERID]) VALUES (-1,'Unknown','Unknown')
GO
if not exists(select * from [dbo].[User] where [User_Key] = -1)
INSERT INTO [dbo].[User] ([User_Key],[Name],[User2]) VALUES (-1,'Unknown','Unknown')
GO












