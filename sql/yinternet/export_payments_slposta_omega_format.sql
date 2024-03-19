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
	, aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ak, al, am, an, ao
from 
(
	#/*
	select 
		 1																as melisko
		,'R00'															as a_row_type
		,'T00'															as b_record_type
		,null as c,null as d,null as e,null as f,null as g,null as h,null as i,null as j,null as k,null as l,null as m,null as n,null as o,null as p,null as q,null as r,null as s,null as t,null as u,null as v,null as w,null as x,null as y,null as z
		,null as aa,null as ab,null as ac,null as ad,null as ae,null as af,null as ag,null as ah,null as ai,null as aj,null as ak,null as al,null as am,null as an,null as ao
	union all
	##*/


#select * from zakaznici where zmluva = 1174
#select * from faktury limit 3;
#select * from platby where zdroj = 'banka' limit 3;

	#/*
	select
		 concat('melisko_', p.id_customer, '_', p.datum_platby, '_', p.day_index, '_fid000000')	as melisko
		,'R01' 															as a_row_type
        ,180															as b_doc_type # Internal Document
        ,'IDUP'															as c_tally_code
        ,'X'															as d_sequence_code
		,concat( # IDUHTATR{YYYYMMDD}{12}
			'IDUHTATR', 
            date_format(p.datum_platby, '%Y%m%d'), '-', right(concat('00', di.day_index), 2)
		)																as e_internal_number
		,concat( # IDUHTATR{YYYYMMDD}{12}
			'IDUHTATR', 
            date_format(p.datum_platby, '%Y%m%d'), '-', right(concat('00', di.day_index), 2)
		)																as f_external_number
		,left(concat(z.meno, ' (', z.zmluva, ')'), 75)					as g_partners_name
		,case z.ico when 0 then null else z.ico end						as h_ico
		,case z.ico when 0 then null else z.dic end						as i_tax_partner
		,date_format(p.datum_platby, '%d.%m.%Y')						as j
        ,''																as k
		,date_format(p.datum_platby, '%d.%m.%Y')						as l
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
        ,''																as ae
        ,''																as af
        ,upf.cislo														as ag
        ,z.zmluva														as ah
        ,'+'															as ai
        ,''																as aj
        ,z.zmluva														as ak
        ,''																as al
        ,'08:00:00'														as am
        ,''																as an
        ,coalesce(case p.popis when '' then null else left(p.popis, 60) end, 'Platba bez popisu')				as ao

	FROM yidev.platby_new p
    join (select distinct id_platba from yidev.uhrady_new where id_faktura != -1) ud on p.id = ud.id_platba # ignore payments without invoice
    join (select id_platba, min(d_fakt) min_d_fakt, min(cislo) cislo from yndev.uhrady_new u join yndev.faktury_new f on f.id = u.id_faktura group by id_platba) upf on upf.id_platba = p.id
    join (select id, row_number() over (partition by datum_platby order by datum_platby) as day_index from yidev.platby_new) as di on di.id = p.id
	join zakaznici z on z.id = p.id_customer
	where 1=1 
    and upf.min_d_fakt <= '20231231'
    and p.zdroj = 'posta' 
    and p.datum_platby between '2023-01-01' and '2023-12-31'
    #and z.zmluva =7138#in (1174,6023,1152)
    #order by melisko
	#*/

	

	union all

	#/*
	
	(
	select
		 concat('melisko_', u.id_zak, '_', p.datum_platby, '_', p.day_index, '_fid', f.cislo)	as melisko
		,'R02' 															as a_row_type
        ,0																as b_item_type
        ,315															as c
        ,100															as d
        ,311															as e
        ,100															as f
		,u.suma															as g
		,u.suma															as h
        ,left(concat('Zákazník:', z.meno, ' (', z.zmluva, ') data z PP ', z.meno), 60) as i
        ,'V'															as j
        ,f.cislo														as k
		,null as l,null as m,null as n,null as o,null as p,null as q,null as r,null as s,null as t,null as u,null as v,null as w,null as x,null as y,null as z
		,null as aa,null as ab,null as ac,null as ad,null as ae,null as af,null as ag,null as ah,null as ai,null as aj,null as ak,null as al,null as am,null as an,null as ao

	FROM yidev.uhrady_new u
	join zakaznici z on z.id = u.id_zak
    join yidev.platby_new as p on p.id = u.id_platba
    join yidev.faktury_new as f on f.id = u.id_faktura
	where 1=1 
    and p.zdroj = 'posta'
    and f.d_fakt <= '20231231'
    and p.datum_platby <= '2023-12-31'

    #and z.zmluva =7138#in (1174)#,6023,1152)
    #order by melisko
	#*/
	)

	order by melisko, a_row_type
) as result

#) data group by e having x > 1 order by 2 desc

;
