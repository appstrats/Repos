use CFC_DW
go
--exec sp_populate_fact 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].sp_populate_fact'))
DROP PROC [dbo].sp_populate_fact
go

create PROC sp_populate_fact  as
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
ADDRESS.POSTALCODE,
ACCOUNTFFEXT.MDR_FILETYPE, 
--ACCOUNTFFEXT.MDR_ENROLLMENT,
--ACCOUNTFFEXT.R_RANK_ENROLL
SALESORDER.FFShipto_Zip shippostcode

UNION
 
select
--CAST(CASE WHEN ARDocType='IN' and  month(ShipDateAct) IN (1, 2, 3) THEN year(ShipDateAct) - 1
--ELSE
--year(ShipDateAct) END AS varchar(4))
--+ '-' +
--CAST(CASE WHEN ARDocType='IN' and  month(ShipDateAct) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(ShipDateAct) + 1
--ELSE year(ShipDateAct) END AS varchar(4))
CAST(CASE WHEN  month(soh.OrdDate) IN (1, 2, 3) THEN year(soh.OrdDate) - 1 ELSE year(soh.OrdDate) END AS varchar(4))
+ '-' +
CAST(CASE WHEN  month(soh.OrdDate) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(soh.OrdDate) + 1 ELSE year(soh.OrdDate) End AS varchar(4))
AS [Fiscal Year],
Case when soh.User4='' or soh.user4='unknown' then 'Unknown' else soh.user4 end as Funding,
soh.User3 as ORDER_METHOD,
SOH.SHIPPERID,
SOH.SOTYPEID AS ORDERTYPE,
ShipDateAct,
soh.OrdDate,
(select ltrim(rtrim(cu.User1)) from [CFCAPP].dbo.[Customer] as cu where cu.custid=soh.custid) as ACCOUNTID,
(SELECT PARENTID FROM SalesLogix.SYSDBA.ACCOUNT AS A WHERE A.EXTERNALACCOUNTNO=SOH.CustID) AS PARENTID,
(select right(ltrim(rtrim(cu.User1)),8) as CFC_ID from [CFCAPP].dbo.[Customer] as cu where cu.custid=soh.custid) as CFCID,
soh.CuryTotInvc as SO_TFI,
soh.CuryTotInvc-TotFrtCost-TotTax as SO_NET,
sol.QtyShip as QTY,
sol.CuryTotInvc as PRODUCT_EXTENDEDPRICEINVOICED,
Case when sol.ItemGLClassID  like 'SS%' then 'Second Step' when sol.ItemGLClassID  like 'bp%' then 'BPU' when sol.ItemGLClassID  like 'cp%' then 'CPU'
when sol.InvtID like'disc%' OR sol.InvtID like'cpn%' or sol.InvtID like'TE%' then 'Discount'
when sol.InvtID in  ('000901', '000900', '000902','000903') then 'Suite'
when sol.ItemGLClassID  like 'SR%' then 'Steps To Respect'
else sol.ItemGLClassID
end AS PRODUCT_FAMILY,
SOL.InvtID AS PRODUCT_NUMBER,
SOL.Descr,
(SELECT
case when a.parentid is null then a.ACCOUNT else ACCOUNT_1.Account end as DistrictOrNoParent
--ACCOUNT_1.account
FROM SalesLogix.SYSDBA.ACCOUNT AS A
left join sysdba.ACCOUNT AS ACCOUNT_1 ON A.PARENTID = ACCOUNT_1.ACCOUNTID
WHERE A.EXTERNALACCOUNTNO=SOH.CustID
) AS DistrictOrNoParent,
(select cu.Name from [CFCAPP].dbo.[Customer] as cu where cu.custid=soh.custid) as ACCOUNT,
(SELECT REGION FROM SalesLogix.SYSDBA.ACCOUNT AS A WHERE A.EXTERNALACCOUNTNO=SOH.CustID) AS REGION,
SOH.ShipCity,
SOH.ShipState,
SOH.ShipCountry,
SOH.ShipZip,
'' mdrfiletype,
'' shipzip
 
--orddate, ShipDateAct, soh.ShipperID, SOTypeID, ARDocType, Cancelled,*
from
CFCAPP.dbo.SOShipHeader as soh
left join sysdba.SALESORDER_EXT as so_ext on so_ext.shipperid=soh.ShipperID
inner join CFCAPP.dbo.SOShipLine as sol on sol.ShipperID=soh.ShipperID 
where --soh.shipperid='366312' 
so_ext.SHIPPERID is null and Cancelled = 0 

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
isnull (Location_key,-1) Ship_Location_Key,
-1 Ship_Address_Key,
isnull (Order_Type_Key,-1) Order_Type_Key,
isnull(ORM.Order_Method_Key, -1) Order_Method_Key,
-1 User_Key,
isnull(Region_Key,-1) Ship_Region_Key,
isnull(fy.Fiscal_Year_Key, -1) Fiscal_Year_Key,
isnull(mdrft.MDR_File_Type_Key,-1) MDR_File_Type_Key,
isnull(s.SHIPPER_Key, -1) Shipper_Key,
isnull(FND.Funding_Key, -1) Funding_Key,
isnull(p.Product_Number_Key, -1) Product_Number_Key,
isnull(Account_key, -1) Account_Key,
-1 Bill_Address_Key,
isnull (Location_key,-1) Bill_Location_Key,
isnull(ship_d.date_key,-1) Ship_Date_Key,
-1 Bill_Date_Key,
isnull(ord_d.date_key,-1) Order_Date_Key,
f.QTY Qty_Shiped,
f.PRODUCT_EXTENDEDPRICEINVOICED Extended_Price

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
  left join [Order_Type] odr_t on f.ORDERTYPE = odr_t.Order_Type
  left join [Location] sloc on f.shippostcode = sloc.Postcode
  left join [Location] bloc on f.ShipZip = bloc.Postcode
  left join [MDR_File_Type] mdrft on f.MDR_FILETYPE = mdrft.MDR_File_Type
  left join Region rgn on f.REGION = s.Region

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