sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d master -i "G:\Projects\appstrats\MFTG_DW\Scripts\ETL_Configuration_Schema_1.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d master -i "G:\Projects\appstrats\MFTG_DW\Scripts\MFTG_DW_Schema_1.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\MFTG_DW_population_objects_2.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d ETL_Configuration -i "G:\Projects\appstrats\MFTG_DW\Scripts\ETL POP_Loadid.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\MFTG_DW_Defaults dim tables_3.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\UK DimPop - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt 
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Advantech DimPop- sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Advantech DimPop_label - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Fremont DimPop - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\SENAO DimPop - sprocs_4.sql" -l 60 >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Sercomm DimPop - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Sercomm DimPop_label - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\Tiwan DimPop_label - sprocs_4.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_fremont_6.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_senao_6.sql"  -l 60 >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_sercomm_6.sql"  -l 60 >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_sercomm_7.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_taiwan_label.sql"  -l 60 >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_uk_6.sql" -l 60  >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_advantech.sql" -l 60 >> "G:\Projects\mftg\error_log.txt
sqlcmd -S apps01.dynu.net,1451 -U sa -P idrive1 -d MFTG_DW -i "G:\Projects\appstrats\MFTG_DW\Scripts\fact_advantech_label.sql" -l 60  >> "G:\Projects\mftg\error_log.txt