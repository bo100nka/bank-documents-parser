/*
Tento skript je na export faktur z databazy do ucotvneho systemu
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



select a_row_type, b_record_type, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
	, aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ak, al, am, an, ao, ap, aq, ar, as_, at_, au, av, aw, ax, ay_, az
	, ba, bb, bc, bd, be, bf, bg, bh, bi, bj, bk, bl, bm, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, by_, bz
	, ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, ck, cl, cm, cn, co, cp
from 
(
	#/*
	select 
		 1																as melisko
		,'R00'															as a_row_type
		,'T01'															as b_record_type
		,null as c,null as d,null as e,null as f,null as g,null as h,null as i,null as j,null as k,null as l,null as m,null as n,null as o,null as p,null as q,null as r,null as s,null as t,null as u,null as v,null as w,null as x,null as y,null as z
		,null as aa,null as ab,null as ac,null as ad,null as ae,null as af,null as ag,null as ah,null as ai,null as aj,null as ak,null as al,null as am,null as an,null as ao,null as ap,null as aq,null as ar,null as as_,null as at_,null as au,null as av,null as aw,null as ax,null as ay_,null as az
		,null as ba,null as bb,null as bc,null as bd,null as be,null as bf,null as bg,null as bh,null as bi,null as bj,null as bk,null as bl,null as bm,null as bn,null as bo,null as bp,null as bq,null as br,null as bs,null as bt,null as bu,null as bv,null as bw,null as bx,null as by_,null as bz
		,null as ca,null as cb,null as cc,null as cd,null as ce,null as cf,null as cg,null as ch,null as ci,null as cj,null as ck,null as cl,null as cm,null as cn,null as co,null as cp
	union all
	##*/


