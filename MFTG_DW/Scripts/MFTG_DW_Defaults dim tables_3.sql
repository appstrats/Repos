--To insert the default row in dimenstions 

if not exists(select * from [dbo].[Assembly_D] where [AssemblyKey] = -1)
INSERT into [dbo].[Assembly_D] ([AssemblyNumber],[AssemblyKey]) values ('Unknown',-1);

insert into dbo.DataSource_D (DataSourceKey,DataSource,DataSourceDescription,Supplier) values (-1,'Unknown','Unknown','Unknown');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(1,'MFGTESTC_FREMONT','Flash Fremont','Flash Fremont');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(2,'SENAO_MFGTESTC_TAIWAN','Senao Shopfloor','SENAO');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(3,'MFGTESTC_UK','Flash UK','Flash UK');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(4,'MES2_SERCOMM','Flash MES2_SERCOMM','Flash MES2_SERCOMM');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(8,'MFGTESTC_TAIWAN_SERCOMM','Flash MFGTESTC_TAIWAN_SERCOMM','Flash MFGTESTC_TAIWAN_SERCOMM');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(9,'MFGTESTC_ADVANTECH','Flash MFGTESTC_ADVANTECH','Flash MFGTESTC_ADVANTECH');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(10,'SHOPFLOOR_ADVANTECH','Flash SHOPFLOOR_ADVANTECH','Flash SHOPFLOOR_ADVANTECH');
insert into dbo.[DataSource_D](DataSourceKey,DataSource,DataSourceDescription,Supplier)values(11,'MFGTESTC_TAIWAN','Flash MFGTESTC_TAIWAN','Flash MFGTESTC_TAIWAN');

insert into dbo.FirmwareVersion_D (FirmwareVersionKey,FirmwareVersion) values (-1,'Unknown');

insert into [dbo].[IRV_D] ([IRVKey],[IRV]) values (-1,'Unknown');

insert into [dbo].[IsRMA_D] ([IsRMAKey],[IsRMA]) values (-1,-1);
insert into [dbo].IsRMA_D(IsRMAKey,IsRMA)values(1,1);
insert into [dbo].IsRMA_D(IsRMAKey,IsRMA)values(2,0);


insert into dbo.Location_D (LocationKey,LocationCode,Location,Country)values (-1,-1,'Unknown','Unknown');

insert into dbo.ManufacturingId_D(MIDKey,MID)values(-1,'Unknown');

insert into dbo.PartNumber_D(PartNumberKey,PartNumberCode,PartNumber,Revision,Description) values (-1,-1,'Unknown','Unknown','Unknown');

insert into dbo.RegulatoryModel_D(RegulatoryModelKey,RegulatoryModel)values (-1,'Unknown');

insert into dbo.ROMVersion_D(ROMVersionKey,ROMVersion)values(-1,'Unknown');

insert into dbo.DateCode_D(DateCodeKey,DateCode)values(-1,'Unknown');

insert into dbo.SafemodeVersion_D(SafemodeVersionKey,SafemodeVersion)values(-1,'Unknown');

insert into dbo.SerialNumber_D(SerialNumberKey,SerialNumber,AuthCode)values(-1,'Unknown','Unknown');

insert into dbo.SKU_D(SKUKey,SKU,SKUDescription)values(-1,'Unknown','Unknown');

insert into dbo.StepResultCode_D(StepResultCodeKey,StepResultValue,Description)values(-1,-1,'Unknown');

insert into dbo.Station_D(StationKey,Station)values(-1,'Unknown');
insert into dbo.StationType_D(StationTypeKey,StationType)values(-1,'Unknown');


insert into [dbo].[WorkOrder_D] ([WorkOrderKey],[WorkOrderNumber]) values (-1,'Unknown');

--select count(*) from 

insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(-1,-1);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(0,0);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(1,1);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(2,2);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(3,3);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(4,4);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(5,5);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(6,6);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(7,7);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(8,8);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(9,9);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(10,10);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(11,11);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(12,12);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(13,13);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(14,14);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(15,15);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(16,16);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(17,17);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(18,18);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(19,19);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(20,20);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(21,21);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(22,22);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(23,23);
insert into dbo.TransactionHour_D(Transactionhourkey,TransactionHour)values(24,24);

insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(-1,-1);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(0,0);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(1,1);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(2,2);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(3,3);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(4,4);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(5,5);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(6,6);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(7,7);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(8,8);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(9,9);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(10,10);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(11,11);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(12,12);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(13,13);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(14,14);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(15,15);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(16,16);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(17,17);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(18,18);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(19,19);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(20,20);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(21,21);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(22,22);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(23,23);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(24,24);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(25,25);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(26,26);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(27,27);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(28,28);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(29,29);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(30,30);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(31,31);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(32,32);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(33,33);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(34,34);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(35,35);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(36,36);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(37,37);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(38,38);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(39,39);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(40,40);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(41,41);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(42,42);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(43,43);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(44,44);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(45,45);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(46,46);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(47,47);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(48,48);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(49,49);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(50,50);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(51,51);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(52,52);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(53,53);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(54,54);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(55,55);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(56,56);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(57,57);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(58,58);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(59,59);
insert into dbo.TransactionMinute_D(TransactionMinuteKey,TransactionMinute)values(60,60);


GO
exec sp_populate_trandate 2007
exec sp_populate_trandate 2008
exec sp_populate_trandate 2009
exec sp_populate_trandate 2010
exec sp_populate_trandate 2011
exec sp_populate_trandate 2012
exec sp_populate_trandate 2013
exec sp_populate_trandate 2014
exec sp_populate_trandate 2015
exec sp_populate_trandate 2016
GO






 