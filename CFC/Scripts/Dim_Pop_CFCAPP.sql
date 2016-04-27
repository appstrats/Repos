use [CFC_DW]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_account_CFCAPP]'))
DROP PROC [dbo].sp_pop_account_CFCAPP
go
--Account
-- exec sp_pop_account_CFCAPP 
Create PROC sp_pop_account_CFCAPP  as
begin
set nocount on;

insert into Account(ACCOUNTID_key,ACCOUNTID,ACCOUNT)
select distinct isnull((select max(ACCOUNTID_key) from ACCOUNT where ACCOUNTID_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.CustID ), s.CustID, s.Name 
from CFCAPP.sysdba.[Customer] s
left outer join Account d on s.CustID  = d.ACCOUNTID
where d.ACCOUNTID is null
end;

go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_region_CFCAPP]'))
DROP PROC [dbo].sp_pop_region_CFCAPP
go
--Region
-- exec sp_pop_region_CFCAPP 
Create PROC sp_pop_region_CFCAPP as
begin
set nocount on;

with T_Label_region as
(select distinct(CustID) CID  from CFCAPP.sysdba.SOShipHeader )

insert into Region(Region_key,Region)
select distinct isnull((select max(Region_key) from Ship_Region where Region_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.CID ), s.CID 
from T_Label_region s
left outer join Ship_Region d on s.CID  = d.Region
where d.Region is null

end;

go

use [CFC_DW]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_procuct_CFCAPP]'))
DROP PROC [dbo].sp_pop_procuct_CFCAPP
go
--Product
-- exec sp_pop_procuct_CFCAPP 
Create PROC sp_pop_procuct_CFCAPP as
begin
set nocount on;

with T_Label_Product as
(select distinct(InvtID) ivt from CFCAPP.sysdba.SOShipLine  ) 


insert into Product(PRODUCT_NUMBER_key,PRODUCT_Family,PRODUCT_NUMBER,PRODUCT_NAME)
select distinct isnull((select max(PRODUCT_NUMBER_key) from Product where PRODUCT_NUMBER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.ivt ),s.ItemGLClassID, s.ivt ,s.Descr
from T_Label_Product s
left outer join PRODUCT d on s.ivt  = d.PRODUCT_NUMBER
where d.PRODUCT_NUMBER is null

end;

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_ordertype_CFCAPP]'))
DROP PROC [dbo].sp_pop_ordertype_CFCAPP
go
--Order type
-- exec sp_pop_ordertype_CFCAPP 
Create PROC sp_pop_ordertype_CFCAPP  as
begin
set nocount on;

with T_Label_Order_Type as
(select distinct(SOTYPEID) ot from CFCAPP.sysdba.SOShipHeader) 

insert into [CFC_DW].[sysdba].[Order_Type]([Order_Type_Key],[Order_Type])
select distinct isnull((select max([Order_Type_Key]) from [CFC_DW].[sysdba].[Order_Type] where [Order_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ot ), s.ot
from T_Label_Order_Type s
left outer join [Order_Type] d on s.ot  = d.[Order_Type]
where d.[Order_Type] is null
end;



GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_Order_Method_CFCAPP]'))
DROP PROC [dbo].sp_pop_Order_Method_CFCAPP
go
--Order_Method
-- exec sp_pop_Order_Method_CFCAPP 
Create PROC sp_pop_Order_Method_CFCAPP  as
begin
set nocount on;

with T_Label_Order_Method as
(select distinct(User3) om from CFCAPP.sysdba.SOShipHeader ) 

insert into [CFC_DW].[sysdba].[Order_Method]([Order_Method_Key],[Order_Method])
select distinct isnull((select max([Order_Method_Key]) from [CFC_DW].[sysdba].[Order_Method] where [Order_Method_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.om ), s.om
from T_Label_Order_Method s
left outer join [Order_Method] d on s.om  = d.[Order_Method]
where d.[Order_Method] is null
end;

go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_User_CFCAPP]'))
DROP PROC [dbo].sp_pop_User_CFCAPP
go
--User
-- exec sp_pop_User_CFCAPP 
Create PROC sp_pop_User_CFCAPP as
begin
set nocount on;

insert into [User](User_key,Name,User2)
select distinct isnull((select max(User_key) from [User] where User_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.User1 ),s.User1, s.User2
from CFCAPP.dbo.BCUsers s
left outer join [User] d on s.User1  = d.Name
where d.Name is null
end

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_Funding_CFCAPP]'))
DROP PROC [dbo].sp_pop_Funding_CFCAPP
go
--Funding
-- exec sp_pop_Funding_CFCAPP 
Create PROC sp_pop_Funding_CFCAPP  as
begin
set nocount on;

with T_Label_Funding1 as
(select distinct(user4) fd from CFCAPP.sysdba.SOShipHeader ) 

insert into [CFC_DW].[sysdba].[Funding]([Funding_Key],[Funding])
select distinct isnull((select max([Funding_Key]) from [CFC_DW].[sysdba].[Funding] where [Funding_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.fd ), s.fd
from T_Label_Funding1 s
left outer join [Funding] d on s.fd  = d.[Funding]
where d.[Funding] is null
end;


GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_address_CFCAPP]'))
DROP PROC [dbo].sp_pop_address_CFCAPP
go
--address
-- exec sp_pop_address_CFCAPP 
Create PROC sp_pop_address_CFCAPP  as
begin
set nocount on;

with T_Label_address1 as
(select distinct(BillAddr1) ad from CFCAPP.sysdba.SOShipHeader ) 

insert into [CFC_DW].[sysdba].[Address]([Addr1_Key],[Addr1],[Addr2])
select distinct isnull((select max([Addr1_Key]) from [CFC_DW].[sysdba].Address where [Addr1_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ad ), s.ad, s.BillAddr2
from T_Label_address1 s
left outer join [Address] d on s.ad  = d.[Addr1]
where d.[Addr1] is null
end;

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_location_CFCAPP]'))
DROP PROC [dbo].sp_pop_location_CFCAPP
go
--location
-- exec sp_pop_location_CFCAPP 
Create PROC sp_pop_location_CFCAPP  as
begin
set nocount on;

with T_Label_Location1 as
(select distinct(ShipZip) pc from CFCAPP.sysdba.SOShipHeader) 

insert into [CFC_DW].[sysdba].[Location]([Location_Key],[POSTALCODE],[CITY],[STATE],[COUNTRY])
select distinct isnull((select max([Location_Key]) from [CFC_DW].[sysdba].[Location] where [Location_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.pc ), s.pc, s.ShipCity, s.ShipState, s.ShipCountry
from T_Label_Location1 s
left outer join [Location] d on s.pc  = d.[POSTALCODE]
where d.[POSTALCODE] is null
end;

go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_pop_Shipper_CFCAPP]'))
DROP PROC [dbo].sp_pop_Shipper_CFCAPP
go
--Shipper
-- exec sp_pop_Shipper_CFCAPP 
Create PROC sp_pop_Shipper_CFCAPP as
begin
set nocount on

insert into Shipper(SHIPPERID_key,ShipName,SHIPPERID)
select distinct isnull((select max(SHIPPERID_key) from Shipper where SHIPPERID_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.SHIPPERID ),s.SHIPPERID, s.ShipName
from T_Label_Shipper1 s
left outer join Shipper d on s.SHIPPERID  = d.SHIPPERID
where d.SHIPPERID is null
end;