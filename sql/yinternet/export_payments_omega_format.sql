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
        ,'B1'															as c_tally_code
        , case p.zdroj
			when 'tatrabanka' then 'TATR'
            when 'banka' then 'SUBA' end								as d_sequence_code
		,concat( #BUTB{YY}-{MM}-{XXX}
			'BUTB', 
            date_format(p.datum_platby, '%y-%m'), '-', right(concat('000', di.day_index), 3)
		)																as e_internal_number
        ,''																as f_external_number
		,left(concat(z.meno, ' (', z.zmluva, ')'), 75)					as g_partners_name
		,case z.ico when 0 then null else z.ico end						as h_ico
		,case z.ico when 0 then null else z.dic end						as i_tax_partner
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

	FROM yidev.platby_new p
    join (select distinct id_platba from yidev.uhrady_new where id_faktura != -1) ud on p.id = ud.id_platba # ignore payments without invoice
    join (select id_platba, min(d_fakt) min_d_fakt from yidev.uhrady_new u join yidev.faktury_new f on f.id = u.id_faktura group by id_platba) upf on upf.id_platba = p.id
    join (select id, row_number() over (partition by zdroj, date_format(datum_platby, '%y-%m') order by zdroj, datum_platby) as day_index from yidev.platby_new) as di on di.id = p.id
	join zakaznici z on z.id = p.id_customer
	where 1=1 
    and upf.min_d_fakt <= '20231231'
    and p.zdroj != 'posta' 
    and p.datum_platby between '2023-01-01' and '2023-12-31'
    #and z.zmluva =14007#in (1174,6023,1152)
    #order by melisko
	#*/

	#select * from yidev.uhrady_new where id_platba = 8270

	union all

	#/*
	
	(
	select
		 concat('melisko_', u.id_zak, '_', p.datum_platby, '_', p.day_index, '_fid', f.cislo)	as melisko
		,'R02' 															as a_row_type
        ,0																as b_item_type
        ,case zdroj 
			when 'tatrabanka' then 221
			when 'banka' then 221 end									as c
        ,case zdroj 
			when 'tatrabanka' then 100
			when 'banka' then 200 end									as d
        ,311															as e
        ,100															as f
		,u.suma															as g
		,u.suma															as h
        ,concat('úhrada dokladu ', f.cislo)								as i
        ,'V'															as j
        ,f.cislo														as k
		,null as l,null as m,null as n,null as o,null as p,null as q,null as r,null as s,null as t,null as u,null as v,null as w,null as x,null as y,null as z
		,null as aa,null as ab,null as ac,null as ad

	FROM yidev.uhrady_new u
	join zakaznici z on z.id = u.id_zak
    join yidev.platby_new as p on p.id = u.id_platba
    join yidev.faktury_new as f on f.id = u.id_faktura
	where 1=1 
    and p.zdroj != 'posta'
    and f.d_fakt <= '20231231'
    #and z.zmluva =14007#in (1174)#,6023,1152)
    #order by melisko
	#*/
	)

	order by melisko, a_row_type
) as result


#) data group by e having x > 1 order by 2 desc
#BUTB23-10-001
;