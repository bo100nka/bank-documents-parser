
###### iban to payer lookup table
	drop table if exists yndev.import_lookup_iban2payer;

	create temporary table yndev.import_lookup_iban2payer as
	select payer_iban, max(payer_name) as payer_name
    from yndev.import_raw
    where payer_iban is not null
    group by payer_iban
    order by 1;
    
    #select * from yndev.import_lookup_iban2payer;

###### payer to vs lookup table
	drop table if exists yndev.import_lookup_payer2vs;

	create temporary table yndev.import_lookup_payer2vs as
	select payer_name, max(vs) as vs
	from yndev.import_raw
	where payer_name is not null
	group by payer_name
	order by 1;

	#select * from yndev.import_lookup_payer2vs;

###### vs to adhoc invoice lookup table
	drop table if exists yndev.import_lookup_vs2adhoc;
    
    create temporary table yndev.import_lookup_vs2adhoc as
    select cast(vs as unsigned) as vs, payer_name, bank_ref as invoice_id, payment_date as invoice_date, cast(null as signed) amount_id, amount
    from yndev.import_raw
    order by 1
    limit 0;
    
    # insert statements below generated from the "payments_wrong_vs" google sheets document located on the shared yellownet google drive folder
    
	insert into yndev.import_lookup_vs2adhoc values (4118,'AGS 92, s.r.o. (4118)', '011022/357', '2022-11-01', null, 153);
	insert into yndev.import_lookup_vs2adhoc values (1108220005,'AGS 92, s.r.o. (4118)', '110822/0005', '2022-08-11', null, 960);
	insert into yndev.import_lookup_vs2adhoc values (2609220009,'AGS 92, s.r.o. (4118)', '260922/0009', '2022-09-26', null, 4300.9);
	insert into yndev.import_lookup_vs2adhoc values (2509230005,'Albrechtová Eva - KADERNÍCTVO EVA (13067)', '250923/0005', '2023-09-25', null, 108);
	insert into yndev.import_lookup_vs2adhoc values (1109230002,'ANJA AGROTECHNIK, s. r. o.', '110923/0002', '2023-09-11', null, 210);
	insert into yndev.import_lookup_vs2adhoc values (807220005,'anstudio s. r. o.', '080722/0005', '2022-07-08', null, 240.84);
	insert into yndev.import_lookup_vs2adhoc values (2701230004,'ART-INVEST, spol. s r.o.', '270123/0004', '2023-01-27', null, 120);
	insert into yndev.import_lookup_vs2adhoc values (2010220006,'AUTO MOTO HERCOG, s.r.o.', '201022/0006', '2022-10-20', null, 252);
	insert into yndev.import_lookup_vs2adhoc values (1210220005,'BeFit Senica', '121022/0005', '2022-10-12', null, 43.2);
	insert into yndev.import_lookup_vs2adhoc values (2610220012,'Bíla Simona (3110)', '261022/0012', '2022-10-26', null, 26.88);
	insert into yndev.import_lookup_vs2adhoc values (203230003,'Bridee.online, s.r.o.', '020323/0003', '2023-03-02', null, 84);
	insert into yndev.import_lookup_vs2adhoc values (303220007,'BRIGHT INVESTMENT GROUP s.r.o.', '030322/0007', '2022-03-03', 5904, 5904);
	insert into yndev.import_lookup_vs2adhoc values (1611220006,'BRIGHT INVESTMENT GROUP s.r.o.', '161122/0006', '2022-11-16', null, 170.4);
	insert into yndev.import_lookup_vs2adhoc values (1804230001,'BRIGHT INVESTMENT GROUP s.r.o.', '180423/0001', '2023-04-18', null, 6000);
	insert into yndev.import_lookup_vs2adhoc values (180822006,'BS vinárske potreby s.r.o.', '180822/0006', '2022-08-18', null, 864);
	insert into yndev.import_lookup_vs2adhoc values (1808220006,'BS vinárske potreby s.r.o.', '180822/0006', '2022-08-18', null, 864);
	insert into yndev.import_lookup_vs2adhoc values (303220003,'BYTSERVIS 2M s.r.o. (4232)', '030322/0003', '2022-03-03', null, 127);
	insert into yndev.import_lookup_vs2adhoc values (4236,'BYTSERVIS SENICA s.r.o. (4236)', '030423/0002', '2023-04-03', null, 168);
	insert into yndev.import_lookup_vs2adhoc values (2504220007,'BYTSERVIS SENICA s.r.o. (4236)', '250422/0007', '2022-04-25', null, 430.8);
	insert into yndev.import_lookup_vs2adhoc values (1406220004,'Dana Hlavnová', '140622/0004', '2022-06-14', null, 115);
	insert into yndev.import_lookup_vs2adhoc values (506230002,'Decorfire s.r.o.', '050623/0002', '2023-06-05', null, 64.92);
	insert into yndev.import_lookup_vs2adhoc values (603230004,'Decorfire s.r.o.', '060323/0004', '2023-03-06', null, 482.76);
	insert into yndev.import_lookup_vs2adhoc values (1109230003,'Dobiaš Pavol - DD Autotechna (4030)', '110923/0003', '2023-09-11', null, 192.6);
	insert into yndev.import_lookup_vs2adhoc values (905220005,'Domov sociálnych služieb a zariadenie pre seniorov Senica', '090522/0005', '2022-05-09', null, 36);
	insert into yndev.import_lookup_vs2adhoc values (102230001,'Ďorďovič Ladislav, JUDr. (4104)', '010223/0001', '2023-02-01', null, 84);
	insert into yndev.import_lookup_vs2adhoc values (103220001,'Duscholux AG', '010322/0001', '2022-03-01', null, 2000);
	insert into yndev.import_lookup_vs2adhoc values (103220002,'Duscholux AG', '010322/0002', '2022-03-01', null, 3075);
	insert into yndev.import_lookup_vs2adhoc values (109220002,'Duscholux AG', '010922/0002', '2022-09-01', null, 1500);
	insert into yndev.import_lookup_vs2adhoc values (109220003,'Duscholux AG', '010922/0003', '2022-09-01', null, 2790);
	insert into yndev.import_lookup_vs2adhoc values (202230003,'Duscholux AG', '020223/0003', '2023-02-02', null, 3780);
	insert into yndev.import_lookup_vs2adhoc values (202230004,'Duscholux AG', '020223/0004', '2023-02-02', null, 450);
	insert into yndev.import_lookup_vs2adhoc values (204220001,'Duscholux AG', '020422/0001', '2022-04-02', null, 1875);
	insert into yndev.import_lookup_vs2adhoc values (204220002,'Duscholux AG', '020422/0002', '2022-04-02', null, 2750);
	insert into yndev.import_lookup_vs2adhoc values (205220002,'Duscholux AG', '020522/0002', '2022-05-02', null, 1800);
	insert into yndev.import_lookup_vs2adhoc values (205220003,'Duscholux AG', '020522/0003', '2022-05-02', null, 1935);
	insert into yndev.import_lookup_vs2adhoc values (205230002,'Duscholux AG', '020523/0002', '2023-05-02', null, 3630);
	insert into yndev.import_lookup_vs2adhoc values (206220002,'Duscholux AG', '020622/0002', '2022-06-02', null, 1860);
	insert into yndev.import_lookup_vs2adhoc values (206220003,'Duscholux AG', '020622/0003', '2022-06-02', null, 2730);
	insert into yndev.import_lookup_vs2adhoc values (207220003,'Duscholux AG', '020722/0003', '2022-07-02', null, 2010);
	insert into yndev.import_lookup_vs2adhoc values (207220004,'Duscholux AG', '020722/0004', '2022-07-02', null, 3540);
	insert into yndev.import_lookup_vs2adhoc values (208220001,'Duscholux AG', '020822/0001', '2022-08-02', null, 1650);
	insert into yndev.import_lookup_vs2adhoc values (208220002,'Duscholux AG', '020822/0002', '2022-08-02', null, 2700);
	insert into yndev.import_lookup_vs2adhoc values (210220002,'Duscholux AG', '021022/0002', '2022-10-02', null, 2190);
	insert into yndev.import_lookup_vs2adhoc values (210220003,'Duscholux AG', '021022/0003', '2022-10-02', null, 2880);
	insert into yndev.import_lookup_vs2adhoc values (211220001,'Duscholux AG', '021122/0001', '2022-11-02', null, 1500);
	insert into yndev.import_lookup_vs2adhoc values (211220002,'Duscholux AG', '021122/0002', '2022-11-02', null, 2700);
	insert into yndev.import_lookup_vs2adhoc values (612220001,'Duscholux AG', '061222/0001', '2022-12-06', null, 750);
	insert into yndev.import_lookup_vs2adhoc values (612220002,'Duscholux AG', '061222/0002', '2022-12-06', null, 2910);
	insert into yndev.import_lookup_vs2adhoc values (1408230001,'Duscholux AG', '140823/0001', '2023-08-14', null, 3030);
	insert into yndev.import_lookup_vs2adhoc values (1512220003,'Duscholux AG', '151222/0003', '2022-12-15', null, 1050);
	insert into yndev.import_lookup_vs2adhoc values (1512220004,'Duscholux AG', '151222/0004', '2022-12-15', null, 2370);
	insert into yndev.import_lookup_vs2adhoc values (3101220003,'Duscholux AG', '310122/0003', '2022-01-31', null, 3000);
	insert into yndev.import_lookup_vs2adhoc values (3101220004,'Duscholux AG', '310122/0004', '2022-01-31', null, 550);
	insert into yndev.import_lookup_vs2adhoc values (203230001,'ECOMMY s.r.o. (4092)', '020323/0001', '2023-03-02', null, 220.8);
	insert into yndev.import_lookup_vs2adhoc values (510220004,'ECOMMY s.r.o. (4092)', '051022/0004', '2022-10-05', null, 234);
	insert into yndev.import_lookup_vs2adhoc values (1812230001,'EIP s.r.o. (1161)', '181223/0001', '2023-12-18', null, 192);
	insert into yndev.import_lookup_vs2adhoc values (304230001,'EKO BUILDING SENICA s. r. o.', '030423/0001', '2023-04-03', null, 336);
	insert into yndev.import_lookup_vs2adhoc values (2101220002,'ERDUTKA s.r.o.', '210122/0002', '2022-01-21', null, 197.8);
	insert into yndev.import_lookup_vs2adhoc values (203230002,'Farma Poživeň', '020323/0002', '2023-03-02', null, 156.6);
	insert into yndev.import_lookup_vs2adhoc values (305220001,'FÉRnet SK s. r. o.', '030522/0001', '2022-05-03', null, 603.66);
	insert into yndev.import_lookup_vs2adhoc values (2906220005,'FÉRnet SK s. r. o.', '290622/0005', '2022-06-29', null, 211.2);
	insert into yndev.import_lookup_vs2adhoc values (1109230001,'Gáborová Dana', '110923/0001', '2023-09-11', null, 100.2);
	insert into yndev.import_lookup_vs2adhoc values (7040,'GEODESY SLOVAKIA, s.r.o. (7040)', '191222/0006', '2022-12-19', null, 135.6);
	insert into yndev.import_lookup_vs2adhoc values (303220009,'Hummer SK s.r.o. (13138)', '030322/0009', '2022-03-03', null, 120);
	insert into yndev.import_lookup_vs2adhoc values (2504230006,'Hyžová Miroslava (7122)', '250423/0006', '2023-04-25', null, 114);
	insert into yndev.import_lookup_vs2adhoc values (2010220007,'Ing. Lucia Kičková', '201022/0007', '2022-10-20', null, 178.8);
	insert into yndev.import_lookup_vs2adhoc values (2209220005,'Ing. Martin Marko', '220922/0005', '2022-09-22', null, 120);
	insert into yndev.import_lookup_vs2adhoc values (9023,'Integrum s.r.o. (9023)', '030322/0004', '2022-03-03', null, 108.4);
	insert into yndev.import_lookup_vs2adhoc values (303220010,'IPBOZ s.r.o. (7125)', '030322/0010', '2022-03-03', null, 83.6);
	insert into yndev.import_lookup_vs2adhoc values (2806230002,'Ján Novák – Applestudio (7144)', '280623/0002', '2023-06-28', null, 165);
	insert into yndev.import_lookup_vs2adhoc values (3105220009,'Jankovič František, Mgr. (7107)', '310522/0009', '2022-06-01', null, 158.4);
	insert into yndev.import_lookup_vs2adhoc values (1118,'Jankovičová Lucia - Euroline (1118)', '191223/0002', '2023-12-01', null, 60);
	insert into yndev.import_lookup_vs2adhoc values (1811220008,'Jankovičová Lucia - Euroline (1118)', '181122/0008', '2022-11-18', null, 204);
	insert into yndev.import_lookup_vs2adhoc values (1407220006,'Jonáš Marián (19023)', '140722/0006', '2022-07-20', null, 60);
	insert into yndev.import_lookup_vs2adhoc values (209220010,'JUMP Košice s.r.o.', '020922/0010', '2022-09-02', null, 2900.4);
	insert into yndev.import_lookup_vs2adhoc values (30322007,'Kapsa Peter (4186)', '030322/0008', '2022-03-03', 156, 156);
	insert into yndev.import_lookup_vs2adhoc values (303220007,'Kapsa Peter (4186)', '030322/0008', '2022-03-03', 156, 156);
	insert into yndev.import_lookup_vs2adhoc values (10023,'Kovo Bernát s.r.o. (10023)', '260922/0008', '2022-09-26', null, 78);
	insert into yndev.import_lookup_vs2adhoc values (501230001,'Kubelet s. r. o.', '050123/0001', '2023-01-05', null, 132);
	insert into yndev.import_lookup_vs2adhoc values (1710230001,'Kubelet s. r. o.', '311022/0013', '2022-10-31', null, 614.87);
	insert into yndev.import_lookup_vs2adhoc values (3006230004,'Kubelet s. r. o.', '300623/0004', '2023-06-30', null, 614.87);
	insert into yndev.import_lookup_vs2adhoc values (3110220013,'Kubelet s. r. o.', '311022/0013', '2022-10-31', null, 138);
	insert into yndev.import_lookup_vs2adhoc values (2510220010,'LEDprodukt s.r.o.', '251022/0010', '2022-10-25', null, 119.4);
	insert into yndev.import_lookup_vs2adhoc values (2809220011,'LEDprodukt s.r.o.', '280922/0011', '2022-09-28', null, 553);
	insert into yndev.import_lookup_vs2adhoc values (303220005,'Ližičiar Martin (13051)', '030322/0005', '2022-03-03', null, 88.44);
	insert into yndev.import_lookup_vs2adhoc values (1007230001,'M3 Partners s.r.o. (4215)', '100723/0001', '2023-07-10', null, 89.28);
	insert into yndev.import_lookup_vs2adhoc values (2110220009,'M3 Partners s.r.o. (4215)', '211022/0009', '2022-10-21', null, 941.4);
	insert into yndev.import_lookup_vs2adhoc values (2408220008,'Marián Končitík', '240822/0008', '2022-08-24', null, 443.88);
	insert into yndev.import_lookup_vs2adhoc values (303220011,'Marmot & Crow s. r. o.', '030322/0011', '2022-03-03', null, 480);
	insert into yndev.import_lookup_vs2adhoc values (310220001,'Marmot & Crow s. r. o.', '031022/0001', '2022-10-03', null, 1328.88);
	insert into yndev.import_lookup_vs2adhoc values (404220003,'Marmot & Crow s. r. o.', '040422/0003', '2022-04-04', null, 521.28);
	insert into yndev.import_lookup_vs2adhoc values (707220002,'Marmot & Crow s. r. o.', '070722/0002', '2022-07-07', null, 348);
	insert into yndev.import_lookup_vs2adhoc values (1005230003,'Marmot & Crow s. r. o.', '100523/0003', '2023-05-10', null, 1017.24);
	insert into yndev.import_lookup_vs2adhoc values (1303230001,'Marmot & Crow s. r. o.', '130323/0001', '2023-03-13', null, 787.8);
	insert into yndev.import_lookup_vs2adhoc values (3112220007,'Marmot & Crow s. r. o.', '311222/0007', '2022-12-31', null, 1223.04);
	insert into yndev.import_lookup_vs2adhoc values (1704230004,'Martin Dvorský', '170423/0004', '2023-04-17', null, 195.84);
	insert into yndev.import_lookup_vs2adhoc values (1103220012,'Materská škola ul.L.Novomeského 1209/2 (4140)', '110322/0012', '2022-03-11', null, 26.4);
	insert into yndev.import_lookup_vs2adhoc values (1901230002,'Materská škola, L. Novomeského 1209/2, Senica', '190123/0002', '2023-01-19', null, 169.32);
	insert into yndev.import_lookup_vs2adhoc values (2511220009,'Materská škola, L. Novomeského 1209/2, Senica', '251122/0009', '2022-11-25', null, 272.72);
	insert into yndev.import_lookup_vs2adhoc values (4121,'MATOMI s.r.o. (4121)', '161122/0007', '2022-11-16', null, 360);
	insert into yndev.import_lookup_vs2adhoc values (2010230002,'MATOMI s.r.o. (4121)', '201023/0002', '2023-10-20', null, 1019.28);
	insert into yndev.import_lookup_vs2adhoc values (9039,'MATOMI s.r.o. (9039)', '210122/0001', '2022-01-21', null, 193.6);
	insert into yndev.import_lookup_vs2adhoc values (604220004,'MATOMI s.r.o. (9039)', '060422/0004', '2022-04-06', null, 89.92);
	insert into yndev.import_lookup_vs2adhoc values (106230001,'MATYSTAV BUILDING, spol. s r.o.', '010623/0001', '2023-06-01', null, 243.12);
	insert into yndev.import_lookup_vs2adhoc values (2010220008,'Mgr. Anna Špániková - LEKÁREŇ ARNIKA (10031)', '201022/0008', '2022-10-20', null, 120);
	insert into yndev.import_lookup_vs2adhoc values (2610220011,'Milion Group s. r. o.', '261022/0011', '2022-10-26', null, 204);
	insert into yndev.import_lookup_vs2adhoc values (1805220007,'MMasset s. r. o.', '180522/0007', '2022-05-18', null, 126);
	insert into yndev.import_lookup_vs2adhoc values (911220003,'MOOVE s. r. o.', '091122/0003', '2022-11-09', null, 92.4);
	insert into yndev.import_lookup_vs2adhoc values (2309220007,'Obec Borský Mikuláš', '230922/0007', '2022-09-23', null, 98.16);
	insert into yndev.import_lookup_vs2adhoc values (305220004,'Obec Rovensko, obecný úrad (9078)', '030522/0004', '2022-05-03', null, 84);
	insert into yndev.import_lookup_vs2adhoc values (908220003,'Obec Smrdáky (10053)', '090822/0003', '2022-08-09', null, 67.2);
	insert into yndev.import_lookup_vs2adhoc values (2701230003,'Olena Dikalová', '270123/0003', '2023-01-27', null, 126);
	insert into yndev.import_lookup_vs2adhoc values (305230001,'PD Koválov (7017)', '030523/0001', '2023-05-03', null, 67.6);
	insert into yndev.import_lookup_vs2adhoc values (704220005,'PD Koválov (7017)', '070422/0005', '2022-04-07', null, 67.6);
	insert into yndev.import_lookup_vs2adhoc values (1704230005,'Poľnohospodárske družstvo Dojč', '170423/0005', '2023-04-17', null, 669.96);
	insert into yndev.import_lookup_vs2adhoc values (1909230004,'Poľnohospodárske družstvo Dojč', '190923/0004', '2023-09-19', null, 231);
	insert into yndev.import_lookup_vs2adhoc values (202230002,'Poľnohospodárske družstvo Senica (4022)', '020223/0002', '2023-02-02', null, 115.91);
	insert into yndev.import_lookup_vs2adhoc values (1708220007,'R-mont Ryšavý, s.r.o.', '170822/0007', '2022-08-17', null, 320.6);
	insert into yndev.import_lookup_vs2adhoc values (306220001,'Rehák Eduard - ADIS (9072)', '030622/0001', '2022-06-03', null, 114);
	insert into yndev.import_lookup_vs2adhoc values (1108220004,'RIGI-STAV s.r.o.', '110822/0004', '2022-08-11', null, 106.8);
	insert into yndev.import_lookup_vs2adhoc values (12025,'RS Farma, s.r.o. (12025)', '230223/0006', '2023-02-23', null, 162.72);
	insert into yndev.import_lookup_vs2adhoc values (905220006,'SAL SERVIS, s.r.o.', '090522/0006', '2022-05-09', null, 87.8);
	insert into yndev.import_lookup_vs2adhoc values (1204220006,'sebu pipe, s.r.o.', '120422/0006', '2022-04-12', null, 184.8);
	insert into yndev.import_lookup_vs2adhoc values (2102220001,'sebu pipe, s.r.o.', '210222/0001', '2022-02-21', null, 150);
	insert into yndev.import_lookup_vs2adhoc values (260722,'SMsoft s.r.o. (4062)', '260722/0007', '2022-07-26', null, 154.39);
	insert into yndev.import_lookup_vs2adhoc values (2607220007,'SMsoft s.r.o. (4062)', '260722/0007', '2022-07-26', null, 154.39);
	insert into yndev.import_lookup_vs2adhoc values (2209220004,'STAVBY BAYER s. r. o.', '220922/0004', '2022-09-22', null, 182.28);
	insert into yndev.import_lookup_vs2adhoc values (2205230004,'Suchánková Melánia - ALEX (7097)', '220523/0004', '2023-05-22', null, 16.2);
	insert into yndev.import_lookup_vs2adhoc values (802230005,'Tomáš Ferenčík', '080223/0005', '2023-02-08', null, 84);
	insert into yndev.import_lookup_vs2adhoc values (1104230003,'Top 1 Agro s.r.o.', '110423/0003', '2023-04-11', null, 654);
	insert into yndev.import_lookup_vs2adhoc values (911220004,'upvision. s.r.o. (4212)', '091122/0004', '2022-11-09', null, 181.8);
	insert into yndev.import_lookup_vs2adhoc values (2701230005,'Vilim Andrej (7075)', '270123/0005', '2023-01-27', null, 72);
	insert into yndev.import_lookup_vs2adhoc values (1205220008,'Vladimír Wiedermann', '120522/0008', '2022-05-12', null, 81.44);
	insert into yndev.import_lookup_vs2adhoc values (1612220005,'Zariadenie sociálnych služieb Senica, n.o.', '161222/0005', '2022-12-16', null, 174.36);
	insert into yndev.import_lookup_vs2adhoc values (2706230003,'zb stav s.r.o. (18000)', '270623/0003', '2023-06-27', null, 60);
	insert into yndev.import_lookup_vs2adhoc values (2811220010,'zb stav s.r.o. (18000)', '281122/0010', '2022-11-28', null, 120.84);
	insert into yndev.import_lookup_vs2adhoc values (812001,'ZO SZV Senica', '011223/0002', '2023-12-01', null, 216);
	
    # select * from yndev.import_lookup_vs2adhoc where vs = 1108220005
    # select vs, count(*) from yndev.import_lookup_vs2adhoc group by vs having count(*) > 1

