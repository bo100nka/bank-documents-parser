select * from yndev.import_consolidated;



select payer_name_filled, vs, count(*)
from yndev.import_consolidated
where is_credit = 1 and vs < 100
group by payer_name_filled, vs
order by 1,2;

### payers with every payment has missing vs
select payer_name_filled, 
	count(*) as payments_total, 
    sum(case vs when 0 then 1 else 0 end) as payments_missing_vs,
    sum(case vs_filled when 0 then 1 else 0 end) as payments_missing_vsfilled
from yndev.import_consolidated
where is_credit = 1
group by payer_name_filled
having payments_missing_vsfilled = payments_total
order by 1
;

### payers with some missing vs
select payer_name_filled, 
	count(*) as payments_total, 
    sum(case vs when 0 then 1 else 0 end) as payments_missing_vs,
    sum(case vs_filled when 0 then 1 else 0 end) as payments_missing_vsfilled
from yndev.import_consolidated
where is_credit = 1
group by payer_name_filled
having payments_missing_vs between 1 and (payments_total - 1)
order by 1
;

select * from yndev.import_consolidated where vs = 0 and vs_filled != 0 and is_credit = 1;
select distinct payer_iban, payer_name_filled, 999999 as vs_missing from yndev.import_consolidated where vs = 0 and vs_filled = 0 and is_credit = 1 order by 1,2;

select * from zakaznici where meno like '%KARPITOVA%';
/*
# id	meno	c_op	ulica	obec	psc	stat	vyrocny_den	ico	dic	icdph	zmluva	email	telefon	poznamka	zasielanie_faktur	sposob_platby	je_platca_dph	use_koresp	koresp_meno	koresp_ulica	koresp_obec	koresp_psc	koresp_stat	install_ulica	install_obec	install_psc	install_vchod_poschodie	upomienky	tv_id
728	Karpitová Mariana	ER673584	Rovensko 164	Rovensko	90501	SK	1	0			9049	palcik@azet.sk	0948203919		1	banka	0	0						Rovensko 164	Rovensko	90501		0	
*/

select * from yndev.import_consolidated where payer_name_filled = 'MARIANA KARPITOVA';
/*
# id	payment_index	payment_date	is_credit	amount	vs	vs_filled	origin	payer_iban	payer_name	payer_name_filled	detail	payment_id	bank_ref	payer_ref
318	16	2022-01-11	1	10.00	0	0	export_SK0702000000002278166653_11-01-2022-11-01-2022.XML	SK9152000000000019077833	MARIANA KARPITOVA	MARIANA KARPITOVA	yelounet	4922398753	OTP0000000019	NOTPROVIDED
*/

select * from platby 
where 1=1 
and vs = 9049
#and popis like '%karpitova%'
limit 10;
/*
# id	id_customer	suma	vs	ss	datum_platby	zdroj	file	day_index	popis	account	bank	sender	iban
29795	728	5.00	9049	0	2016-12-15	banka	20161215.txt	12	MARIANA KARPITOVÁ
22904	728	5.00	9049	10115661	2016-01-09	posta	st1wd3kv.012	1	MARIANA           KARPITOVA         ROVENSKO ROVENSKO                  164         90501				
*/

select payer_name_filled, max(vs) as vs
from yndev.import_consolidated a
where payer_name_filled is not null
group by payer_name_filled
order by 1
;

select b.*, a.* from yndev.import_consolidated as a
left join yndev.import_lookup_payer2vs as b on b.payer_name = a.payer_name_filled
where a.vs = 0
;


select count(*) from yndev.import_consolidated where vs_filled = 0 and is_credit = 1;

select * from yndev.import_consolidated where payer_name_filled = 'masaryk';


select count(*) from yndev.import_consolidated left join zakaznici on zmluva = vs where zakaznici.id is not null;
select count(*) from yndev.import_consolidated left join zakaznici on zmluva = vs_filled where zakaznici.id is not null;
select count(*) from yndev.import_consolidated where vs_filled = 0;
select count(*) from yndev.import_consolidated where vs_manual != 0;

select * from yndev.import_consolidated where vs_filled <= 0 order by payer_name,payer_iban,origin;

