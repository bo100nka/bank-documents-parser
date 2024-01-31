/*
Tento skript je na export uhrady z databazy do ucotvneho systemu
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



select a_row_type, b_record_type, c, d, e, f, g, h, i, j, k
from 
(
	#/*
	select 
		 'R00'															as a_row_type
		,'T08'															as b_record_type
		,null as c,null as d,null as e,null as f,null as g,null as h,null as i,null as j,null as k
	union all
	##*/


#select * from zakaznici where zmluva = 1174

	#/*
	select
		 'R01' 															as a_row_type
		,date_format(u.datum, '%d.%m.%Y')								as b_date_of_payment
		,u.suma															as c_amount_paid_eur
		,u.suma															as d_amount_paid_fc
        ,'EUR'															as e_currency
        ,f.cislo														as f_settlement_document_number
        ,p.vs															as g_external_number_of_settlement_document
        ,null															as h_payment_id
		,left(concat(z.meno, ' (', z.zmluva, ')'), 75)					as i_partners_name
        ,'OF'															as j_curcuit_code_settlemented_document
		,'+'															as k_sign_credit_debit
	FROM yndev.uhrady_new u 
	join zakaznici z on z.id = u.id_zak 
    join yndev.faktury_new f on f.id = u.id_faktura
    join yndev.platby_new p on p.id = u.id_platba
	where 
		id_faktura != -1 and id_platba != -1
		and d_fakt between '20230101' and '20231231' 
        and z.zmluva in (3370)
	#*/


	order by a_row_type
) as result

#select * from yndev.uhrady_new limit 10
#select * from yndev.faktury_new limit 10
