

# select * from zakaznici where id = 105;

############ UNIT TESTING - simulate various scenarios

truncate table yndev.faktury_source;

insert into yndev.faktury_source values 

##### customer #100 with 5 uninterrupted invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
 ('100',	'100',		'z100f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('101',	'100',		'z100f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('102',	'100',		'z100f03',	'20250301',	'20250315',	'10.00',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')
,('103',	'100',		'z100f04',	'20250401',	'20250415',	'10.00',	'10.00',	'62',		'20250431',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'4')
,('104',	'100',		'z100f05',	'20250501',	'20250515',	'10.00',	'10.00',	'62',		'20250531',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'5')

##### customer #101 with 5 interrupted and mixed invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('110',	'101',		'z101f01',	'20250101',	'20250115',	'09.95',	'09.95',	'62',		'20250131',		'0.00',		'09.95',		'V',	'0.00',		'09.95',		'0',		'1')
,('111',	'101',		'z101f02',	'20250201',	'20250215',	'09.95',	'09.95',	'62',		'20250231',		'0.00',		'09.95',		'V',	'0.00',		'09.95',		'0',		'2')
,('112',	'101',		'z101f03',	'20250501',	'20250515',	'19.95',	'19.95',	'62',		'20250531',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'3')
,('113',	'101',		'z101f04',	'20250701',	'20250715',	'19.95',	'19.95',	'62',		'20250731',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'4')
,('114',	'101',		'z101f05',	'20250901',	'20250915',	'19.95',	'19.95',	'62',		'20250931',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'5')

##### customer #102 with 5 interrupted and mixed
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('120',	'102',		'z102f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('121',	'102',		'z102f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('122',	'102',		'z102f03',	'20250501',	'20250515',	'12.00',	'12.00',	'62',		'20250531',		'0.00',		'12.00',		'V',	'0.00',		'12.00',		'0',		'3')
,('123',	'102',		'z102f04',	'20250601',	'20250615',	'13.00',	'13.00',	'62',		'20250631',		'0.00',		'13.00',		'V',	'0.00',		'13.00',		'0',		'4')
,('124',	'102',		'z102f05',	'20251201',	'20251215',	'14.00',	'14.00',	'62',		'20251231',		'0.00',		'14.00',		'V',	'0.00',		'14.00',		'0',		'5')

##### customer #103 with 5 simple invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('130',	'103',		'z103f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('131',	'103',		'z103f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('132',	'103',		'z103f03',	'20250301',	'20250315',	'10.00',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')
,('133',	'103',		'z103f04',	'20250401',	'20250415',	'10.00',	'10.00',	'62',		'20250431',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'4')
,('134',	'103',		'z103f05',	'20250501',	'20250515',	'10.00',	'10.00',	'62',		'20250531',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'5')

##### customer #104 with 5 interrupted and mixed
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('140',	'104',		'z104f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('141',	'104',		'z104f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('142',	'104',		'z104f03',	'20250501',	'20250515',	'12.00',	'12.00',	'62',		'20250531',		'0.00',		'12.00',		'V',	'0.00',		'12.00',		'0',		'3')
,('143',	'104',		'z104f04',	'20250601',	'20250615',	'13.00',	'13.00',	'62',		'20250631',		'0.00',		'13.00',		'V',	'0.00',		'13.00',		'0',		'4')
,('144',	'104',		'z104f05',	'20251201',	'20251215',	'14.00',	'14.00',	'62',		'20251231',		'0.00',		'14.00',		'V',	'0.00',		'14.00',		'0',		'5')

##### customer #105 with 5 uninterrupted invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('150',	'105',		'z105f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('151',	'105',		'z105f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('152',	'105',		'z105f03',	'20250301',	'20250315',	'10.00',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')
,('153',	'105',		'z105f04',	'20250401',	'20250415',	'10.00',	'10.00',	'62',		'20250431',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'4')
,('154',	'105',		'z105f05',	'20250501',	'20250515',	'10.00',	'10.00',	'62',		'20250531',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'5')

##### customer #106 with 3 uninterrupted invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('160',	'106',		'z106f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('161',	'106',		'z106f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('162',	'106',		'z106f03',	'20250301',	'20250315',	'10.00',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')

##### customer #107 with 3 uninterrupted invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma_old,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('170',	'107',		'z107f01',	'20250101',	'20250115',	'10.00',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('171',	'107',		'z107f02',	'20250201',	'20250215',	'10.00',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('172',	'107',		'z107f03',	'20250301',	'20250315',	'10.00',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')

;

/*

select * from yndev.faktury_source;

*/


truncate table yndev.platby_source;

insert into yndev.platby_source values 

#### customer #100 with 5 payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
 ('400',	'100',			'10.00',	'10.00',	'1011',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('401',	'100',			'10.00',	'10.00',	'1011',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('402',	'100',			'10.00',	'10.00',	'1011',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('403',	'100',			'10.00',	'10.00',	'1011',	'0',	'2025-04-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('404',	'100',			'10.00',	'10.00',	'1011',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #101 with 5 interrupted and mixed payments with delay
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('410',	'101',			'09.95',	'09.95',	'1003',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('411',	'101',			'09.95',	'09.95',	'1003',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('412',	'101',			'19.95',	'19.95',	'1003',	'0',	'2025-11-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('413',	'101',			'19.95',	'19.95',	'1003',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('414',	'101',			'19.95',	'19.95',	'1003',	'0',	'2025-12-23',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #102 with 5 interrupted but insufficient payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('420',	'102',			'10.00',	'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('421',	'102',			'10.00',	'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('422',	'102',			'10.00',	'10.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('423',	'102',			'10.00',	'10.00',	'9999',	'0',	'2025-06-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('424',	'102',			'10.00',	'10.00',	'9999',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #103 with 3 delayed and insufficient payments and 1 delayed but sufficient payment
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('430',	'103',			'04.50',	'04.50',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('431',	'103',			'04.50',	'04.50',	'9999',	'0',	'2025-01-05',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('432',	'103',			'20.35',	'20.35',	'9999',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('433',	'103',			'20.65',	'20.65',	'9999',	'0',	'2025-09-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')

#### customer #102 with 5 interrupted but more than sufficient payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('440',	'104',			'10.00',	'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('441',	'104',			'10.00',	'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('442',	'104',			'10.00',	'10.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('443',	'104',			'10.00',	'10.00',	'9999',	'0',	'2025-06-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('444',	'104',			'23.00',	'23.00',	'9999',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #105 with 3 payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('450',	'105',			'10.00',	'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('451',	'105',			'10.00',	'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('452',	'105',			'10.00',	'10.00',	'9999',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')

#### customer #106 with 5 payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('460',	'106',			'10.00',	'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('461',	'106',			'10.00',	'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('462',	'106',			'10.00',	'10.00',	'9999',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('463',	'106',			'10.00',	'10.00',	'9999',	'0',	'2025-04-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('464',	'106',			'10.00',	'10.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #107 with 5 payments on time
# id,		id_customer,	suma,		suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	xyz,	account,	bank,	sender, iban,	step
,('470',	'107',			'10.00',	'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'1')
,('471',	'107',			'10.00',	'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'2')
,('472',	'107',			'20.00',	'20.00',	'9999',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'3')
,('473',	'107',			'20.00',	'20.00',	'9999',	'0',	'2025-04-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'4')
,('474',	'107',			'20.00',	'20.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		'xyz',	NULL,		NULL, 	NULL,	NULL,	'5')

;

/*

select * from yndev.platby_source;

*/

drop table if exists yndev.uhrady_assert;

create temporary table if not exists yndev.uhrady_assert
(
	id_faktura int not null,
    id_platba int not null,
    suma decimal(8,2) not null,
    suma_p decimal(8,2) not null,
    suma_f decimal(8,2) not null,
    datum date not null,
    id_zak int not null,
    balance decimal(8,2) not null,
    step_f int not null,
    step_p int not null,
    primary key (id_faktura, id_platba)
);

truncate table yndev.uhrady_assert;

insert into yndev.uhrady_assert values
##### customer #100 with 5 uninterrupted invoices
##### customer #100 with 5 payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
 (100, 	400, 	10.0, 	10.0, 	10.0, 	'2025-01-03', 	100, 	0.0, 		1, 		1)
,(101, 	401, 	10.0, 	10.0, 	10.0, 	'2025-02-03', 	100, 	0.0, 		2, 		2)
,(102, 	402, 	10.0, 	10.0, 	10.0, 	'2025-03-03', 	100, 	0.0, 		3, 		3)
,(103, 	403, 	10.0, 	10.0, 	10.0, 	'2025-04-03', 	100, 	0.0, 		4, 		4)
,(104, 	404, 	10.0, 	10.0, 	10.0, 	'2025-05-03', 	100, 	0.0, 		5, 		5)

##### customer #101 with 5 interrupted and mixed invoices
##### customer #101 with 5 interrupted and mixed payments with delay
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(110, 	410, 	09.95,	09.95,	09.95,	'2025-01-03', 	101, 	0.0, 		1, 		1)
,(111, 	411, 	09.95,	09.95,	09.95,	'2025-02-03', 	101, 	0.0, 		2, 		2)
,(112, 	412, 	19.95,	19.95,	19.95,	'2025-11-03', 	101, 	0.0, 		3, 		3)
,(113, 	413, 	19.95,	19.95,	19.95,	'2025-12-03', 	101, 	0.0, 		4, 		4)
,(114, 	414, 	19.95,	19.95,	19.95,	'2025-12-23', 	101, 	0.0, 		5, 		5)

##### customer #102 with 5 interrupted and mixed
#### customer #102 with 5 interrupted but insufficient payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(120, 	420, 	10.00,	10.00,	10.00,	'2025-01-03', 	102, 	0.0, 		1, 		1)
,(121, 	421, 	10.00,	10.00,	10.00,	'2025-02-03', 	102, 	0.0, 		2, 		2)
,(122, 	422, 	10.00,	10.00,	12.00,	'2025-05-03', 	102, 	-2.0,		3, 		3)
,(122, 	423, 	02.00,	10.00,	12.00,	'2025-06-03', 	102, 	8.0,		3, 		4)
,(123, 	423, 	08.00,	10.00,	13.00,	'2025-06-03', 	102, 	-5.0,		4, 		4)
,(123, 	424, 	05.00,	10.00,	13.00,	'2025-12-03', 	102, 	5.0,		4, 		5)
,(124, 	424, 	05.00,	10.00,	14.00,	'2025-12-03', 	102, 	-9.0,		5, 		5)

##### customer #103 with 5 simple invoices
#### customer #103 with 3 delayed and insufficient payments and 1 delayed but sufficient payment
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(130, 	430, 	04.50,	04.50,	10.00,	'2025-01-03', 	103, 	-5.5, 		1, 		1)
,(130, 	431, 	04.50,	04.50,	10.00,	'2025-01-05', 	103, 	-1.0, 		1, 		2)
,(130, 	432, 	01.00,	20.35,	10.00,	'2025-03-03', 	103, 	19.35, 		1, 		3)
,(131, 	432, 	10.00,	20.35,	10.00,	'2025-03-03', 	103, 	9.35, 		2, 		3)
,(132, 	432, 	09.35,	20.35,	10.00,	'2025-03-03', 	103, 	-0.65, 		3, 		3)
,(132, 	433, 	00.65,	20.65,	10.00,	'2025-09-03', 	103, 	20.00, 		3, 		4)
,(133, 	433, 	10.00,	20.65,	10.00,	'2025-09-03', 	103, 	10.00, 		4, 		4)
,(134, 	433, 	10.00,	20.65,	10.00,	'2025-09-03', 	103, 	0.00, 		5, 		4)

##### customer #104 with 5 interrupted and mixed
#### customer #104 with 5 interrupted but more than sufficient payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(140, 	440, 	10.00,	10.00,	10.00,	'2025-01-03', 	104, 	0.0, 		1, 		1)
,(141, 	441, 	10.00,	10.00,	10.00,	'2025-02-03', 	104, 	0.0, 		2, 		2)
,(142, 	442, 	10.00,	10.00,	12.00,	'2025-05-03', 	104, 	-2.0,		3, 		3)
,(142, 	443, 	02.00,	10.00,	12.00,	'2025-06-03', 	104, 	8.0,		3, 		4)
,(143, 	443, 	08.00,	10.00,	13.00,	'2025-06-03', 	104, 	-5.0,		4, 		4)
,(143, 	444, 	05.00,	23.00,	13.00,	'2025-12-03', 	104, 	18.0,		4, 		5)
,(144, 	444, 	14.00,	23.00,	14.00,	'2025-12-03', 	104, 	4.0,		5, 		5)

##### customer #105 with 5 uninterrupted invoices
##### customer #105 with 3 payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(150, 	450, 	10.0, 	10.0, 	10.0, 	'2025-01-03', 	105, 	0.0, 		1, 		1)
,(151, 	451, 	10.0, 	10.0, 	10.0, 	'2025-02-03', 	105, 	0.0, 		2, 		2)
,(152, 	452, 	10.0, 	10.0, 	10.0, 	'2025-03-03', 	105, 	0.0, 		3, 		3)
,(153, 	-1, 	00.0, 	00.0, 	10.0, 	'1900-01-01',	105, 	-10.0, 		4, 		4)
,(154, 	-1, 	00.0, 	00.0, 	10.0, 	'1900-01-01',	105, 	-20.0, 		5, 		5)

##### customer #106 with 3 uninterrupted invoices
##### customer #106 with 5 payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(160, 	460, 	10.0, 	10.0, 	10.0, 	'2025-01-03', 	106, 	0.0, 		1, 		1)
,(161, 	461, 	10.0, 	10.0, 	10.0, 	'2025-02-03', 	106, 	0.0, 		2, 		2)
,(162, 	462, 	10.0, 	10.0, 	10.0, 	'2025-03-03', 	106, 	0.0, 		3, 		3)
,(-1, 	463,	10.0, 	10.0, 	0.0, 	'2025-04-03',	106, 	10.0, 		4, 		4)
,(-1, 	464,	10.0, 	10.0, 	0.0, 	'2025-05-03',	106, 	20.0, 		5, 		5)

##### customer #107 with 3 uninterrupted invoices
##### customer #107 with 1 correct and 4 larger payments on time
#id_f, 	id_p,	suma,	suma_p,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(170, 	470, 	10.0, 	10.0, 	10.0, 	'2025-01-03', 	107, 	0.0, 		1, 		1)
,(171, 	471, 	10.0, 	10.0, 	10.0, 	'2025-02-03', 	107, 	0.0, 		2, 		2)
,(172, 	472, 	10.0, 	20.0, 	10.0, 	'2025-03-03', 	107, 	10.0, 		3, 		3)
,(-1, 	473,	20.0, 	20.0, 	0.0, 	'2025-04-03',	107, 	30.0, 		4, 		4)
,(-1, 	474,	20.0, 	20.0, 	0.0, 	'2025-05-03',	107, 	50.0, 		5, 		5)

;

/*

select * from yndev.uhrady_assert;

*/