###### iban_payer to vs
	drop table if exists yndev.import_lookup_ibanpayer2vs;

	create temporary table yndev.import_lookup_ibanpayer2vs as
	select vs,concat(payer_iban,'_',payer_name) as iban_payer
	from yndev.import_raw
	order by 1
    limit 0;


	# from payments with missing vs
	#                                                    vs             iban + _ + name
	insert into yndev.import_lookup_ibanpayer2vs values (2064,'SK7909000000000251455464_Adriana Tothova');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK4511000000002623730578_ART-INVEST, spol. s r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4263,'SK0311000000002943074637_BELLIFER s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4301,'AT083250100000052530_Blanarik Jan');
	insert into yndev.import_lookup_ibanpayer2vs values (3129,'SK8209000000000037187163_Bozena Galova');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK9311000000002936634739_Dikalova Olena');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'CH7504835049814552002_Duscholux AG');
	insert into yndev.import_lookup_ibanpayer2vs values (9057,'SK6002000000003076784159_Eva Pavelkova');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK4011000000002939351208_Holkovič Peter');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK2311000000008013066785_Holkovičová Katarína, Mgr.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK8911000000002932475742_Holkovičová Katarína, Mgr.');
	insert into yndev.import_lookup_ibanpayer2vs values (4106,'SK2009000000000252615482_Ján Havel');
	insert into yndev.import_lookup_ibanpayer2vs values (13096,'SK2302000000001825858954_Jan Valla');
	insert into yndev.import_lookup_ibanpayer2vs values (7002,'AT212011182452780000_Jana Labasova');
	insert into yndev.import_lookup_ibanpayer2vs values (10091,'SK1709000000000253660517_Jaroslav Baran');
	insert into yndev.import_lookup_ibanpayer2vs values (2149,'SK5475000000004028522079_KALAY MIROSLAV');
	insert into yndev.import_lookup_ibanpayer2vs values (14030,'SK6711000000002616088134_Krčová Monika');
	insert into yndev.import_lookup_ibanpayer2vs values (4218,'SK7111110000001286695008_KUNKOVA VIERA');
	insert into yndev.import_lookup_ibanpayer2vs values (1159,'SK1011110000001088680112_LUBICA HLADIKOVA');
	insert into yndev.import_lookup_ibanpayer2vs values (1105,'SK0509000000000250203556_Lubica Stefkova');
	insert into yndev.import_lookup_ibanpayer2vs values (9049,'SK9152000000000019077833_MARIANA KARPITOVA');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK1211000000002619890069_Marko Martin, Ing.');
	insert into yndev.import_lookup_ibanpayer2vs values (13002,'SK5109000000000037200428_Marta Sajdikova');
	insert into yndev.import_lookup_ibanpayer2vs values (4098,'CH6180808005000529814_Martin Dzindzik');
	insert into yndev.import_lookup_ibanpayer2vs values (7107,'SK8302000000001783078158_MGR. FRANTISEK JANKOVIC - SINET');
	insert into yndev.import_lookup_ibanpayer2vs values (2143,'SK8109000000000251536520_Michala Michalkova');
	insert into yndev.import_lookup_ibanpayer2vs values (12011,'BE83967019792915_Nikolaos Baxevanis');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK0956000000003232613002_OBEC BORSKY MIKULAS');
	insert into yndev.import_lookup_ibanpayer2vs values (19022,'SK1875000000004007243740_OLAH LADISLAV');
	insert into yndev.import_lookup_ibanpayer2vs values (1063,'SK0365000000000012546959_Perickova Lucia');
	insert into yndev.import_lookup_ibanpayer2vs values (14007,'SK6802000000004456937457_Peter Jarabek');
	insert into yndev.import_lookup_ibanpayer2vs values (13095,'SK1709000000005028030490_Richard Nejeschleba');
	insert into yndev.import_lookup_ibanpayer2vs values (2200,'SK7109000000000252476048_Roman Jurča');
	insert into yndev.import_lookup_ibanpayer2vs values (1148,'SK4602000000002539150853_Roman Nemečkay');
	insert into yndev.import_lookup_ibanpayer2vs values (13002,'SK1711000000008018331568_Sajdikova Marta');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK9002000000001001018151_SLOVENSKY PLYNARENSKY PRIEMYSEL, A.S.');
	insert into yndev.import_lookup_ibanpayer2vs values (10058,'SK4165000000000095650734_Vacula Peter');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK7711000000002946082827_Yellow INTERNET, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1,'SK7711000000002946082827_Yellow INTERNET');

	# from payments with wrong vs
	#                                                    vs             iban + _ + name
	insert into yndev.import_lookup_ibanpayer2vs values (9058, 'SK4402000000002874771956_ADIC SK, S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (4031, 'SK4809000000000252149960_BELLCROFT, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (14035, 'SK1711000000002924875148_BESTSERVIS SK s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (13042, 'SK0909000000000252041925_Blanka Samkova');
	insert into yndev.import_lookup_ibanpayer2vs values (3038, 'SK5109000000000250953314_Božena Kormanová');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK5111000000002948142993_BRIGHT INVESTMENT GROUP s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (2128, 'SK3811000000002621811171_BUPE s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4236, 'SK8509000000005037019226_BYTSERVIS SENICA s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4092, 'SK9211000000002623811212_ECOMMY, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (9072, 'SK8409000000000037244842_Eduard Rehák - ADIS');
	insert into yndev.import_lookup_ibanpayer2vs values (1161, 'SK4711000000002945080387_EIP s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (9006, 'SK7302000000002527109757_ELMONT - J.M., S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (2207, 'SK1811000000002947092883_ELTEXIM, s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4071, 'SK5909000000005149599640_ENLIT spol. s r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (7047, 'SK8611000000002613088067_Fagan Marián');
	insert into yndev.import_lookup_ibanpayer2vs values (4237, 'SK2211000000002621810101_FAUN spol. s r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4237, 'SK2211000000002621810101_FAUN spol.s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK3981805002408028153400_Financne riaditelstvo Slovenskej republiky');
	insert into yndev.import_lookup_ibanpayer2vs values (4048, 'SK7656000000009237319002_HEILING, SPOL.S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (13138, 'SK9609000000005176575935_Hummer SK s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (3115, 'SK6809000000000037252308_Ing. Jozef NOVAK');
	insert into yndev.import_lookup_ibanpayer2vs values (9007, 'SK4256000000009229227001_IVACEK PAVOL');
	insert into yndev.import_lookup_ibanpayer2vs values (2211, 'SK0611000000002625845686_Ivana Hanzalíková');
	insert into yndev.import_lookup_ibanpayer2vs values (4268, 'SK2411110000001021286006_J + R partners 1');
	insert into yndev.import_lookup_ibanpayer2vs values (4268, 'SK0211110000001021286014_J + R partners 1');
	insert into yndev.import_lookup_ibanpayer2vs values (4144, 'SK9409000000000037036306_Klara Chropuvkova');
	insert into yndev.import_lookup_ibanpayer2vs values (4219, 'SK4009000000000037003037_Lubomira Patkova');
	insert into yndev.import_lookup_ibanpayer2vs values (1118, 'SK1102000000002487050358_LUCIA JANKOVICOVA - EUROLINE');
	insert into yndev.import_lookup_ibanpayer2vs values (4215, 'SK2602000000003445049054_M3 PARTNERS S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (14017, 'SK7875000000004025223356_MACEK ANDREJ');
	insert into yndev.import_lookup_ibanpayer2vs values (13106, 'SK5765000000000092575740_Macek Rastislav');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK8211000000002621810670_Matomi, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (1164, 'SK2902000000002620456753_Metalia, a.s.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK1102000000001804836457_MGR. LUDOVIT ZELISKA - EXEKUTORSKY');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK1602000000001385411859_MGR. LUDOVIT ZELISKA - EXEKUTORSKY URAD');
	insert into yndev.import_lookup_ibanpayer2vs values (4283, 'SK5311000000002945052343_MOOVE s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (13137, 'SK2811000000002941026711_MŰLLER INŠTAL spol. s r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (10050, 'SK4502000000003691931851_MVDr. Lujza Hromková');
	insert into yndev.import_lookup_ibanpayer2vs values (2076, 'SK9711000000008013294470_Novomesky Marek');
	insert into yndev.import_lookup_ibanpayer2vs values (1166, 'SK2511000000002944087018_OMS Intelligence');
	insert into yndev.import_lookup_ibanpayer2vs values (1166, 'SK2511000000002944087018_OMS Intelligence Solutions, s. r. o');
	insert into yndev.import_lookup_ibanpayer2vs values (4030, 'SK0609000000000037255752_Pavol Dobias - DD Autotechna');
	insert into yndev.import_lookup_ibanpayer2vs values (13102, 'SK5511000000002936609330_Plevakova Jana');
	insert into yndev.import_lookup_ibanpayer2vs values (1170, 'SK4711000000002621810136_Poľnohospodárske družstvo Dojč');
	insert into yndev.import_lookup_ibanpayer2vs values (10098, 'SK6811000000002933577943_Poništ Matúš');
	insert into yndev.import_lookup_ibanpayer2vs values (3108, 'SK7102000000002389658853_PS METAL, S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (4273, 'SK6975000000004012846124_R&M GROUP S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (19035, 'SK4511110000001301694004_R-MONT RYSAVY');
	insert into yndev.import_lookup_ibanpayer2vs values (3439, 'SK4311110000001692327008_RAMPAZZO SLOVAKIA');
	insert into yndev.import_lookup_ibanpayer2vs values (1167, 'SK0809000000000251928356_Rastislav Jankovic - CONTILINE');
	insert into yndev.import_lookup_ibanpayer2vs values (4183, 'SK1511000000002620811321_RECO, S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (4281, 'SK6875000000004028048661_SAL SERVIS, S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK6902000020140015805012_SLOVENSKA POSTA, A.S.');
	insert into yndev.import_lookup_ibanpayer2vs values (3406, 'SK3711000000002925849347_STAVCENTRUM A-Z');
	insert into yndev.import_lookup_ibanpayer2vs values (3387, 'SK9602000000004668050954_Timotej Stanicky');
	insert into yndev.import_lookup_ibanpayer2vs values (4212, 'SK4311000000002944000170_upvision. s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4192, 'SK5365000000003650665016_Vaskova Andrea');
	insert into yndev.import_lookup_ibanpayer2vs values (4192, 'SK6311000000008010310586_Vašková Helena');
	insert into yndev.import_lookup_ibanpayer2vs values (13104, 'SK8711000000002933663155_Wolfová Sophia');
	insert into yndev.import_lookup_ibanpayer2vs values (12029, 'SK0309000000000635246450_YANCORP, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK0702000000002278166653_YellowNET, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK4702000000003028657358_YellowNET, s.r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK0702000000002278166653_YELLOWNET,S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (-1, 'SK4702000000003028657358_YELLOWNET,S.R.O.');
	insert into yndev.import_lookup_ibanpayer2vs values (2183, 'SK8302000000003265012051_Zuzana Oravcova');
	insert into yndev.import_lookup_ibanpayer2vs values (13056, 'SK8902000000003996136154_Zuzana Vašková');

	#select iban_payer, count(*) cnt from yndev.import_lookup_ibanpayer2vs group by iban_payer having cnt > 1;

###### replace vs

	drop table if exists yndev.import_lookup_pv2vs;
    
    create temporary table yndev.import_lookup_pv2vs as
    select payer_name, vs, vs as vs_new
    from yndev.import_raw
    limit 0;
    
    insert into yndev.import_lookup_pv2vs values ('Čech Jozef', 4149, 4194);
    
###### consolidation
	drop table if exists yndev.import_consolidated;

	create table yndev.import_consolidated as

	select 
		r.id
		,r.payment_index
		,r.payment_date
		,r.is_credit
		,r.amount
		,coalesce(
			case vs2a.vs when 0 then null else vs2a.vs end, # ignored due to adhoc invoice reference
            case ip2v.vs when 0 then null else ip2v.vs end, # ignored due to blacklisted payer
            case pv2v.vs_new when 0 then null else pv2v.vs_new end, # manually corrected typo
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0) as vs
		,r.ss
        ,r.origin
		,r.payer_iban
        ,coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) as payer_name
		,r.detail
		,r.payment_id
		,r.bank_ref
		,r.payer_ref
        ,coalesce(z.id, case ip2v.vs when -1 then -1 end, case when vs2a.invoice_id is not null then -1 end) as customer_Id
        ,r.vs as vs_orig
        ,p2v.vs as vs_from_payer
        ,pv2v.vs_new as vs_from_typo
        ,ip2v.vs as vs_from_iban_payer
        ,vs2a.vs as vs_from_adhoc_invoice
	from yndev.import_raw as r
    left join yndev.import_lookup_iban2payer as i2p on r.payer_iban = i2p.payer_iban
    left join yndev.import_lookup_payer2vs as p2v on i2p.payer_name = p2v.payer_name
    left join yndev.import_lookup_ibanpayer2vs as ip2v on ip2v.iban_payer = concat(r.payer_iban, '_', coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name))
    left join yndev.import_lookup_pv2vs as pv2v on pv2v.vs = r.vs and pv2v.payer_name = coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name)
    left join yndev.import_lookup_vs2adhoc as vs2a on coalesce(vs2a.amount_id, r.amount) = r.amount and vs2a.vs = coalesce(
			case pv2v.vs_new when 0 then null else pv2v.vs_new end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0)
	left join zakaznici as z on z.zmluva = coalesce(
			case when vs2a.invoice_id is not null then -1 else null end, # this will not join customers with payments where vs is pointing to existing adhoc invoices
            case ip2v.vs when 0 then null else ip2v.vs end,
			case pv2v.vs_new when 0 then null else pv2v.vs_new end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0)
	where is_credit = 1 #and coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) like '%kapsa%'
order by payer_name, payment_date
	;

	# payments with missing vs after consolidated
	select * 
    from yndev.import_consolidated 
    where vs = 0 or customer_id is null and is_credit = 1 
    order by payer_name, payment_date;

	# payments with ignored customer_id after consolidated
	select * 
    from yndev.import_consolidated 
    where customer_id = -1 and is_credit = 1 
    order by payer_name, payment_date;

	# payments with missing vs or missing customer after consolidation
	select ic.payer_iban, ic.payer_name, ic.amount, ic.vs
    ,concat('insert into yndev.import_lookup_ibanpayer2vs values (-1, ''', coalesce(ic.payer_iban, ''), '_', trim(ic.payer_name), ''');') as insert_statement
    from yndev.import_consolidated ic
    where (ic.vs = 0 or ic.customer_id is null) and ic.is_credit = 1 
    group by ic.payer_iban, ic.payer_name
    order by 2;

/*

select id,count(*) from yndev.import_consolidated group by id having count(*) > 1 order by 2 desc;
select id,count(*) from yndev.import_raw group by id having count(*) > 1 order by 2 desc;
select * from yndev.import_consolidated where id in (1681,2214);

	select *
	from yndev.import_raw as r
    left join yndev.import_lookup_iban2payer as i2p on r.payer_iban = i2p.payer_iban
    left join yndev.import_lookup_payer2vs as p2v on i2p.payer_name = p2v.payer_name
    left join yndev.import_lookup_ibanpayer2vs as ip2v on ip2v.iban_payer = concat(r.payer_iban, '_', coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name))
    left join yndev.import_lookup_vs2adhoc as vs2a on vs2a.vs = coalesce(
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0)
	left join zakaznici as z on z.zmluva = coalesce(
			case when vs2a.invoice_id is not null then -1 else null end, # this will not join customers with payments where vs is pointing to existing adhoc invoices
            case ip2v.vs when 0 then null else ip2v.vs end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0)
	where is_credit = 1 and r.id = 1681 #coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) like '%kapsa%'
    order by r.payer_name, r.id
;

select * from yndev.platby_new where datum_platby = '2022-01-10' and sender like '%matomi%';
select * from yndev.import_raw left join zakaznici on zmluva = vs where payment_date = '2022-01-10' and payer_name like '%matomi%';
select ic.*, z.id customer_id, z.meno from yndev.import_consolidated as ic left join zakaznici as z on zmluva = vs where payment_date = '2022-01-05' and amount = 10;

select * from zakaznici where zmluva = 4194;
select * from zakaznici where id = 1083;
select * from yndev.faktury_source where id_zak = 964;

select * from yndev.uhrady_new where id_zak = 964;
*/
