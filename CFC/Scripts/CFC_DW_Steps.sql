--CFC_DW Population Steps
/*
1. create schema using cfc_dw_schema.sql
2. Create default entries using dim_default.sql
3. Create Saleslogix dim population procedures using dim_pop_saleslogix.sql
4. Create CFCApp dim population procedurs using dim_pop_cfcapp.sql
5. Create other procedures like date popluation using Misc_DW_Population.sql
6. Create fact population procedure using Fact_pop.sql
7. Run the below steps
*/
use cfc_dw
go

-- Populate Date dimenion values
exec sp_populate_date_dim 2007;
exec sp_populate_date_dim 2008;
exec sp_populate_date_dim 2009;
exec sp_populate_date_dim 2010;
exec sp_populate_date_dim 2011;
exec sp_populate_date_dim 2012;
exec sp_populate_date_dim 2013;
exec sp_populate_date_dim 2014;
exec sp_populate_date_dim 2015;
exec sp_populate_date_dim 2016;

-- Populate FY dimenion values
exec sp_populate_FY_dim 2007;
exec sp_populate_FY_dim 2008;
exec sp_populate_FY_dim 2009;
exec sp_populate_FY_dim 2010;
exec sp_populate_FY_dim 2011;
exec sp_populate_FY_dim 2012;
exec sp_populate_FY_dim 2013;
exec sp_populate_FY_dim 2014;
exec sp_populate_FY_dim 2015;
exec sp_populate_FY_dim 2016;

-- Populate Dimension from SalesLogix
exec sp_pop_account_SalesLogix;
exec sp_pop_region_SalesLogix;
exec sp_pop_product_SalesLogix;
exec sp_pop_ordertype_SalesLogix;
exec sp_pop_Order_Method_SalesLogix;
exec sp_pop_MDR_file_Type_SalesLogix;
exec sp_pop_User_SalesLogix;
exec sp_pop_Funding_SalesLogix;
exec sp_pop_address_SalesLogix;
exec sp_pop_location_SalesLogix;
exec sp_pop_Shipper_SalesLogix;

-- Populate Dimension from CFCAPP
exec sp_pop_account_CFCAPP;
exec sp_pop_region_CFCAPP;
exec sp_pop_procuct_CFCAPP;
exec sp_pop_ordertype_CFCAPP;
exec sp_pop_Order_Method_CFCAPP;
exec sp_pop_User_CFCAPP;
exec sp_pop_Funding_CFCAPP;
exec sp_pop_address_CFCAPP;
exec sp_pop_location_CFCAPP;
exec sp_pop_Shipper_CFCAPP; 

--Populate fact from SalesLogix and CFCAPP
exec sp_populate_fact

--select sample data
select top 10 * from vw_cfc_fact