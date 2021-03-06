USE [master]
GO
/****** Object:  Database [CFC_DW]    Script Date: 5/3/2016 12:46:41 AM ******/
CREATE DATABASE [CFC_DW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CFC_DW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\CFC_DW.mdf' , SIZE = 108544KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CFC_DW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\CFC_DW_log.ldf' , SIZE = 164672KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CFC_DW] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CFC_DW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CFC_DW] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CFC_DW] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CFC_DW] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CFC_DW] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CFC_DW] SET ARITHABORT OFF 
GO
ALTER DATABASE [CFC_DW] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CFC_DW] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CFC_DW] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CFC_DW] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CFC_DW] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CFC_DW] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CFC_DW] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CFC_DW] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CFC_DW] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CFC_DW] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CFC_DW] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CFC_DW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CFC_DW] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CFC_DW] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CFC_DW] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CFC_DW] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CFC_DW] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CFC_DW] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CFC_DW] SET RECOVERY FULL 
GO
ALTER DATABASE [CFC_DW] SET  MULTI_USER 
GO
ALTER DATABASE [CFC_DW] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CFC_DW] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CFC_DW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CFC_DW] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [CFC_DW]
GO
/****** Object:  StoredProcedure [dbo].[sp_pop_account_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Account
-- exec sp_pop_account_CFCAPP 
Create PROC [dbo].[sp_pop_account_CFCAPP]  as
begin
set nocount on;

insert into Account(Account_key,ACCOUNTID,ACCOUNT)
select distinct isnull((select max(Account_key) from ACCOUNT where Account_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.CustID ), s.CustID, s.Name 
from CFCAPP.dbo.[Customer] s
left outer join Account d on s.CustID  = d.ACCOUNTID
where d.ACCOUNTID is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_account_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_account_SalesLogix]  as
begin
set nocount on

insert into Account(Account_key,ACCOUNTID,ACCOUNT)
select distinct isnull((select max(Account_key) from ACCOUNT where Account_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.ACCOUNTID ), s.ACCOUNTID, s.ACCOUNT 
from SalesLogix.sysdba.ACCOUNT s
left outer join Account d on s.ACCOUNTID  = d.ACCOUNTID
where d.ACCOUNTID is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_address_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--address
-- exec sp_pop_address_CFCAPP 
create PROC [dbo].[sp_pop_address_CFCAPP]  as
begin
set nocount on;

with T_Label_address1 as
(select distinct(BillAddr1),BillAddr2  from CFCAPP.dbo.SOShipHeader ) 

insert into [CFC_DW].dbo.[Address](ADDRESS_Key,[Addr1],[Addr2])
select distinct isnull((select max(ADDRESS_Key) from [CFC_DW].dbo.Address where ADDRESS_Key>-1),0) +
ROW_NUMBER() over (ORDER BY s.BillAddr1 ), s.BillAddr1, s.BillAddr2
from T_Label_address1 s
left outer join [Address] d on s.BillAddr1  = d.[Addr1]
where d.[Addr1] is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_address_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_address_SalesLogix]  as
begin
set nocount on;

with T_Label_address as
(select distinct(ADDRESS1),ADDRESS2  from SalesLogix.sysdba.ADDRESS ) 

insert into [CFC_DW].dbo.[Address](ADDRESS_Key,[Addr1],[Addr2])
select distinct isnull((select max(ADDRESS_Key) from [CFC_DW].dbo.Address where ADDRESS_Key>-1),0) +
ROW_NUMBER() over (ORDER BY s.ADDRESS1 ), s.ADDRESS1, s.ADDRESS2
from T_Label_address s
left outer join [Address] d on s.ADDRESS1  = d.[Addr1]
where d.[Addr1] is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Funding_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Funding
-- exec sp_pop_Funding_CFCAPP 
create PROC [dbo].[sp_pop_Funding_CFCAPP]  as
begin
set nocount on;

with T_Label_Funding1 as
(select distinct(user4) fd from CFCAPP.dbo.SOShipHeader ) 

insert into [CFC_DW].dbo.[Funding]([Funding_Key],[Funding])
select distinct isnull((select max([Funding_Key]) from [CFC_DW].dbo.[Funding] where [Funding_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.fd ), s.fd
from T_Label_Funding1 s
left outer join [Funding] d on s.fd  = d.[Funding]
where d.[Funding] is null
end;



GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Funding_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create  PROC [dbo].[sp_pop_Funding_SalesLogix]  as
begin
set nocount on;

with T_Label_Funding as
(select distinct(FUNDING) fd from SalesLogix.sysdba.salesorder_ext ) 

insert into [CFC_DW].dbo.[Funding]([Funding_Key],[Funding])
select distinct isnull((select max([Funding_Key]) from [CFC_DW].dbo.[Funding] where [Funding_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.fd ), s.fd
from T_Label_Funding s
left outer join [Funding] d on s.fd  = d.[Funding]
where d.[Funding] is null
end;



GO
/****** Object:  StoredProcedure [dbo].[sp_pop_location_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--location
-- exec sp_pop_location_CFCAPP 
create PROC [dbo].[sp_pop_location_CFCAPP]  as
begin
set nocount on;

with T_Label_Location1 as
(select distinct ShipZip,ShipCity,ShipState,ShipCountry from CFCAPP.dbo.SOShipHeader where shipzip is not null) 

insert into [CFC_DW].dbo.[Location](Location_key,Postcode,City,State,Country)
select distinct isnull((select max([Location_Key]) from [CFC_DW].dbo.[Location] where [Location_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ShipZip ), s.ShipZip, s.ShipCity, s.ShipState, s.ShipCountry
from T_Label_Location1 s
left outer join [Location] d on s.ShipZip  = d.Postcode
where d.Postcode is null
end;

GO
/****** Object:  StoredProcedure [dbo].[sp_pop_location_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_location_SalesLogix]  as
begin
set nocount on;

with T_Label_Location as
(select distinct POSTALCODE,CITY,STATE,COUNTRY from SalesLogix.sysdba.ADDRESS where postalcode is not null ) 

insert into [CFC_DW].dbo.[Location](Location_key,Postcode,City,State,Country)
select distinct isnull((select max([Location_Key]) from [CFC_DW].dbo.[Location] where [Location_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.POSTALCODE ), s.POSTALCODE, s.CITY, s.STATE, s.COUNTRY
from T_Label_Location s
left outer join [Location] d on s.POSTALCODE  = d.Postcode
where d.Postcode is null
end;

GO
/****** Object:  StoredProcedure [dbo].[sp_pop_MDR_file_Type_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create  PROC [dbo].[sp_pop_MDR_file_Type_SalesLogix]  as
begin
set nocount on;

with T_Label_MDR_file_Type as
(select distinct(MDR_FILETYPE) mf from SalesLogix.sysdba.ACCOUNTFFEXT ) 

insert into [CFC_DW].dbo.[MDR_file_Type]([MDR_file_Type_Key],[MDR_file_Type])
select distinct isnull((select max([MDR_file_Type_Key]) from [CFC_DW].dbo.[MDR_file_Type] where [MDR_file_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.mf ), s.mf
from T_Label_MDR_file_Type s
left outer join [MDR_file_Type] d on s.mf  = d.[MDR_file_Type]
where d.[MDR_file_Type] is null
end;



GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Order_Method_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Order_Method
-- exec sp_pop_Order_Method_CFCAPP 
create PROC [dbo].[sp_pop_Order_Method_CFCAPP]  as
begin
set nocount on;

with T_Label_Order_Method as
(select distinct(User3) om from CFCAPP.dbo.SOShipHeader ) 

insert into [CFC_DW].dbo.[Order_Method]([Order_Method_Key],[Order_Method])
select distinct isnull((select max([Order_Method_Key]) from [CFC_DW].dbo.[Order_Method] where [Order_Method_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.om ), s.om
from T_Label_Order_Method s
left outer join [Order_Method] d on s.om  = d.[Order_Method]
where d.[Order_Method] is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Order_Method_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_Order_Method_SalesLogix]  as
begin
set nocount on;

with T_Label_Order_Method as
(select distinct(ORDER_METHOD) om from SalesLogix.sysdba.salesorder_ext  ) 

insert into [CFC_DW].dbo.[Order_Method]([Order_Method_Key],[Order_Method])
select distinct isnull((select max([Order_Method_Key]) from [CFC_DW].dbo.[Order_Method] where [Order_Method_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.om ), s.om
from T_Label_Order_Method s
left outer join [Order_Method] d on s.om  = d.[Order_Method]
where d.[Order_Method] is null
end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_ordertype_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Order type
-- exec sp_pop_ordertype_CFCAPP 
Create PROC [dbo].[sp_pop_ordertype_CFCAPP]  as
begin
set nocount on;

with T_Label_Order_Type as
(select distinct(SOTYPEID) ot from CFCAPP.dbo.SOShipHeader) 

insert into [CFC_DW].dbo.[Order_Type]([Order_Type_Key],[Order_Type])
select distinct isnull((select max([Order_Type_Key]) from [CFC_DW].dbo.[Order_Type] where [Order_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ot ), s.ot
from T_Label_Order_Type s
left outer join [Order_Type] d on s.ot  = d.[Order_Type]
where d.[Order_Type] is null
end;




GO
/****** Object:  StoredProcedure [dbo].[sp_pop_ordertype_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_ordertype_SalesLogix]  as
begin
set nocount on;

with T_Label_Order_Type as
(select distinct(ORDERTYPE) ot from SalesLogix.sysdba.SALESORDER  ) 

insert into [CFC_DW].dbo.[Order_Type]([Order_Type_Key],[Order_Type])
select distinct isnull((select max([Order_Type_Key]) from [CFC_DW].dbo.[Order_Type] where [Order_Type_Key]>-1),0) +
ROW_NUMBER() over (ORDER BY s.ot ), s.ot
from T_Label_Order_Type s
left outer join [Order_Type] d on s.ot  = d.[Order_Type]
where d.[Order_Type] is null
end;




GO
/****** Object:  StoredProcedure [dbo].[sp_pop_procuct_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Product
-- exec sp_pop_procuct_CFCAPP 
Create PROC [dbo].[sp_pop_procuct_CFCAPP] as
begin
set nocount on;

with T_Label_Product as
(select distinct InvtID ivt, ItemGLClassID, Descr from CFCAPP.dbo.SOShipLine  ) 


insert into Product(PRODUCT_NUMBER_key,PRODUCT_Family,PRODUCT_NUMBER,PRODUCT_NAME)
select distinct isnull((select max(PRODUCT_NUMBER_key) from Product where PRODUCT_NUMBER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.ivt ),s.ItemGLClassID, s.ivt ,s.Descr
from T_Label_Product s
left outer join PRODUCT d on s.ivt  = d.PRODUCT_NUMBER
where d.PRODUCT_NUMBER is null

end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_product_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_product_SalesLogix] as
begin
set nocount on

insert into Product(PRODUCT_NUMBER_key,PRODUCT_Family,PRODUCT_NUMBER,PRODUCT_NAME)
select distinct isnull((select max(PRODUCT_NUMBER_key) from Product where PRODUCT_NUMBER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.PRODUCTID ),s.FAMILY, s.PRODUCTID ,s.NAME
from SalesLogix.sysdba.PRODUCT s
left outer join PRODUCT d on s.PRODUCTID  = d.PRODUCT_NUMBER
where d.PRODUCT_NUMBER is null

end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_region_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Region
-- exec sp_pop_region_CFCAPP 
Create PROC [dbo].[sp_pop_region_CFCAPP] as
begin
set nocount on;

with T_Label_region as
(select distinct(CustID) CID  from CFCAPP.dbo.SOShipHeader )

insert into Region(Region_key,Region)
select distinct isnull((select max(Region_key) from Region where Region_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.CID ), s.CID 
from T_Label_region s
left outer join Region d on s.CID  = d.Region
where d.Region is null

end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_region_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_region_SalesLogix] as
begin
set nocount on;

with T_Label_region as
(select distinct(REGION) rg  from SalesLogix.sysdba.ACCOUNT )

insert into Region(Region_key,Region)
select distinct isnull((select max(Region_key) from Region where Region_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.rg ), s.rg 
from T_Label_region s
left outer join Region d on s.rg  = d.Region
where d.Region is null

end;


GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Shipper_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Shipper
-- exec sp_pop_Shipper_CFCAPP 
create PROC [dbo].[sp_pop_Shipper_CFCAPP] as
begin
set nocount on ;
with T_Label_Shipper1 as
(select distinct(SHIPPERID),ShipName from CFCAPP.dbo.SOShipHeader) 

insert into Shipper(SHIPPER_key,SHIPPERID, ShipName)
select distinct isnull((select max(SHIPPER_key) from Shipper where SHIPPER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.SHIPPERID ),s.SHIPPERID, s.ShipName
from T_Label_Shipper1 s
left outer join Shipper d on s.SHIPPERID  = d.SHIPPERID
where d.SHIPPERID is null
end;
GO
/****** Object:  StoredProcedure [dbo].[sp_pop_Shipper_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_Shipper_SalesLogix] as
begin
set nocount on;

insert into Shipper(SHIPPER_key,ShipName,SHIPPERID)
select distinct isnull((select max(SHIPPER_key) from Shipper where SHIPPER_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.SHIPPERID ),'unknown', s.SHIPPERID
from SalesLogix.sysdba.salesorder_ext s
left outer join Shipper d on s.SHIPPERID  = d.SHIPPERID
where d.SHIPPERID is null

end;

GO
/****** Object:  StoredProcedure [dbo].[sp_pop_User_CFCAPP]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--User
-- exec sp_pop_User_CFCAPP 
Create PROC [dbo].[sp_pop_User_CFCAPP] as
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
/****** Object:  StoredProcedure [dbo].[sp_pop_User_SalesLogix]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_pop_User_SalesLogix] as
begin
set nocount on

insert into [User](User_key,Name,User2)
select distinct isnull((select max(User_key) from [User] where User_key>-1),0) +
ROW_NUMBER() over (ORDER BY s.USERNAME ),s.USERNAME, s.USERID
from SalesLogix.sysdba.USERINFO s
left outer join [User] d on s.USERNAME  = d.Name
where d.Name is null

end;


GO
/****** Object:  StoredProcedure [dbo].[sp_populate_date_dim]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_populate_date_dim] (@pyear char(4)) as
begin
set nocount on
declare @yyyy  char(4)
declare @dtcur	date
declare @datedetail table ([DateKey] [int] NOT NULL,
	[DateVal] [date] NULL,
	[DateDesc] [varchar](50) NULL,
	[CalenderMonth] [int] NULL,
	[CalenderMonthDesc] [varchar](50) NULL,
	[CalenderQuarter] [varchar](50) NULL,
	[CalenderQuarterDesc] [varchar](50) NULL,
    [CalenderYear] [int]  null);
	 
if not exists(select * from [dbo].[Dim_Date] where [CalenderYear]= @pyear)
begin

set @dtcur=@pyear+'0101'

while (datepart(year, @dtcur)=@pyear)
begin
insert into @datedetail (
[DateKey], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear])
select 
format(@dtcur,'yyyyMMdd'),
@dtcur,
format(@dtcur,'MMM dd, yyyy'),
DATEPART(MM,@dtcur),
Datename(MM,@dtcur),
case when DATEPART(MM,@dtcur) between 1 and 3 then 1
when DATEPART(MM,@dtcur) between 4 and 6 then 2 
when DATEPART(MM,@dtcur) between 7 and 9 then 3 else 4 end ,
case when DATEPART(MM,@dtcur) between 1 and 3 then 'Q1'
when DATEPART(MM,@dtcur) between 4 and 6 then 'Q2' 
when DATEPART(MM,@dtcur) between 7 and 9 then 'Q3' else 'Q4' end,
DATEPART(YEAR,@dtcur) ;

set @dtcur = DATEADD(D,1, @dtcur)
end

insert into [dbo].[Dim_Date] ([Date_Key], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear]
	 )
select [DateKey], 
[DateVal], 
[DateDesc], 
[CalenderMonth], 
[CalenderMonthDesc],
[CalenderQuarter],
[CalenderQuarterDesc],
[CalenderYear]
	
	 from @datedetail
end
set nocount off
end
GO
/****** Object:  StoredProcedure [dbo].[sp_populate_fact]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_populate_fact]  as
begin
set nocount on

-- SalesLogx Data
SELECT       
CAST(CASE WHEN month(Salesorder.shippeddate) IN (1, 2, 3) THEN year(Salesorder.shippeddate) - 1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
+ '-' +
CAST(CASE WHEN month(Salesorder.shippeddate) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(Salesorder.shippeddate) +1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
AS [Fiscal_Year],
 
CASE WHEN salesorder_ext.FUNDING IS NULL OR salesorder_ext.FUNDING = 'unknown' THEN 'Unknown' ELSE salesorder_ext.FUNDING END AS Funding,
salesorder_ext.ORDER_METHOD,
salesorder_ext.SHIPPERID,
SALESORDER.ORDERTYPE,
convert(varchar(8),SALESORDER.SHIPPEDDATE, 112) SHIPPEDDATE,
convert(varchar(8),SALESORDER.ORDERDATE,112) ORDERDATE,
ACCOUNT.ACCOUNTID,
ACCOUNT.PARENTID,
right(ACCOUNT.ACCOUNTID,8) as CFCID,
SALESORDER.INVOICETOTAL as SO_TFI,
SALESORDER.INVOICETOTAL - SALESORDER.FREIGHT - SALESORDER.TAX AS SO_NET,
SALESORDERDETAIL.QUANTITYSHIPPED as QTY,
SALESORDERDETAIL.EXTENDEDPRICEINVOICED as PRODUCT_EXTENDEDPRICEINVOICED,
CASE
WHEN product.ACTUALID in  ('000901', '000900', '000902','000903') then 'Suite'
when product.ACTUALID like'disc%' OR product.ACTUALID like'cpn%' or product.ACTUALID like'TE%'then 'Discount'
WHEN product.ACTUALID in  ('SSLI') then 'SSLI'
WHEN product.ACTUALID in  ('WORKSHOP') then 'IMPL'
WHEN product.ACTUALID in  ('NONRTN') then 'NONRTN'
when product.ACTUALID like 'IMPSVC%' THEN 'IMPSVC'
ELSE product.family
end
as PRODUCT_Family,
PRODUCT.ACTUALID as PRODUCT_NUMBER,
PRODUCT.NAME as PRODUCT_NAME,
case when account.parentid is null then account.ACCOUNT else ACCOUNT_1.Account end as DistrictOrNoParent,
ACCOUNT.ACCOUNT,
--ACCOUNT.TYPE,
--ACCOUNT.STATUS,
ACCOUNT.REGION,
ADDRESS.CITY,
ADDRESS.STATE,
ADDRESS.COUNTRY,
ADDRESS.POSTALCODE
--ACCOUNTFFEXT.MDR_FILETYPE, 
--ACCOUNTFFEXT.MDR_ENROLLMENT,
--ACCOUNTFFEXT.R_RANK_ENROLL
into #sl_fact
FROM           
SalesLogix.sysdba.SALESORDER
Left JOIN  SalesLogix.sysdba.SALESORDER_EXT ON SALESORDER.SALESORDERID = SALESORDER_EXT.SALESORDERID
Left JOIN SalesLogix.sysdba.SALESORDERDETAIL ON SALESORDER.SALESORDERID = SALESORDERDETAIL.SALESORDERID
left JOIN SalesLogix.sysdba.PRODUCT ON SALESORDERDETAIL.PRODUCTID = PRODUCT.PRODUCTID
Left join SalesLogix.sysdba.ACCOUNT ON SALESORDER.ACCOUNTID = ACCOUNT.ACCOUNTID
INNER JOIN SalesLogix.sysdba.ADDRESS ON ACCOUNT.ADDRESSID = ADDRESS.ADDRESSID
inner JOIN SalesLogix.sysdba.ACCOUNTFFEXT ON ACCOUNT.ACCOUNTID = ACCOUNTFFEXT.ACCOUNTID
left join SalesLogix.sysdba.ACCOUNT AS ACCOUNT_1 ON ACCOUNT.PARENTID = ACCOUNT_1.ACCOUNTID
WHERE       
(SALESORDERDETAIL.EXTENDEDPRICEINVOICED <> '0') AND
(SALESORDERDETAIL.QUANTITYSHIPPED <> 0)
and SALESORDER.SHIPPEDDATE >= DATEADD(year, - 5, GETDATE())



select isnull((select max(cfc_key) from [CFC_DW].dbo.CFC_fact),0) + 
ROW_NUMBER() over (ORDER BY f.CFCID) cfc_key,
-1 Ship_Location_Key,
-1 Ship_Address_Key,
-1 Order_Type_Key,
isnull(ORM.Order_Method_Key, -1) Order_Method_Key,
-1 User_Key,
-1 Ship_Region_Key,
isnull(fy.Fiscal_Year_Key, -1) Fiscal_Year_Key,
-1 MDR_File_Type_Key,
isnull(s.SHIPPER_Key, -1) Shipper_Key,
isnull(FND.Funding_Key, -1) Funding_Key,
isnull(p.Product_Number_Key, -1) Product_Number_Key,
isnull(Account_key, -1) Account_Key,
-1 Bill_Address_Key,
-1 Bill_Location_Key,
isnull(ship_d.date_key,-1) Ship_Date_Key,
-1 Bill_Date_Key,
isnull(ord_d.date_key,-1) Order_Date_Key,
f.QTY Qty_Shiped,
0 Extended_Price

  into #sl_fact_dw
  from #sl_fact f
  left join [Fiscal_Year] fy on f.[Fiscal_Year] = fy.Fiscal_Year
  left join Funding FND on f.Funding = FND.Funding
  left join Order_Method ORM on f.ORDER_METHOD = ORM.Order_Method
  left join Shipper s on f.SHIPPERID = s.SHIPPERID
  left join Product p on f.PRODUCT_NUMBER = p.PRODUCT_NUMBER
  left join Account ACT on f.ACCOUNT = ACT.ACCOUNT
  left join Dim_Date ship_d on f.SHIPPEDDATE = ship_d.date_key
  left join Dim_Date ord_d on f.ORDERDATE = ord_d.date_key    
  

  truncate table cfc_fact;

   insert into CFC_DW.dbo.CFC_fact(
	cfc_key,
	Ship_Location_Key,
	Ship_Address_Key,
	Order_Type_Key,
	Order_Method_Key,
	User_Key,
	Ship_Region_Key,
	Fiscal_Year_Key,
	MDR_File_Type_Key,
	Shipper_Key,
	Funding_Key,
	Product_Number_Key,
	Account_Key,
	Bill_Address_Key,
	Bill_Location_Key,
	Ship_Date_Key,
	Bill_Date_Key,
	Order_Date_Key,
	Qty_Shiped,
	Extended_Price
	)

	select cfc_key,
	Ship_Location_Key,
	Ship_Address_Key,
	Order_Type_Key,
	Order_Method_Key,
	User_Key,
	Ship_Region_Key,
	Fiscal_Year_Key,
	MDR_File_Type_Key,
	Shipper_Key,
	Funding_Key,
	Product_Number_Key,
	Account_Key,
	Bill_Address_Key,
	Bill_Location_Key,
	Ship_Date_Key,
	Bill_Date_Key,
	Order_Date_Key,
	Qty_Shiped,
	Extended_Price

	from #sl_fact_dw
	
	

	
  end;
GO
/****** Object:  Table [dbo].[Account]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Account](
	[Account_key] [int] NOT NULL,
	[ACCOUNTID] [varchar](25) NULL,
	[ACCOUNT] [varchar](250) NULL,
 CONSTRAINT [Account_PK] PRIMARY KEY CLUSTERED 
(
	[Account_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Address]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Address](
	[ADDRESS_Key] [int] NOT NULL,
	[Addr1] [varchar](150) NULL,
	[Addr2] [varchar](150) NULL,
 CONSTRAINT [Address_PK] PRIMARY KEY CLUSTERED 
(
	[ADDRESS_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CFC_fact]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CFC_fact](
	[cfc_key] [bigint] NOT NULL,
	[Ship_Location_Key] [int] NOT NULL,
	[Ship_Address_Key] [int] NOT NULL,
	[Order_Type_Key] [int] NOT NULL,
	[Order_Method_Key] [int] NOT NULL,
	[User_Key] [int] NOT NULL,
	[Ship_Region_Key] [int] NOT NULL,
	[Fiscal_Year_Key] [int] NOT NULL,
	[MDR_File_Type_Key] [int] NOT NULL,
	[Shipper_Key] [int] NOT NULL,
	[Funding_Key] [int] NOT NULL,
	[Product_Number_Key] [int] NOT NULL,
	[Account_Key] [int] NOT NULL,
	[Bill_Address_Key] [int] NOT NULL,
	[Bill_Location_Key] [int] NOT NULL,
	[Ship_Date_Key] [int] NOT NULL,
	[Bill_Date_Key] [int] NOT NULL,
	[Order_Date_Key] [int] NOT NULL,
	[Qty_Shiped] [int] NULL,
	[Extended_Price] [numeric](12, 3) NULL,
 CONSTRAINT [CFC_fact_PK] PRIMARY KEY CLUSTERED 
(
	[cfc_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dim_Date]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dim_Date](
	[Date_Key] [int] NOT NULL,
	[DateVal] [date] NULL,
	[DateDesc] [varchar](50) NULL,
	[CalenderMonth] [int] NULL,
	[CalenderMonthDesc] [varchar](50) NULL,
	[CalenderQuarter] [varchar](50) NULL,
	[CalenderQuarterDesc] [varchar](50) NULL,
	[CalenderYear] [int] NULL,
 CONSTRAINT [Dim_Date_PK] PRIMARY KEY CLUSTERED 
(
	[Date_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Fiscal_Year]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fiscal_Year](
	[Fiscal_Year_Key] [int] NOT NULL,
	[Fiscal_Year] [varchar](50) NULL,
 CONSTRAINT [Fiscal year_PK] PRIMARY KEY CLUSTERED 
(
	[Fiscal_Year_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Funding]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Funding](
	[Funding_Key] [int] NOT NULL,
	[Funding] [varchar](50) NULL,
 CONSTRAINT [Funding_PK] PRIMARY KEY CLUSTERED 
(
	[Funding_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Location]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Location](
	[Location_key] [int] NOT NULL,
	[Postcode] [varchar](50) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](100) NULL,
	[Country] [varchar](150) NULL,
 CONSTRAINT [Location_PK] PRIMARY KEY CLUSTERED 
(
	[Location_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MDR_File_Type]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MDR_File_Type](
	[MDR_File_Type_Key] [int] NOT NULL,
	[MDR_File_Type] [varchar](50) NULL,
 CONSTRAINT [MDR file Type_PK] PRIMARY KEY CLUSTERED 
(
	[MDR_File_Type_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order_Method]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order_Method](
	[Order_Method_Key] [int] NOT NULL,
	[Order_Method] [varchar](50) NULL,
 CONSTRAINT [Order method_PK] PRIMARY KEY CLUSTERED 
(
	[Order_Method_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order_Type]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order_Type](
	[Order_Type_Key] [int] NOT NULL,
	[Order_Type] [varchar](50) NULL,
 CONSTRAINT [Order type_PK] PRIMARY KEY CLUSTERED 
(
	[Order_Type_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[Product_Number_Key] [int] NOT NULL,
	[PRODUCT_Family] [varchar](50) NULL,
	[PRODUCT_NUMBER] [char](50) NULL,
	[PRODUCT_NAME] [varchar](100) NULL,
 CONSTRAINT [Product_PK] PRIMARY KEY CLUSTERED 
(
	[Product_Number_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Region]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Region](
	[Region_Key] [int] NOT NULL,
	[Region] [varchar](50) NULL,
 CONSTRAINT [Ship Region_PK] PRIMARY KEY CLUSTERED 
(
	[Region_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Shipper]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Shipper](
	[SHIPPER_Key] [int] NOT NULL,
	[ShipName] [varchar](150) NULL,
	[SHIPPERID] [varchar](50) NULL,
 CONSTRAINT [Shipper_PK] PRIMARY KEY CLUSTERED 
(
	[SHIPPER_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 5/3/2016 12:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[User_Key] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[User2] [varchar](50) NULL,
 CONSTRAINT [User_PK] PRIMARY KEY CLUSTERED 
(
	[User_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Account_FK] FOREIGN KEY([Account_Key])
REFERENCES [dbo].[Account] ([Account_key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Account_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Address_FK] FOREIGN KEY([Bill_Address_Key])
REFERENCES [dbo].[Address] ([ADDRESS_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Address_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Address_FKv1] FOREIGN KEY([Ship_Address_Key])
REFERENCES [dbo].[Address] ([ADDRESS_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Address_FKv1]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Dim_Date_FK] FOREIGN KEY([Ship_Date_Key])
REFERENCES [dbo].[Dim_Date] ([Date_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Dim_Date_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Dim_Date_FKv1] FOREIGN KEY([Bill_Date_Key])
REFERENCES [dbo].[Dim_Date] ([Date_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Dim_Date_FKv1]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Dim_Date_FKv2] FOREIGN KEY([Order_Date_Key])
REFERENCES [dbo].[Dim_Date] ([Date_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Dim_Date_FKv2]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Fiscal_Year_FK] FOREIGN KEY([Fiscal_Year_Key])
REFERENCES [dbo].[Fiscal_Year] ([Fiscal_Year_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Fiscal_Year_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Funding_FK] FOREIGN KEY([Funding_Key])
REFERENCES [dbo].[Funding] ([Funding_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Funding_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Location_FK] FOREIGN KEY([Ship_Location_Key])
REFERENCES [dbo].[Location] ([Location_key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Location_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Location_FKv1] FOREIGN KEY([Bill_Location_Key])
REFERENCES [dbo].[Location] ([Location_key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Location_FKv1]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_MDR_File_Type_FK] FOREIGN KEY([MDR_File_Type_Key])
REFERENCES [dbo].[MDR_File_Type] ([MDR_File_Type_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_MDR_File_Type_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Order_Method_FK] FOREIGN KEY([Order_Method_Key])
REFERENCES [dbo].[Order_Method] ([Order_Method_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Order_Method_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Order_Type_FK] FOREIGN KEY([Order_Type_Key])
REFERENCES [dbo].[Order_Type] ([Order_Type_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Order_Type_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Product_FK] FOREIGN KEY([Product_Number_Key])
REFERENCES [dbo].[Product] ([Product_Number_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Product_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Region_FK] FOREIGN KEY([Ship_Region_Key])
REFERENCES [dbo].[Region] ([Region_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Region_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_Shipper_FK] FOREIGN KEY([Shipper_Key])
REFERENCES [dbo].[Shipper] ([SHIPPER_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_Shipper_FK]
GO
ALTER TABLE [dbo].[CFC_fact]  WITH CHECK ADD  CONSTRAINT [CFC_fact_User_FK] FOREIGN KEY([User_Key])
REFERENCES [dbo].[User] ([User_Key])
GO
ALTER TABLE [dbo].[CFC_fact] CHECK CONSTRAINT [CFC_fact_User_FK]
GO
USE [master]
GO
ALTER DATABASE [CFC_DW] SET  READ_WRITE 
GO
