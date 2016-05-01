-- Generated by Oracle SQL Developer Data Modeler 4.0.1.836
--   at:        2016-04-29 19:04:06 IST
--   site:      SQL Server 2008
--   type:      SQL Server 2008




ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Account_FK
GO
DROP TABLE Account
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Address_FK
GO
ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Address_FKv1
GO
DROP TABLE Address
GO

DROP
  TABLE CFC_fact
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Dim_Date_FK
GO
ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Dim_Date_FKv1
GO
ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Dim_Date_FKv2
GO
DROP
  TABLE Dim_Date
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Fiscal_Year_FK
GO
DROP
  TABLE Fiscal_Year
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Funding_FK
GO
DROP TABLE Funding
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Location_FK
GO
ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Location_FKv1
GO
DROP
  TABLE Location
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_MDR_File_Type_FK
GO
DROP
  TABLE MDR_File_Type
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Order_Method_FK
GO
DROP
  TABLE Order_Method
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Order_Type_FK
GO
DROP
  TABLE Order_Type
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Product_FK
GO
DROP TABLE Product
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Region_FK
GO
DROP TABLE Region
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_Shipper_FK
GO
DROP TABLE Shipper
GO

ALTER TABLE CFC_fact
DROP
  CONSTRAINT CFC_fact_User_FK
GO
DROP TABLE "User"
GO

