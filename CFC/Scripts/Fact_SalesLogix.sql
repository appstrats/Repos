create PROC sp_populate_SalesLogix_fact  as
begin
set nocount on


SELECT       
CAST(CASE WHEN month(Salesorder.shippeddate) IN (1, 2, 3) THEN year(Salesorder.shippeddate) - 1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
+ '-' +
CAST(CASE WHEN month(Salesorder.shippeddate) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(Salesorder.shippeddate) +1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
AS [Fiscal_Year],
 
CASE WHEN sysdba.salesorder_ext.FUNDING IS NULL OR sysdba.salesorder_ext.FUNDING = 'unknown' THEN 'Unknown' ELSE sysdba.salesorder_ext.FUNDING END AS Funding,
sysdba.salesorder_ext.ORDER_METHOD,
sysdba.salesorder_ext.SHIPPERID,
sysdba.SALESORDER.ORDERTYPE,
convert(varchar(8),sysdba.SALESORDER.SHIPPEDDATE, 112) SHIPPEDDATE,
convert(varchar(8),sysdba.SALESORDER.ORDERDATE,112) ORDERDATE,
sysdba.ACCOUNT.ACCOUNTID,
sysdba.ACCOUNT.PARENTID,
right(sysdba.ACCOUNT.ACCOUNTID,8) as CFCID,
sysdba.SALESORDER.INVOICETOTAL as SO_TFI,
sysdba.SALESORDER.INVOICETOTAL - sysdba.SALESORDER.FREIGHT - sysdba.SALESORDER.TAX AS SO_NET,
sysdba.SALESORDERDETAIL.QUANTITYSHIPPED as QTY,
sysdba.SALESORDERDETAIL.EXTENDEDPRICEINVOICED as PRODUCT_EXTENDEDPRICEINVOICED,
CASE
WHEN sysdba.product.ACTUALID in  ('000901', '000900', '000902','000903') then 'Suite'
when sysdba.product.ACTUALID like'disc%' OR sysdba.product.ACTUALID like'cpn%' or sysdba.product.ACTUALID like'TE%'then 'Discount'
WHEN sysdba.product.ACTUALID in  ('SSLI') then 'SSLI'
WHEN sysdba.product.ACTUALID in  ('WORKSHOP') then 'IMPL'
WHEN sysdba.product.ACTUALID in  ('NONRTN') then 'NONRTN'
when sysdba.product.ACTUALID like 'IMPSVC%' THEN 'IMPSVC'
ELSE sysdba.product.family
end
as PRODUCT_Family,
sysdba.PRODUCT.ACTUALID as PRODUCT_NUMBER,
sysdba.PRODUCT.NAME as PRODUCT_NAME,
case when account.parentid is null then account.ACCOUNT else ACCOUNT_1.Account end as DistrictOrNoParent,
sysdba.ACCOUNT.ACCOUNT,
--sysdba.ACCOUNT.TYPE,
--sysdba.ACCOUNT.STATUS,
sysdba.ACCOUNT.REGION,
SYSDBA.ADDRESS.CITY,
sysdba.ADDRESS.STATE,
sysdba.ADDRESS.COUNTRY,
sysdba.ADDRESS.POSTALCODE
--sysdba.ACCOUNTFFEXT.MDR_FILETYPE, 
--sysdba.ACCOUNTFFEXT.MDR_ENROLLMENT,
--sysdba.ACCOUNTFFEXT.R_RANK_ENROLL
into #sl_fact
FROM           
sysdba.SALESORDER
Left JOIN  sysdba.SALESORDER_EXT ON sysdba.SALESORDER.SALESORDERID = sysdba.SALESORDER_EXT.SALESORDERID
Left JOIN sysdba.SALESORDERDETAIL ON sysdba.SALESORDER.SALESORDERID = sysdba.SALESORDERDETAIL.SALESORDERID
left JOIN sysdba.PRODUCT ON sysdba.SALESORDERDETAIL.PRODUCTID = sysdba.PRODUCT.PRODUCTID
Left join sysdba.ACCOUNT ON sysdba.SALESORDER.ACCOUNTID = sysdba.ACCOUNT.ACCOUNTID
INNER JOIN sysdba.ADDRESS ON sysdba.ACCOUNT.ADDRESSID = sysdba.ADDRESS.ADDRESSID
inner JOIN sysdba.ACCOUNTFFEXT ON sysdba.ACCOUNT.ACCOUNTID = sysdba.ACCOUNTFFEXT.ACCOUNTID
left join sysdba.ACCOUNT AS ACCOUNT_1 ON ACCOUNT.PARENTID = ACCOUNT_1.ACCOUNTID
WHERE       
(sysdba.SALESORDERDETAIL.EXTENDEDPRICEINVOICED <> '0') AND
(sysdba.SALESORDERDETAIL.QUANTITYSHIPPED <> 0)
and sysdba.SALESORDER.SHIPPEDDATE >= DATEADD(year, - 5, GETDATE())



select isnull((select max(cfc_key) from [CFC_DW].dbo.CFC_fact),0) + 
ROW_NUMBER() over (ORDER BY T_fact.ACCOUNTID) cfc_key,
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
Bill_Date_Key,
isnull(ord_d.date_key,-1) Order_Date_Key,
f.QTY, Qty_Shiped,
0 Extended_Price

  into #sl_fact_dw
  from #sl_fact f
  left join [Fiscal_Year] fy on f.[Fiscal_Year] = fy.Fiscal_Year
  left join Funding FND on f.Funding = FND.Funding
  left join Order_Method ORM on f.ORDER_METHOD = ORM.Order_Method
  left join Shipper s on f.SHIPPERID = s.SHIPPERID
  left join Product p on f.PRODUCT_NUMBER = p.PRODUCT_NUMBER
  left join Account ACT on f.ACCOUNT = ACT.ACCOUNT
  left join Dim_Date ship_d on f.SHIPPEDDATE = d.date_key
  left join Dim_Date ord_d on f.ORDERDATE = ord_d.date_key    
  
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