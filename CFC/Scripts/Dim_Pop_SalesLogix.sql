use [CFC_DW]
GO
--Account
-- exec sp_pop_account_SalesLogix 
Create PROC sp_pop_account_SalesLogix  as
begin
set nocount on

insert into [CFC_DW].sysdba.Account(ACCOUNTID_key,ACCOUNTID,ACCOUNT)
select distinct isnull((select max(ACCOUNTID_key) from [CFC_DW].sysdba.ACCOUNT where ACCOUNTID_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.ACCOUNTID ), s.ACCOUNTID, s.ACCOUNT 
from SalesLogix.sysdba.ACCOUNT s
left outer join [CFC_DW].sysdba.Account d on s.ACCOUNTID  = d.ACCOUNTID
where d.ACCOUNTID is null
end;

--Region
-- exec sp_pop_region_SalesLogix 
Create PROC sp_pop_region_SalesLogix as
begin
set nocount on

with T_Label_region as
(select distinct(REGION) rg  from SalesLogix.sysdba.ACCOUNT )

insert into [CFC_DW].sysdba.Region(Region_key,Region)
select distinct isnull((select max(Region_key) from [CFC_DW].sysdba.Ship_Region where Region_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.rg ), s.rg 
from T_Label_region s
left outer join [CFC_DW].sysdba.Ship_Region d on s.rg  = d.Region
where d.Region is null

end;

go

use [CFC_DW]
GO
--Product
-- exec sp_pop_procuct_SalesLogix 
Create PROC sp_pop_procuct_SalesLogix as
begin
set nocount on

insert into [CFC_DW].sysdba.Product(PRODUCT_NUMBER_key,PRODUCT_Family,PRODUCT_NUMBER,PRODUCT_NAME)
select distinct isnull((select max(PRODUCT_NUMBER_key) from [CFC_DW].sysdba.Product where PRODUCT_NUMBER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.PRODUCTID ),s.FAMILY, s.PRODUCTID ,s.NAME
from SalesLogix.sysdba.PRODUCT s
left outer join [CFC_DW].sysdba.PRODUCT d on s.PRODUCTID  = d.PRODUCT_NUMBER
where d.PRODUCT_NUMBER is null

end;

GO
--Order type
-- exec sp_pop_ordertype_SalesLogix 
Create PROC sp_pop_ordertype_SalesLogix  as
begin
set nocount on

with T_Label_Order_Type as
(select distinct(ORDERTYPE) ot from SalesLogix.sysdba.SALESORDER  ) 

insert into [CFC_DW].[sysdba].[Order_Type]([Order_Type_Key],[Order_Type])
select distinct isnull((select max([Order_Type_Key]) from [CFC_DW].[sysdba].[Order_Type] where [Order_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ot ), s.ot
from T_Label_Order_Type s
left outer join [CFC_DW].sysdba.[Order_Type] d on s.ot  = d.[Order_Type]
where d.[Order_Type] is null
end;



GO
--Order_Method
-- exec sp_pop_Order_Method_SalesLogix 
Create PROC sp_pop_Order_Method_SalesLogix  as
begin
set nocount on

with T_Label_Order_Method as
(select distinct(ORDER_METHOD) om from SalesLogix.sysdba.salesorder_ext  ) 

insert into [CFC_DW].[sysdba].[Order_Method]([Order_Method_Key],[Order_Method])
select distinct isnull((select max([Order_Method_Key]) from [CFC_DW].[sysdba].[Order_Method] where [Order_Method_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.om ), s.om
from T_Label_Order_Method s
left outer join [CFC_DW].sysdba.[Order_Method] d on s.om  = d.[Order_Method]
where d.[Order_Method] is null
end;

go

--MDR_file_Type
-- exec sp_pop_MDR_file_Type_SalesLogix 
Create PROC sp_pop_MDR_file_Type_SalesLogix  as
begin
set nocount on

with T_Label_MDR_file_Type as
(select distinct(MDR_FILETYPE) mf from SalesLogix.sysdba.ACCOUNTFFEXT ) 

insert into [CFC_DW].[sysdba].[MDR_file_Type]([MDR_file_Type_Key],[MDR_file_Type])
select distinct isnull((select max([MDR_file_Type_Key]) from [CFC_DW].[sysdba].[MDR_file_Type] where [MDR_file_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.mf ), s.mf
from T_Label_MDR_file_Type s
left outer join [CFC_DW].sysdba.[MDR_file_Type] d on s.mf  = d.[MDR_file_Type]
where d.[MDR_file_Type] is null
end;


GO
--User
-- exec sp_pop_User_SalesLogix 
Create PROC sp_pop_User_SalesLogix as
begin
set nocount on

insert into [CFC_DW].sysdba.User(Name_key,Name,User2)
select distinct isnull((select max(Name_key) from [CFC_DW].sysdba.User where Name_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.USERFIELD1 ),s.USERFIELD1, s.USERFIELD2
from SalesLogix.sysdba.PRODUCT s
left outer join [CFC_DW].sysdba.User d on s.USERFIELD1  = d.Name
where d.Name is null

end;

GO
--Funding
-- exec sp_pop_Funding_SalesLogix 
Create PROC sp_pop_Funding_SalesLogix  as
begin
set nocount on

with T_Label_Funding as
(select distinct(FUNDING) fd from SalesLogix.sysdba.salesorder_ext ) 

insert into [CFC_DW].[sysdba].[Funding]([Funding_Key],[Funding])
select distinct isnull((select max([Funding_Key]) from [CFC_DW].[sysdba].[Funding] where [Funding_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.fd ), s.fd
from T_Label_Funding s
left outer join [CFC_DW].sysdba.[Funding] d on s.fd  = d.[Funding]
where d.[Funding] is null
end;


GO
--address
-- exec sp_pop_address_SalesLogix 
Create PROC sp_pop_address_SalesLogix  as
begin
set nocount on

with T_Label_address as
(select distinct(ADDRESS1) ad from SalesLogix.sysdba.ADDRESS ) 

insert into [CFC_DW].[sysdba].[Address]([Addr1_Key],[Addr1],[Addr2])
select distinct isnull((select max([Addr1_Key]) from [CFC_DW].[sysdba].Address where [Addr1_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ad ), s.ad, s.ADDRESS2
from T_Label_Funding s
left outer join [CFC_DW].sysdba.[Address] d on s.Ad  = d.[Addr1]
where d.[Addr1] is null
end;

GO
--location
-- exec sp_pop_location_SalesLogix 
Create PROC sp_pop_location_SalesLogix  as
begin
set nocount on

with T_Label_Location as
(select distinct(POSTALCODE) pc from SalesLogix.sysdba.ADDRESS ) 

insert into [CFC_DW].[sysdba].[Location]([Location_Key],[POSTALCODE],[CITY],[STATE],[COUNTRY])
select distinct isnull((select max([Location_Key]) from [CFC_DW].[sysdba].[Location] where [Location_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.pc ), s.POSTALCODE, s.CITY, s.STATE, s.COUNTRY
from T_Label_Funding s
left outer join [CFC_DW].sysdba.[Location] d on s.pc  = d.[POSTALCODE]
where d.[POSTALCODE] is null
end;


GO
--Shipper
-- exec sp_pop_Shipper_SalesLogix 
Create PROC sp_pop_Shipper_SalesLogix as
begin
set nocount on

insert into [CFC_DW].sysdba.Shipper(SHIPPERID_key,ShipName,SHIPPERID)
select distinct isnull((select max(SHIPPERID_key) from [CFC_DW].sysdba.Shipper where SHIPPERID_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.SHIPPERID ),'unknown', s.SHIPPERID
from SalesLogix.sysdba.salesorder_ext s
left outer join [CFC_DW].sysdba.Shipper d on s.SHIPPERID  = d.SHIPPERID
where d.SHIPPERID is null

end;