CREATE
  TABLE Account
  (
    Account_key INTEGER NOT NULL ,
    ACCOUNTID   VARCHAR (25) ,
    ACCOUNT     VARCHAR (250) ,
    CONSTRAINT Account_PK PRIMARY KEY CLUSTERED (Account_key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Address
  (
    ADDRESS_Key INTEGER NOT NULL ,
    Addr1       VARCHAR (50) ,
    Addr2       VARCHAR (50) ,
    CONSTRAINT Address_PK PRIMARY KEY CLUSTERED (ADDRESS_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE CFC_fact
  (
    cfc_key BIGINT NOT NULL ,
    Ship_Location_Key  INTEGER NOT NULL ,
    Ship_Address_Key   INTEGER NOT NULL ,
    Order_Type_Key     INTEGER NOT NULL ,
    Order_Method_Key   INTEGER NOT NULL ,
    User_Key           INTEGER NOT NULL ,
    Ship_Region_Key    INTEGER NOT NULL ,
    Fiscal_Year_Key    INTEGER NOT NULL ,
    MDR_File_Type_Key  INTEGER NOT NULL ,
    Shipper_Key        INTEGER NOT NULL ,
    "Funding Key"      INTEGER NOT NULL ,
    Product_Number_Key INTEGER NOT NULL ,
    Account_Key        INTEGER NOT NULL ,
    Bill_Address_Key   INTEGER NOT NULL ,
    Bill_Location_Key  INTEGER NOT NULL ,
    Ship_Date_Key      INTEGER NOT NULL ,
    Bill_Date_Key      INTEGER NOT NULL ,
    Order_Date_Key     INTEGER NOT NULL ,
    Qty_Shiped         INTEGER ,
    Extended_Price     NUMERIC (12,3) ,
    CONSTRAINT CFC_fact_PK PRIMARY KEY CLUSTERED (cfc_key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Dim_Date
  (
    Date_Key INTEGER NOT NULL ,
    CONSTRAINT Dim_Date_PK PRIMARY KEY CLUSTERED (Date_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Fiscal_Year
  (
    Fiscal_Year_Key INTEGER NOT NULL ,
    Fiscal_Year     VARCHAR (50) ,
    CONSTRAINT "Fiscal year_PK" PRIMARY KEY CLUSTERED (Fiscal_Year_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Funding
  (
    Funding_Key INTEGER NOT NULL ,
    Funding     VARCHAR (50) ,
    CONSTRAINT Funding_PK PRIMARY KEY CLUSTERED (Funding_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Location
  (
    Location_key INTEGER NOT NULL ,
    Postcode     VARCHAR (50) ,
    City         VARCHAR (150) ,
    State        VARCHAR (100) ,
    Country      VARCHAR (150) ,
    CONSTRAINT Location_PK PRIMARY KEY CLUSTERED (Location_key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE MDR_File_Type
  (
    MDR_File_Type_Key INTEGER NOT NULL ,
    MDR_File_Type     VARCHAR (50) ,
    CONSTRAINT "MDR file Type_PK" PRIMARY KEY CLUSTERED (MDR_File_Type_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Order_Method
  (
    Order_Method_Key INTEGER NOT NULL ,
    Order_Method     VARCHAR (50) ,
    CONSTRAINT "Order method_PK" PRIMARY KEY CLUSTERED (Order_Method_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Order_Type
  (
    Order_Type_Key INTEGER NOT NULL ,
    Order_Type     VARCHAR (50) ,
    CONSTRAINT "Order type_PK" PRIMARY KEY CLUSTERED (Order_Type_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Product
  (
    Product_Number_Key INTEGER NOT NULL ,
    PRODUCT_Family     VARCHAR (50) ,
    PRODUCT_NUMBER     CHAR (50) ,
    PRODUCT_NAME       VARCHAR (100) ,
    CONSTRAINT Product_PK PRIMARY KEY CLUSTERED (Product_Number_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Region
  (
    Region_Key INTEGER NOT NULL ,
    Region     VARCHAR (50) ,
    CONSTRAINT "Ship Region_PK" PRIMARY KEY CLUSTERED (Region_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE Shipper
  (
    SHIPPER_Key INTEGER NOT NULL ,
    ShipName    VARCHAR (100) ,
    SHIPPERID   VARCHAR (50) ,
    CONSTRAINT Shipper_PK PRIMARY KEY CLUSTERED (SHIPPER_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

CREATE
  TABLE "User"
  (
    User_Key INTEGER NOT NULL ,
    Name     VARCHAR (50) ,
    User2    VARCHAR (50) ,
    CONSTRAINT User_PK PRIMARY KEY CLUSTERED (User_Key)
WITH
  (
    ALLOW_PAGE_LOCKS = ON ,
    ALLOW_ROW_LOCKS  = ON
  )
  ON "default"
  )
  ON "default"
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Account_FK FOREIGN KEY
(
Account_Key
)
REFERENCES Account
(
Account_key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Address_FK FOREIGN KEY
(
Bill_Address_Key
)
REFERENCES Address
(
ADDRESS_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Address_FKv1 FOREIGN KEY
(
Ship_Address_Key
)
REFERENCES Address
(
ADDRESS_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Dim_Date_FK FOREIGN KEY
(
Ship_Date_Key
)
REFERENCES Dim_Date
(
Date_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Dim_Date_FKv1 FOREIGN KEY
(
Bill_Date_Key
)
REFERENCES Dim_Date
(
Date_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Dim_Date_FKv2 FOREIGN KEY
(
Order_Date_Key
)
REFERENCES Dim_Date
(
Date_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Fiscal_Year_FK FOREIGN KEY
(
Fiscal_Year_Key
)
REFERENCES Fiscal_Year
(
Fiscal_Year_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Funding_FK FOREIGN KEY
( "Funding Key"
)
REFERENCES Funding
(
Funding_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Location_FK FOREIGN KEY
(
Ship_Location_Key
)
REFERENCES Location
(
Location_key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Location_FKv1 FOREIGN KEY
(
Bill_Location_Key
)
REFERENCES Location
(
Location_key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_MDR_File_Type_FK FOREIGN KEY
(
MDR_File_Type_Key
)
REFERENCES MDR_File_Type
(
MDR_File_Type_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Order_Method_FK FOREIGN KEY
(
Order_Method_Key
)
REFERENCES Order_Method
(
Order_Method_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Order_Type_FK FOREIGN KEY
(
Order_Type_Key
)
REFERENCES Order_Type
(
Order_Type_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Product_FK FOREIGN KEY
(
Product_Number_Key
)
REFERENCES Product
(
Product_Number_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Region_FK FOREIGN KEY
(
Ship_Region_Key
)
REFERENCES Region
(
Region_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_Shipper_FK FOREIGN KEY
(
Shipper_Key
)
REFERENCES Shipper
(
SHIPPER_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO

ALTER TABLE CFC_fact
ADD CONSTRAINT CFC_fact_User_FK FOREIGN KEY
(
User_Key
)
REFERENCES "User"
(
User_Key
)
ON
DELETE
  NO ACTION ON
UPDATE NO ACTION
GO


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0