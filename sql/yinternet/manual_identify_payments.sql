select * from yidev.import_consolidated;



select payer_name_filled, vs, count(*)
from yidev.import_consolidated
where is_credit = 1 and vs < 100
group by payer_name_filled, vs
order by 1,2;

### payers with every payment has missing vs
select payer_name_filled, 
	count(*) as payments_total, 
    sum(case vs when 0 then 1 else 0 end) as payments_missing_vs,
    sum(case vs_filled when 0 then 1 else 0 end) as payments_missing_vsfilled
from yidev.import_consolidated
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
from yidev.import_consolidated
where is_credit = 1
group by payer_name_filled
having payments_missing_vs between 1 and (payments_total - 1)
order by 1
;

select * from yidev.import_consolidated where vs = 0 and vs_filled != 0 and is_credit = 1;
select distinct payer_iban, payer_name_filled, 999999 as vs_missing from yidev.import_consolidated where vs = 0 and vs_filled = 0 and is_credit = 1 order by 1,2;

select * from zakaznici where meno like '%nadezda%';
/*
# id	meno	c_op	ulica	obec	psc	stat	vyrocny_den	ico	dic	icdph	zmluva	email	telefon	poznamka	zasielanie_faktur	sposob_platby	je_platca_dph	use_koresp	koresp_meno	koresp_ulica	koresp_obec	koresp_psc	koresp_stat	install_ulica	install_obec	install_psc	install_vchod_poschodie	upomienky	tv_id
728	Karpitová Mariana	ER673584	Rovensko 164	Rovensko	90501	SK	1	0			9049	palcik@azet.sk	0948203919		1	banka	0	0						Rovensko 164	Rovensko	90501		0	
*/

select * from yidev.import_consolidated where payer_name_filled = 'MARIANA KARPITOVA';
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
from yidev.import_consolidated a
where payer_name_filled is not null
group by payer_name_filled
order by 1
;

select b.*, a.* from yidev.import_consolidated as a
left join yidev.import_lookup_payer2vs as b on b.payer_name = a.payer_name_filled
where a.vs = 0
;


select count(*) from yidev.import_consolidated where vs_filled = 0 and is_credit = 1;

select * from yidev.import_consolidated where payer_name = 'ONDRASKOVA';


select count(*) from yidev.import_consolidated left join zakaznici on zmluva = vs where zakaznici.id is not null;
select count(*) from yidev.import_consolidated left join zakaznici on zmluva = vs_filled where zakaznici.id is not null;
select count(*) from yidev.import_consolidated where vs_filled = 0;
select count(*) from yidev.import_consolidated where vs_manual != 0;

select * from yidev.import_consolidated where vs_filled <= 0 order by payer_name,payer_iban,origin;

select * from zakaznici where meno like '%Olsovska%';
select * from zakaznici where id = 140823;
select * from zakaznici where obec = 'kunov' or install_obec = 'kunov';
select * from zakaznici where zmluva in (2060);
select * from zakaznici where ulica like '%robotn%109%' or install_ulica like '%robotn%109%';

#4182
#4253
#Lubomir Sedivy,Sturova 1427/31,Bors

select zmluva, f.*, z.* from faktury f join zakaznici z on z.id = id_zak where zmluva in (2023);
select sum(amount) from yidev.import_consolidated where vs = 2024 order by payment_date;
select * from faktury left join zakaznici z on z.id = id_zak where d_fakt > 202000 and suma > 1000;
select sum(suma) from platby p where p.vs = 2024 and datum_platby < '2022-01-01' order by datum_platby;
select * from yidev.import_consolidated where payer_iban in ('AT501400006210018610', 'SK2611000000002947133382');
select * from yidev.import_consolidated where amount = 4;

select * from zakaznici where email like '%malik%' or meno like '%malik%' or telefon like '%0918%513%287%';

select zmluva, p.* from platby p left join zakaznici z on id_customer = z.id 
where iban = 'SK2611000000002947133382' or account like '%2947133382' 
	or sender like '%Malík%'  
	or popis like '%Malík%' 
order by datum_platby;

select zmluva, p.* from yidev.import_consolidated p left join zakaznici z on id_zak = z.id 
where (payer_iban = 'AT501400006210018610' or payer_iban like '%AT501400006210018610' 
	or payer_name like '%jaroska%' 
	or detail like '%jaroska%') #and suma = 10
order by datum_platby;

select * from faktury left join zakaznici z on z.id = id_zak where d_fakt between 20230401 and 20230431 and suma between 200 and 700 order by d_fakt, suma desc
;

## 2007-04-01 - 31.12.2021 zaplatila 1040.02 eur
## 01.01.2022 - 31.12.2023 zaplatila 450.60 eur
## spolu 1490.62 eur
## od 2007-04-01 je to 200 mesiacov x faktura za 13.30 eur = 2660 eur
## dlzna 1169.38 eur