select meno, zmluva from yellownet.zakaznici where meno like '%vacula%';
select * from zakaznici where id = 140823;
select * from zakaznici where obec = 'kunov' or install_obec = 'kunov';
select * from zakaznici where zmluva = 2024;

select zmluva, f.*, z.* from faktury f join zakaznici z on z.id = id_zak where zmluva = 2024;
select sum(amount) from yndev.import_consolidated where vs = 2024 order by payment_date;
select * from faktury left join zakaznici z on z.id = id_zak where d_fakt > 202000 and suma > 1000;
select sum(suma) from platby p where p.vs = 2024 and datum_platby < '2022-01-01' order by datum_platby;

select zmluva, p.* from platby p left join zakaznici z on id_customer = z.id 
where iban = 'SK2465000000000002516684' or account like '2516684' 
	or sender like '%plyn%' 
	or popis like '%plyn%' 
order by datum_platby;

select * from faktury left join zakaznici z on z.id = id_zak where d_fakt = 20220212 and suma = 25;

## 2007-04-01 - 31.12.2021 zaplatila 1040.02 eur
## 01.01.2022 - 31.12.2023 zaplatila 450.60 eur
## spolu 1490.62 eur
## od 2007-04-01 je to 200 mesiacov x faktura za 13.30 eur = 2660 eur
## dlzna 1169.38 eur



select * from platby p where p.datum_platby = '2022-01-03';
/* id	id_customer	suma	vs	ss	datum_platby	zdroj	file	day_index	popis	account	bank	sender	iban
84921	101	6.61	1003	0	2022-01-03	banka	export_SK0702000000002278166653_03-01-2022-03-01-2022.TXT	7	INTERNET	0000002915968836	1100
*/

select datum_platby, count(*) from platby p where p.datum_platby between '2022-01-01' and '2022-04-26' group by datum_platby order by 1;
select datum_platby, count(*) from yndev.platby_new p where p.datum_platby between '2022-01-01' and '2022-04-26' group by datum_platby order by 1;


select z.id, z.zmluva, z.meno, z.install_obec, p.datum_platby, p.suma, u.suma as uhrada, f.cislo, f.d_fakt, f.suma as faktura, f.stav
from platby as p
left join zakaznici as z on z.id = p.id_customer
left join uhrady as u on u.id_platba = p.id
left join faktury as f on u.id_faktura = f.id
where p.datum_platby between '2022-01-03' and '2022-01-31'
	and u.id is null
;


select * from uhrady limit 10;


select f.cislo, f.d_fakt, f.suma, count(*) as payments
from uhrady as u
left join faktury as f on f.id = u.id_faktura
where f.d_fakt > '20220000'
group by u.id_faktura, f.d_fakt, f.suma
order by 4 desc;


select f.cislo, f.d_fakt, f.suma, u.suma
from uhrady as u
left join faktury as f on f.id = u.id_faktura
where f.d_fakt > '20220000'
order by 1 desc;

select f.stav, uhradena, count(*)
from faktury f
group by f.stav, f.uhradena
order by 1;
/*
stav uhradena count
0	0	145
1	0	45718
T	0	17339
V	0	34085
*/

select *
from faktury
where stav = 'v'
order by d_fakt desc;
#?????????????


select z.id, z.zmluva, z.meno, z.install_obec, p.datum_platby, p.suma, u.suma as uhrada, f.cislo, f.d_fakt, f.suma as faktura, f.stav
from platby as p
left join zakaznici as z on z.id = p.id_customer
left join uhrady as u on u.id_platba = p.id
left join faktury as f on u.id_faktura = f.id
where p.datum_platby between '2022-01-03' and '2022-01-31'
	and u.id is null
;


# 2008-12-31 = skk
# 2009-01-01 = eur
select concat(year(d_fakt), month(d_fakt)) as ym, min(f.cena_sluzby) from faktury f group by ym order by 1 asc;

select 
	DATE_FORMAT(f.d_fakt, "%Y-%M") as period
    ,sum(case when u.id is null then 1 else 0 end) as invoices_unpaid
    ,sum(case when u.id is null then 0 else 1 end) as invoices_paid
from faktury f
left join uhrady u on u.id_faktura = f.id
where d_fakt > '20230000'
group by DATE_FORMAT(f.d_fakt, "%Y-%m")
order by f.d_fakt
;



