SELECT       
CAST(CASE WHEN month(Salesorder.shippeddate) IN (1, 2, 3) THEN year(Salesorder.shippeddate) - 1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
+ '-' +
CAST(CASE WHEN month(Salesorder.shippeddate) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(Salesorder.shippeddate) +1
ELSE year(Salesorder.shippeddate) END AS varchar(4))
AS [Fiscal Year],
 
CASE WHEN sysdba.salesorder_ext.FUNDING IS NULL OR sysdba.salesorder_ext.FUNDING = 'unknown' THEN 'Unknown' ELSEsysdba.salesorder_ext.FUNDING END AS Funding,
sysdba.salesorder_ext.ORDER_METHOD,
sysdba.salesorder_ext.SHIPPERID,
sysdba.SALESORDER.ORDERTYPE,
 
sysdba.SALESORDER.SHIPPEDDATE,
sysdba.SALESORDER.ORDERDATE,
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
 
 
UNION
 
select
--CAST(CASE WHEN ARDocType='IN' and  month(ShipDateAct) IN (1, 2, 3) THEN year(ShipDateAct) - 1
--ELSE
--year(ShipDateAct) END AS varchar(4))
--+ '-' +
--CAST(CASE WHEN ARDocType='IN' and  month(ShipDateAct) IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN year(ShipDateAct) + 1
--ELSE year(ShipDateAct) END AS varchar(4))
CAST(CASE WHEN  month(soh.OrdDate) IN (1, 2, 3) THEN year(soh.OrdDate) - 1 ELSE year(soh.OrdDate) END ASvarchar(4))
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
(select right(ltrim(rtrim(cu.User1)),8) as CFC_ID from [CFCAPP].dbo.[Customer] as cu where cu.custid=soh.custid) asCFCID,
soh.CuryTotInvc as SO_TFI,
soh.CuryTotInvc-TotFrtCost-TotTax as SO_NET,
sol.QtyShip as QTY,
sol.CuryTotInvc as PRODUCT_EXTENDEDPRICEINVOICED,
Case when sol.ItemGLClassID  like 'SS%' then 'Second Step' when sol.ItemGLClassID  like 'bp%' then 'BPU' whensol.ItemGLClassID  like 'cp%' then 'CPU'
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
SOH.ShipZip
 
--orddate, ShipDateAct, soh.ShipperID, SOTypeID, ARDocType, Cancelled,*
from
CFCAPP.dbo.SOShipHeader as soh
left join sysdba.SALESORDER_EXT as so_ext on so_ext.shipperid=soh.ShipperID
inner join CFCAPP.dbo.SOShipLine as sol on sol.ShipperID=soh.ShipperID
 
where
--soh.shipperid='366312'
so_ext.SHIPPERID is null and
Cancelled=0
--order by soh.OrdDate desc
 
 
ORDER BY SHIPPEDDATE DESC , SHIPPERID

