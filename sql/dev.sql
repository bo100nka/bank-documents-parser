
select * from yndev.platby_new p where zdroj = 'tatrabanka' and p.datum_platby = '2022-01-07' order by id_customer;
select * from platby p where zdroj = 'tatrabanka' and p.datum_platby = '2022-01-07' order by id_customer;
/* id	id_customer	suma	vs	ss	datum_platby	zdroj	file	day_index	popis	account	bank	sender	iban
84921	101	6.61	1003	0	2022-01-03	banka	export_SK0702000000002278166653_03-01-2022-03-01-2022.TXT	7	INTERNET	0000002915968836	1100
*/

select * from platby where vs = '10043' and datum_platby > '2022-01-01' order by datum_platby;

select 
	datum_platby
    , sum(case zdroj when 'banka' then 1 else 0 end) as platby_vub 
    , sum(case zdroj when 'posta' then 1 else 0 end) as platby_posta
    , sum(case zdroj when 'tatrabanka' then 1 else 0 end) as platby_tatrabanka
from platby p 
where p.datum_platby between '2022-01-01' and '2022-01-10' 
group by datum_platby order by 1;


select 
	datum_platby
    , sum(case zdroj when 'banka' then 1 else 0 end) as platby_vub 
    , sum(case zdroj when 'posta' then 1 else 0 end) as platby_posta
    , sum(case zdroj when 'tatrabanka' then 1 else 0 end) as platby_tatrabanka
from yndev.platby_new p 
where p.datum_platby between '2022-01-01' and '2022-01-10' 
group by datum_platby order by 1;


select datum_platby, zdroj, count(*) from yndev.platby_new p where p.datum_platby between '2021-01-01' and '2022-04-26' group by datum_platby,zdroj order by 1;

select * from platby where datum_platby = '2022-01-10' and suma = 54;
# id	id_customer	suma	vs	ss	datum_platby	zdroj	file	day_index	popis	account	bank	sender	iban
#84981	1271	54.00	4202	0	2022-01-10	banka	export_SK0702000000002278166653_10-01-2022-10-01-2022.TXT	3	Tothova Veronika 01.01.2022-31.12.2022
		

select * from yndev.platby_new where datum_platby = '2022-01-10' and suma = 54;
# id	id_customer	suma	vs	ss	datum_platby	zdroj	file	day_index	popis	account	banka	sender	iban
#150	1271	54.00	4202	0	2022-01-08	banka	export_SK0702000000002278166653_10-01-2022-10-01-2022.XML	4	/VS4202/SS/KS308;2201080TVSGSM;4920097501;Tothova Veronika 01.01.2022-31.12.2			Stanislav Juriga	SK6002000000003061584453


select * from yndev.platby_new where datum_platby = '2021-12-31';
select * from platby where datum_platby = '2021-12-31';


select * from yndev.import_consolidated where origin = 'export_SK0702000000002278166653_10-01-2022-10-01-2022.XML'; #and payer_name like '%Tothova%';



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

select stav, cislo, d_fakt from faktury where stav = 'v' order by d_fakt desc limit 1;
select stav, cislo, d_fakt from faktury where stav = 't' order by d_fakt desc limit 1;
select stav, cislo, d_fakt from faktury where stav = '0' order by d_fakt desc limit 1;
select stav, cislo, d_fakt from faktury where stav = '1' order by d_fakt desc limit 1;
/*
#stav	cislo		d_fakt
'V'		011223/2119	20231201
'T'		010215/440	20150201
'0'		011123/660	20231101
'1'		011223/1483	20231201
*/
#?????????????



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