drop table if exists zak_min_fakt;

create temporary table zak_min_fakt as
select z.id, z.zmluva, min(d_fakt) min_d_fakt, count(*) cnt
from faktury f
left join zakaznici z on z.id = f.id_zak
group by z.id, z.zmluva
having min_d_fakt > '20220100';

select * from zak_min_fakt order by cnt asc;

/* example customer id multiple invoices where:
- all paid invoices: 
- all unpaid invoices: 1646
- some unpaid invoices: 1587
*/

select *
	,row_number() over(partition by f.id_zak) as step
from faktury f
#left join uhrady u on u.id_faktura = f.id
#left join platby p on p.id = u.id_platba
left join zak_min_fakt zm on zm.id = f.id_zak
where 
	zm.id is not null and 
    #p.id is not null and
    1=1 and f.id_zak = 1635;

############ assign steps to invoices

drop table if exists yndev.faktury_steps;
create temporary table yndev.faktury_steps as
select f.id_zak, f.d_fakt, f.id, f.cislo, row_number() over(partition by f.id_zak) as step
from faktury f
where f.d_fakt >= '20220000' 
#and f.id_zak in (1635,1647)
order by f.id_zak, f.d_fakt, step;

#select * from yndev.faktury_steps;

############ assign steps to payments

drop table if exists yndev.platby_steps;
create temporary table yndev.platby_steps as
select p.vs, p.datum_platby, p.id, row_number() over(partition by p.vs) as step
from yndev.platby_new p
where p.datum_platby >= '2022-01-01' and p.vs != 0 
#and p.id_customer in (1635,1647)
order by p.vs, p.datum_platby, step;

#select * from yndev.platby_steps;












############ create steps table

drop table if exists yndev.customer_steps;

create table yndev.customer_steps
(
	id_zak int primary key,
    step_f int not null,
    step_p int not null,
    saldo decimal(8,2) not null
);

############ create temp of invoices

drop table if exists yndev.faktury_source;
create temporary table yndev.faktury_source as
select *,row_number() over(partition by id_zak) as step from faktury where d_fakt > '20220000';

############ create temp of payments

drop table if exists yndev.platby_source;
create temporary table yndev.platby_source as
select *,row_number() over(partition by vs) as step from yndev.platby_new where vs != 0 and datum_platby >= '2022-01-01';

############ create extended invoice_payments

drop table if exists yndev.uhrady_new;

create table yndev.uhrady_new like uhrady;
alter table yndev.uhrady_new add suma_f decimal(10,2);
alter table yndev.uhrady_new add datum date;
alter table yndev.uhrady_new add id_zak int;
alter table yndev.uhrady_new add balance decimal(10,2);
alter table yndev.uhrady_new add step_f int;
alter table yndev.uhrady_new add step_p int;

############ TODO: simulate various scenarios

truncate table yndev.faktury_source;

select * from faktury order by d_fakt desc limit 1;
insert into yndev.faktury_source values 

