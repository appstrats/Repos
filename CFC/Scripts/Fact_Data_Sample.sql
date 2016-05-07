select top 5
sloc.Postcode Ship_Postcode,
sadd.addr1 shipaddress,
odr_t. Order_Type,
ORM.Order_Method,
u.[name] username,
r.region shipregion,
fy.Fiscal_Year,
mdrft.MDR_File_Type,
s.ShipName,
FND.Funding,
p.PRODUCT_NAME,
act.ACCOUNT,
badd.addr1 shipaddress,
sloc.Postcode Ship_Postcode,
ship_d.DateVal,
bill_d.DateVal,
ord_d.DateVal,
Qty_Shiped,
Extended_Price

  from cfc_fact f
  left join [Address] sadd on f.Ship_Address_Key = sadd.Address_Key
  left join [User] u on f.User_Key = u.User_Key
  left join Region r on f.Ship_Region_Key = r.Region_key
  left join [Fiscal_Year] fy on f.Fiscal_Year_Key = fy.Fiscal_Year_Key
  left join Funding FND on f.Funding_Key = FND.Funding_Key
  left join Order_Method ORM on f.Order_Method_Key = ORM.Order_Method_Key
  left join Shipper s on f.Shipper_Key = s.Shipper_Key
  left join Product p on f.Product_Number_Key = p.Product_Number_Key
  left join [Address] badd on f.Bill_Address_Key = badd.Address_Key
  left join Account ACT on f.Account_Key = ACT.Account_Key
  left join Dim_Date ship_d on f.Ship_Date_Key = ship_d.date_key
  left join Dim_Date ord_d on f.Order_Date_Key = ord_d.date_key    
  left join Dim_Date bill_d on f.Bill_Date_Key = bill_d.date_key
  left join [Order_Type] odr_t on f.Order_Type_Key = odr_t.Order_Type_Key
  left join [Location] sloc on f.Ship_Location_Key = sloc.Location_Key
  left join [Location] bloc on f.Bill_Location_Key = bloc.Location_Key
  left join [MDR_File_Type] mdrft on f.MDR_File_Type_Key = mdrft.MDR_File_Type_Key