#select * from zakaznici where zmluva = 1174

	################ BF = ICO firmy (yellownet / yellowinternet) - treba zmenit podla aktualnej databazy !!!!!!
	#/*
	select
		 concat('melisko_', f.cislo)									as melisko
		,'R01' 															as a_row_type
		,f.cislo 														as b_receipt_number
		,left(concat(z.meno, ' (', z.zmluva, ')'), 75)					as c_partners_name
		,case z.ico when 0 then null else z.ico end						as d_ico
		,date_format(f.d_fakt, '%d.%m.%Y')								as e_date_of_receipt
		,date_format(f.d_splat, '%d.%m.%Y')								as f_due_date
		,date_format(f.d_fakt, '%d.%m.%Y')								as g_duzp
		,0																as h_vat_base_lower
		#,round(f.cena_bez_dph, 4)										as i_vat_base_higher	### ynet
		,0																as i_vat_base_higher	### yinternet
		,0																as j_vat_base_null
		#,0																as k_vat_base_free		### ynet
		,round(f.cena_bez_dph, 4)										as k_vat_base_free		### yinternet
		,10																as l_vat_rate_lower
		,20																as m_vat_rate_higher
		,0																as n_vat_lower
		#,f.dph															as o_vat_higher			### ynet
		,0																as o_vat_higher			### yinternet
		,0																as p_price_correction
		#,round(floor(f.cena_bez_dph * 1.2 * 100) / 100, 2)				as q_amount_foreign_currency
		#,round(f.cena_bez_dph * 1.2, 2)									as q_amount_foreign_currency ### ynet
		,f.cena_bez_dph													as q_amount_foreign_currency ### yinternet
		,0																as r_record_type #0 = customer invoice
		,'OF'															as s_tally_code
		,'OF'															as t_code_of_sequence
		,z.zmluva														as u_internal_partner_number
		,null															as v_code_of_partner
		,null															as w_centre_partner
		,null															as x_plent_partner
		,z.ulica														as y_street
		,z.psc															as z_postal_code
		,z.obec															as aa_city
		,case z.ico when 0 then null else z.dic end						as ab_tax_partner
		,'08:00:00'														as ac_time_of_issue
		,null															as ad_xxxxx
		,null															as ae_xxxxx
		,null															as af_xxxxx
		,null															as ag_xxxxx
		,null															as ah_xxxxx
		,null															as ai_xxxxx
		,null															as aj_xxxxx
		,null															as ak_xxxxx
		,null															as al_xxxxx
		,null															as am_xxxxx
		,'EUR'															as an_currency
		,1																as ao_quantity
		,1																as ap_exchange_rate
		#,round(floor(f.cena_bez_dph * 1.2 * 100) / 100, 2)				as aq_amount_domestic_currency
		#,round(f.cena_bez_dph * 1.2, 2)								as aq_amount_domestic_currency ### ynet
		,f.cena_bez_dph													as aq_amount_domestic_currency ### yinternet
		,null															as ar_xxxxx
		,null															as as_xxxxx
		,null															as at_xxxxx
		,'SK'															as au_partner_country
		,case z.ico when 0 then null else 'SK' end 						as av_code_of_vat
		,case z.ico when 0 then null else mid(z.icdph, 3, 99) end		as aw_vat
		,null															as ax_xxxxx
		,null															as ay_xxxxx
		,null															as az_xxxxx
		,'SK'															as ba_partner_country
		,null															as bb_xxxxx
		,left(concat(z.meno, ' (', z.zmluva, ')'), 15)					as bc_short_partners_name
		,null															as bd_xxxxx
		,null															as be_xxxxx
		,'SK'															as bf_partner_country
		#,'2022339121'													as bg_vat_of_supplier	### pre yellownet
		,null															as bg_vat_of_supplier	### pre yellowinternet
		,'SK'															as bh_partner_country
		,-3																as bi_round
		,3																as bj_round_mode
		,0																as bk_reg_order_number
		,999															as bl_round_of_item
		,null															as bm_xxxxx
		,0																as bn_xxxxx
		,0																as bo_xxxxx
		,0																as bp_xxxxx
		,null															as bq_xxxxx
		,0																as br_xxxxx
		,z.zmluva														as bs_vs
		,null															as bt_xxxxx
		,concat(z.meno, ' (', z.zmluva, ')') 							as bu_contact_name
		,null															as bv_xxxxx
		,null															as bw_xxxxx
		,z.ulica														as bx_street
		,z.psc															as by_postal_code
		,z.obec															as bz_city
		,null															as ca_xxxxx
		,null															as cb_xxxxx
		,null															as cc_xxxxx
		,null															as cd_xxxxx
		,null															as ce_xxxxx
		,null															as cf_xxxxx
		,0																as cg_xxxxx
		,0																as ch_xxxxx
		,null															as ci_xxxxx
		,null															as cj_xxxxx
		,0																as ck_xxxxx
		,null															as cl_xxxxx
		,null															as cm_xxxxx
		,null															as cn_xxxxx
		,0																as co_xxxxx
		,0																as cp_xxxxx
	FROM faktury f 
	left join zakaznici z on z.id = f.id_zak 
	where d_fakt between '20230101' and '20231231' # and z.zmluva in (1174,6023,1152)
	#*/

	union all

	#/*
	############ verify mnozstvo > 1 !!!!!!
	#select popis, mnozstvo from faktury_polozky where mnozstvo > 1\
	(
	select
		 concat('melisko_', f.cislo)									as melisko
		,'R02' 															as a_row_type
		,p.popis														as b_name_of_item
		,1																as c_quantity
		,'ks'															as d_unit
		,p.cena_bez_dph													as e_unit_price_without_vat
		#,'V'															as f_rate_of_vat	### ynet
		,null															as f_rate_of_vat	### yinternet
		,0																as g_xxxxx
		,p.cena_bez_dph													as h_list_price
		,'0'																as i_xxxx
		,'V'															as j_xxxx
		,null															as k_xxxx
		,null															as l_xxxx
		,0																as m_xxxx
		,602															as n_xxxx
		,100															as o_xxxx
		,null															as p_xxxx
		,null															as q_xxxx
		,null															as r_xxxx
		,null															as s_xxxx
		,null															as t_xxxx
		,'X'															as u_xxxx
		,'(Nedefinované)'												as v_xxxx
		,'X'															as w_xxxx
		,'(Nedefinované)'												as x_xxxx
		,'X'															as y_xxxx
		,'(Nedefinované)'												as z_xxxx
		,'X'															as aa_xxxx
		,'(Nedefinované)'												as ab_xxxx
		,null															as ac_xxxx
		#,'03'															as ad_xxxx		### ynet
		,null															as ad_xxxx		### yinternet
		,1																as ae_xxxx
		,1																as af_xxxx
		,1																as ag_xxxx
		,1																as ah_xxxx
		,1																as ai_xxxx
		,1																as aj_xxxx
		,1																as ak_xxxx
		,'ks'															as al_xxxx
		,1																as am_xxxx
		,null															as an_xxxx
		,null															as ao_xxxx
		,null															as ap_xxxx
		,null															as aq_xxxx
		,null															as ar_xxxx
		,-3																as as_xxxx
		,3																as at_xxxx
		,0																as au_xxxx
		,null															as av_xxxx
		#,round(floor(p.cena_bez_dph * 1.2 * 100) / 100, 2)				as aw_list_price_with_vat ### ynet
		,p.cena_bez_dph													as aw_list_price_with_vat ### yinternet
		,0																as ax_xxxx
		#,round(floor(p.cena_bez_dph * 1.2 * 100) / 100, 2)				as ay_unit_price_with_vat ### ynet
		,p.cena_bez_dph													as ay_unit_price_with_vat ### yinternet
		,0																as az_xxxx
		,0																as ba_xxxx
		#,case z.ico when 0 then 'D2' else 'A1' end 					as bb_kvdph		### ynet
		,'X'									 						as bb_kvdph		### yinternet
		,null															as bc_xxxx
		,null															as bd_xxxx
		,null															as be_xxxx
		,'0,0000'														as bf_xxxx
		,null as bg,null as bh,null as bi,null as bj,null as bk,null as bl,null as bm,null as bn,null as bo,null as bp,null as bq,null as br,null as bs,null as bt,null as bu,null as bv,null as bw,null as bx,null as by_,null as bz
		,null as ca,null as cb,null as cc,null as cd,null as ce,null as cf,null as cg,null as ch,null as ci,null as cj,null as ck,null as cl,null as cm,null as cn,null as co,null as cp
		
	FROM faktury f 
	left join faktury_polozky p on p.id_faktura = f.id
	left join zakaznici z on z.id = f.id_zak 
	where d_fakt between '20230101' and '20231231' # and z.zmluva in (1174,6023,1152)
	order by h_list_price desc
	#*/
	)

	order by melisko, a_row_type
) as result