##### customer #100 with 5 uninterrupted invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
 ('100',	'100',		'z100f01',	'20250101',	'20250115',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('101',	'100',		'z100f02',	'20250201',	'20250215',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('102',	'100',		'z100f03',	'20250301',	'20250315',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')
,('103',	'100',		'z100f04',	'20250401',	'20250415',	'10.00',	'62',		'20250431',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'4')
,('104',	'100',		'z100f05',	'20250501',	'20250515',	'10.00',	'62',		'20250531',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'5')

##### customer #101 with 5 interrupted and mixed invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('110',	'101',		'z101f01',	'20250101',	'20250115',	'09.95',	'62',		'20250131',		'0.00',		'09.95',		'V',	'0.00',		'09.95',		'0',		'1')
,('111',	'101',		'z101f02',	'20250201',	'20250215',	'09.95',	'62',		'20250231',		'0.00',		'09.95',		'V',	'0.00',		'09.95',		'0',		'2')
,('112',	'101',		'z101f03',	'20250501',	'20250515',	'19.95',	'62',		'20250531',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'3')
,('113',	'101',		'z101f04',	'20250701',	'20250715',	'19.95',	'62',		'20250731',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'4')
,('114',	'101',		'z101f05',	'20250901',	'20250915',	'19.95',	'62',		'20250931',		'0.00',		'19.95',		'V',	'0.00',		'19.95',		'0',		'5')

##### customer #102 with 5 interrupted and mixed
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('120',	'102',		'z102f01',	'20250101',	'20250115',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('121',	'102',		'z102f02',	'20250201',	'20250215',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('122',	'102',		'z102f03',	'20250501',	'20250515',	'12.00',	'62',		'20250531',		'0.00',		'12.00',		'V',	'0.00',		'12.00',		'0',		'3')
,('123',	'102',		'z102f04',	'20250601',	'20250615',	'13.00',	'62',		'20250631',		'0.00',		'13.00',		'V',	'0.00',		'13.00',		'0',		'4')
,('124',	'102',		'z102f05',	'20251201',	'20251215',	'14.00',	'62',		'20251231',		'0.00',		'14.00',		'V',	'0.00',		'14.00',		'0',		'5')

##### customer #103 with 5 simple invoices
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('130',	'103',		'z103f01',	'20250101',	'20250115',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('131',	'103',		'z103f02',	'20250201',	'20250215',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('132',	'103',		'z103f03',	'20250301',	'20250315',	'10.00',	'62',		'20250331',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'3')
,('133',	'103',		'z103f04',	'20250401',	'20250415',	'10.00',	'62',		'20250431',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'4')
,('134',	'103',		'z103f05',	'20250501',	'20250515',	'10.00',	'62',		'20250531',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'5')

##### customer #104 with 5 interrupted and mixed
# id, 		id_zak,		cislo,		d_fakt,		d_splat,	suma,		id_sluzby,	d_platne_do,	zlava,		cena_sluzby,	stav,	dph,		cena_bez_dph,	uhradena,	step
,('140',	'104',		'z104f01',	'20250101',	'20250115',	'10.00',	'62',		'20250131',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'1')
,('141',	'104',		'z104f02',	'20250201',	'20250215',	'10.00',	'62',		'20250231',		'0.00',		'10.00',		'V',	'0.00',		'10.00',		'0',		'2')
,('142',	'104',		'z104f03',	'20250501',	'20250515',	'12.00',	'62',		'20250531',		'0.00',		'12.00',		'V',	'0.00',		'12.00',		'0',		'3')
,('143',	'104',		'z104f04',	'20250601',	'20250615',	'13.00',	'62',		'20250631',		'0.00',		'13.00',		'V',	'0.00',		'13.00',		'0',		'4')
,('144',	'104',		'z104f05',	'20251201',	'20251215',	'14.00',	'62',		'20251231',		'0.00',		'14.00',		'V',	'0.00',		'14.00',		'0',		'5')
;


select * from yndev.faktury_source;



truncate table yndev.platby_source;

select * from zakaznici where id = 101;
select * from platby where vs = 1011 order by datum_platby desc limit 1;
insert into yndev.platby_source values 

#### customer #100 with 5 payments on time
# id,		id_customer,	suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	popis,	account,	bank,	sender, iban,	step
 ('400',	'100',			'10.00',	'1011',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'1')
,('401',	'100',			'10.00',	'1011',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'2')
,('402',	'100',			'10.00',	'1011',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'3')
,('403',	'100',			'10.00',	'1011',	'0',	'2025-04-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'4')
,('404',	'100',			'10.00',	'1011',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #101 with 5 interrupted and mixed payments with delay
# id,		id_customer,	suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	popis,	account,	bank,	sender, iban,	step
,('410',	'101',			'09.95',	'1003',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'1')
,('411',	'101',			'09.95',	'1003',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'2')
,('412',	'101',			'19.95',	'1003',	'0',	'2025-11-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'3')
,('413',	'101',			'19.95',	'1003',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'4')
,('414',	'101',			'19.95',	'1003',	'0',	'2025-12-23',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #102 with 5 interrupted but insufficient payments on time
# id,		id_customer,	suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	popis,	account,	bank,	sender, iban,	step
,('420',	'102',			'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'1')
,('421',	'102',			'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'2')
,('422',	'102',			'10.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'3')
,('423',	'102',			'10.00',	'9999',	'0',	'2025-06-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'4')
,('424',	'102',			'10.00',	'9999',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'5')

#### customer #103 with 3 delayed and insufficient payments and 1 delayed but sufficient payment
# id,		id_customer,	suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	popis,	account,	bank,	sender, iban,	step
,('430',	'103',			'04.50',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'1')
,('431',	'103',			'04.50',	'9999',	'0',	'2025-01-05',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'2')
,('432',	'103',			'20.35',	'9999',	'0',	'2025-03-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'3')
,('433',	'103',			'20.65',	'9999',	'0',	'2025-09-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'4')

#### customer #102 with 5 interrupted but more than sufficient payments on time
# id,		id_customer,	suma,		vs,		ss,		datum_platby,	zdroj,		file,		day_index,	popis,	account,	bank,	sender, iban,	step
,('440',	'104',			'10.00',	'9999',	'0',	'2025-01-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'1')
,('441',	'104',			'10.00',	'9999',	'0',	'2025-02-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'2')
,('442',	'104',			'10.00',	'9999',	'0',	'2025-05-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'3')
,('443',	'104',			'10.00',	'9999',	'0',	'2025-06-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'4')
,('444',	'104',			'23.00',	'9999',	'0',	'2025-12-03',	'banka',	'file.txt',	'1',		NULL,	NULL,		NULL, 	NULL,	NULL,	'5')

;
select * from yndev.platby_source;
#*/

create temporary table if not exists yndev.uhrady_assert
(
	id_faktura int not null,
    id_platba int not null,
    suma decimal(8,2) not null,
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
#id_f, 	id_p,	suma,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
 (100, 	400, 	10.0, 	10.0, 	'2025-01-03', 	100, 	0.0, 		1, 		1)
,(101, 	401, 	10.0, 	10.0, 	'2025-02-03', 	100, 	0.0, 		2, 		2)
,(102, 	402, 	10.0, 	10.0, 	'2025-03-03', 	100, 	0.0, 		3, 		3)
,(103, 	403, 	10.0, 	10.0, 	'2025-04-03', 	100, 	0.0, 		4, 		4)
,(104, 	404, 	10.0, 	10.0, 	'2025-05-03', 	100, 	0.0, 		5, 		5)

##### customer #101 with 5 interrupted and mixed invoices
##### customer #101 with 5 interrupted and mixed payments with delay
#id_f, 	id_p,	suma,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(110, 	410, 	09.95,	09.95,	'2025-01-03', 	101, 	0.0, 		1, 		1)
,(111, 	411, 	09.95,	09.95,	'2025-02-03', 	101, 	0.0, 		2, 		2)
,(112, 	412, 	19.95,	19.95,	'2025-11-03', 	101, 	0.0, 		3, 		3)
,(113, 	413, 	19.95,	19.95,	'2025-12-03', 	101, 	0.0, 		4, 		4)
,(114, 	414, 	19.95,	19.95,	'2025-12-23', 	101, 	0.0, 		5, 		5)

##### customer #102 with 5 interrupted and mixed
#### customer #102 with 5 interrupted but insufficient payments on time
#id_f, 	id_p,	suma,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(120, 	420, 	10.00,	10.00,	'2025-01-03', 	102, 	0.0, 		1, 		1)
,(121, 	421, 	10.00,	10.00,	'2025-02-03', 	102, 	0.0, 		2, 		2)
,(122, 	422, 	10.00,	12.00,	'2025-05-03', 	102, 	-2.0,		3, 		3)
,(122, 	423, 	02.00,	12.00,	'2025-06-03', 	102, 	8.0,		3, 		4)
,(123, 	423, 	08.00,	13.00,	'2025-06-03', 	102, 	-5.0,		4, 		4)
,(123, 	424, 	05.00,	13.00,	'2025-12-03', 	102, 	5.0,		4, 		5)
,(124, 	424, 	05.00,	14.00,	'2025-12-03', 	102, 	-9.0,		5, 		5)

##### customer #103 with 5 simple invoices
#### customer #103 with 3 delayed and insufficient payments and 1 delayed but sufficient payment
#id_f, 	id_p,	suma,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(130, 	430, 	04.50,	10.00,	'2025-01-03', 	103, 	-5.5, 		1, 		1)
,(130, 	431, 	04.50,	10.00,	'2025-01-05', 	103, 	-1.0, 		1, 		2)
,(130, 	432, 	01.00,	10.00,	'2025-03-03', 	103, 	19.35, 		1, 		3)
,(131, 	432, 	10.00,	10.00,	'2025-03-03', 	103, 	9.35, 		2, 		3)
,(132, 	432, 	09.35,	10.00,	'2025-03-03', 	103, 	-0.65, 		3, 		3)
,(132, 	433, 	00.65,	10.00,	'2025-09-03', 	103, 	20.00, 		3, 		4)
,(133, 	433, 	10.00,	10.00,	'2025-09-03', 	103, 	10.00, 		4, 		4)
,(134, 	433, 	10.00,	10.00,	'2025-09-03', 	103, 	0.00, 		5, 		4)

##### customer #104 with 5 interrupted and mixed
#### customer #104 with 5 interrupted but more than sufficient payments on time
#id_f, 	id_p,	suma,	suma_f,	datum,			id_zak	balance,	step_f,	step_p
,(140, 	440, 	10.00,	10.00,	'2025-01-03', 	104, 	0.0, 		1, 		1)
,(141, 	441, 	10.00,	10.00,	'2025-02-03', 	104, 	0.0, 		2, 		2)
,(142, 	442, 	10.00,	12.00,	'2025-05-03', 	104, 	-2.0,		3, 		3)
,(142, 	443, 	02.00,	12.00,	'2025-06-03', 	104, 	8.0,		3, 		4)
,(143, 	443, 	08.00,	13.00,	'2025-06-03', 	104, 	-5.0,		4, 		4)
,(143, 	444, 	05.00,	13.00,	'2025-12-03', 	104, 	18.0,		4, 		5)
,(144, 	444, 	14.00,	14.00,	'2025-12-03', 	104, 	4.0,		5, 		5)
;


select * from yndev.uhrady_assert;

############ init first step one time

truncate table yndev.uhrady_new;
truncate table yndev.customer_steps;

insert into yndev.customer_steps
select distinct id_zak, 1, 1, 0 
from yndev.faktury_source 
#where id_zak in (1635,1647)
;
select * from yndev.customer_steps;

############ REPEAT - 1. get payments and invoices for current step



### get payments
#/*
select 
	cs.*,
    f.d_fakt, f.cislo,
    p.datum_platby, 
    cs.saldo,
    p.suma as suma_p,
    f.suma as suma_f,

    case when /*PREVIOUS DEBT*/ cs.saldo < 0 then
		case when /*SUFFICIENT PAY*/ p.suma >= -cs.saldo then -cs.saldo else /*INSUFFICIENT PAYMENT*/ p.suma end
    else 
		case when /*UNSPENT CREDIT*/ cs.saldo > 0 then
			case when /*SUFFICIENT CREDIT*/ cs.saldo >= f.suma then f.suma else /*INSUFFICIENT CREDIT*/ cs.saldo end
		else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/
			case when /*SUFFICIENT PAYMENT*/ p.suma >= f.suma then f.suma else /*INSUFFICIENT PAYMENT*/ p.suma end
	end end as suma_new,

    case when /*PREVIOUS DEBT*/ cs.saldo < 0 then cs.saldo + p.suma
    else 
		case when /*UNSPENT CREDIT*/ cs.saldo > 0 then cs.saldo - f.suma
		else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/ p.suma - f.suma
	end end as saldo_new
from yndev.faktury_source as f
left join yndev.platby_source as p on p.id_customer = f.id_zak
join yndev.customer_steps as cs on cs.id_zak = f.id_zak
where cs.step_f = f.step and cs.step_p = p.step
#	and f.id_zak in (1635,1647)
order by id_zak
;
#*/


insert into yndev.uhrady_new
select 
	null as id, 
    f.id as f_id, 
    p.id as p_id, 

    case when /*PREVIOUS DEBT*/ cs.saldo < 0 then
		case when /*SUFFICIENT PAY*/ p.suma >= -cs.saldo then -cs.saldo else /*INSUFFICIENT PAYMENT*/ p.suma end
    else 
		case when /*UNSPENT CREDIT*/ cs.saldo > 0 then
			case when /*SUFFICIENT CREDIT*/ cs.saldo >= f.suma then f.suma else /*INSUFFICIENT CREDIT*/ cs.saldo end
		else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/
			case when /*SUFFICIENT PAYMENT*/ p.suma >= f.suma then f.suma else /*INSUFFICIENT PAYMENT*/ p.suma end
	end end as suma,
    f.cena_sluzby as suma_f, 
    p.datum_platby as datum,
    cs.id_zak, 

    case when /*PREVIOUS DEBT*/ cs.saldo < 0 then cs.saldo + p.suma
    else 
		case when /*UNSPENT CREDIT*/ cs.saldo > 0 then cs.saldo - f.suma
		else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/ p.suma - f.suma
	end end as balance,
    cs.step_f, 
    cs.step_p
from yndev.faktury_source as f
left join yndev.platby_source as p on p.id_customer = f.id_zak
join yndev.customer_steps as cs on cs.id_zak = f.id_zak 
	and cs.step_f = f.step 
	and cs.step_p = p.step
#where f.id_zak in (1635,1647)
order by d_fakt, id_zak
;

update yndev.customer_steps as cs
join yndev.uhrady_new as u on u.id_zak = cs.id_zak
	and cs.step_f = u.step_f 
	and cs.step_p = u.step_p
set
	cs.id_zak = cs.id_zak
    
    #todo: does not work when new saldo is negative but payment covered previous invoice
	,cs.step_f = case when balance >= 0 then u.step_f + 1 else u.step_f end
	,cs.step_p = case when balance <= 0 then u.step_p + 1 else u.step_p end
    ,saldo = u.balance
;

select * from yndev.customer_steps; #where id_zak = 848;
select * from yndev.uhrady_new order by id_zak; #where balance != 0 order by datum; # id_zak = 257;

select * from yndev.customer_steps order by 2 desc, 3 asc;

select 
	date_format(f.d_fakt, '%Y-%m') as period
    , count(*) as invoices
    , sum(case when u.id is null then 1 else 0 end) unpaired
    , sum(case when u.id is null then 0 else 1 end) paired
from yndev.faktury_source as f
left join yndev.uhrady_new as u on u.id_faktura = f.id
group by date_format(f.d_fakt, '%Y-%m')
order by 1
;


#### assert actual matched payments with invoices against expected payments with invoices (for simulated scenarios only)

select
	ua.id_zak,un.id_zak
    ,case when ua.id_faktura = un.id_faktura then '' else '**' end _id_f
    ,case when ua.id_platba = un.id_platba then '' else '**' end _id_p
    ,case when ua.suma = un.suma then '' else '**' end _su
    ,case when ua.suma_f = un.suma_f then '' else '**' end _suf
    ,case when ua.datum = un.datum then '' else '**' end _datum
    ,case when ua.balance = un.balance then '' else '**' end _bal
    ,case when ua.step_f = un.step_f then '' else '**' end _sf
    ,case when ua.step_p = un.step_p then '' else '**' end _sp

	,ua.id_faktura as exp_id_faktura	,un.id_faktura as act_id_faktura
    ,ua.id_platba as exp_id_platba	,un.id_platba as act_id_platba
    ,ua.suma as exp_suma			,un.suma as act_suma
    ,ua.suma_f as exp_suma_f		,un.suma_f as act_suma_f
    ,ua.datum as exp_datum			,un.datum as act_datum
    ,ua.balance as exp_balance		,un.balance as act_balance
    ,ua.step_f as exp_step_f		,un.step_f as act_step_f
    ,ua.step_p as exp_step_p		,un.step_p as act_step_p
from yndev.uhrady_new as un
right join yndev.uhrady_assert as ua 
	on ua.id_zak = un.id_zak
    and ua.id_faktura = un.id_faktura 
    and ua.id_platba = un.id_platba
#where ua.id_zak = 102
order by ua.id_zak; 






select *,z.zmluva 
from uhrady as u
join faktury as f on f.id = u.id_faktura
join zakaznici as z on z.id = f.id_zak
where f.suma != u.suma and zlava != 0 #and id_faktura = '76247'
limit 100
;
select * from uhrady where id_platba = 67863;
select * from platby where id in('67863','67724');