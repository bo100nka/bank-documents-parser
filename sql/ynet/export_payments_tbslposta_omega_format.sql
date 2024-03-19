/*
Tento skript je na export uhrad z databazy do ucotvneho systemu
Pripoj sa na mysql databazu - faktury a zakaznici (mySQL Workbench)
Vyber databazu yellownet - right click - Set as Default Schema
Skontroluj
- DIC firmy, z ktorej databazy ides hodnota v poli: bg_vat_of_supplier = '2022339121' pre yellownet (zakomentuj nevhodny riadok)
- filter pre fakturacny datum v query 1
- filter pre fakturacny datum v query 2
	(where d_fakt between) kde 202311 je vo formate YYYYMM
Spusti skript - klikni na blesk
Pod Result Grid sa zobrazi vysledna tabulka - nad tabulkou je ikona na export do externeho file
exportnut tabulku a ulozit vo formate txt oddeleny tabulatormi
najdi ulozeny subor a otvor ho pravym klikom v notepad++
vymaz prvy riadok s hlavickou
v riadku R00 treba odstranit vsetko za hodnotou T01 /od aktualnej pozicie oznacis po koniec riadku shift+END
v pravom dolnom rohu zmen pravym kliknutim mysi sposob riadakovania (z Unix LF na Windows CR LF)
Zmen kodovanie cez hornu ponuku: Enkoding - Convert to ANSI
Odstran vsetky NULL hodnoty - CTRL+H - hladany vyraz: NULL, Nahradit s: prazdne - nahradit vsetko.
*/

#select e, count(*) x from (


select a_row_type, b_record_type, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
	, aa, ab, ac, ad
from 
(
	#/*
	select 
		 1																as melisko
		,'R00'															as a_row_type
		,'T00'															as b_record_type
		,null as c,null as d,null as e,null as f,null as g,null as h,null as i,null as j,null as k,null as l,null as m,null as n,null as o,null as p,null as q,null as r,null as s,null as t,null as u,null as v,null as w,null as x,null as y,null as z
		,null as aa,null as ab,null as ac,null as ad
	union all
	##*/


#select * from zakaznici where zmluva = 1174
#select * from faktury limit 3;
#select * from platby where zdroj = 'banka' limit 3;

	#/*
	select
		 concat('melisko_', p.id_customer, '_', p.datum_platby, '_', p.day_index, '_fid000000')	as melisko
		,'R01' 															as a_row_type
        ,170															as b_doc_type # BV/Bank Statement
        , case p.zdroj
			when 'tatrabanka' then 'TATR'
            when 'banka' then 'SUBA' end								as c_tally_code
        , case p.zdroj
			when 'tatrabanka' then 'TATR'
            when 'banka' then 'SUBA' end								as d_sequence_code
		,concat( #BU-{TB/VUB}-DDMMYYYY-A-XX
			'BU', 
			case p.zdroj when 'tatrabanka' then 'TB' when 'banka' then 'VUB' end,
            '-P-', 
            date_format(p.datum_platby, '%d%m%Y'), '-', right(concat('00', di.day_index), 2)
		)																as e_internal_number
        ,''																as f_external_number
		,'SLOVENSKÁ POŠTA, A.S.'										as g_partners_name
		,36631124														as h_ico
		,2021879959														as i_tax_partner
		,date_format(p.datum_platby, '%d.%m.%Y')						as j
        ,''																as k
        ,''																as l
		,date_format(p.datum_platby, '%d.%m.%Y')						as m
		,date_format(p.datum_platby, '%d.%m.%Y')						as n
        ,'EUR'															as o
        ,1																as p
        ,1																as q
        ,0																as r
		,p.suma															as s
		,p.suma															as t
        ,10																as u
        ,20																as v
        ,0																as w
        ,0																as x
        ,0																as y
		,p.suma															as z
        ,0																as aa
        ,0																as ab
        ,0																as ac
        ,'Martin'														as ad

	FROM yndev.platby_new p
    join (select id, row_number() over (partition by zdroj, datum_platby order by zdroj, datum_platby) as day_index from yndev.platby_new) as di on di.id = p.id
	where 1=1 
	and id_customer = -1 and vs = -1 and sender like 'slovensk%ta%'
    and p.datum_platby between '2023-01-01' and '2023-12-31'
    #order by melisko
	#*/

	order by melisko, a_row_type
) as result
#) data group by e having x > 1 order by 2 desc
;
