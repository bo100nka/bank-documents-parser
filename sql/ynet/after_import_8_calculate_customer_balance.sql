
###### store customer balance to tables

	drop table if exists yndev.customer_balance_detail;

	create table yndev.customer_balance_detail as
	SELECT 
		u.id_zak, u.step_f, u.step_p, z.zmluva, z.meno, u.id_faktura, u.id_platba, p.vs, u.suma as suma_uhrady, u.suma_p as suma_platby, u.suma_f as suma_faktury, u.datum as datum_platby, u.balance, 
		f.cislo, f.d_fakt, f.d_splat, 
		s.popis as sluzba, 
		p.popis as detail, p.sender, p.iban
	FROM yndev.uhrady_new as u
	left join yndev.faktury_source as f on f.id = u.id_faktura
	left join yndev.platby_source as p on p.id = u.id_platba
	left join sluzby as s on s.id = f.id_sluzby
	join zakaznici as z on u.id_zak = z.id
	;

	drop table if exists yndev.customer_balance;

	create table yndev.customer_balance as

	select 
		d.id_zak, d.zmluva, d.meno, obec, install_obec, ico, dic, icdph
        , max_step_f, max_step_p, total_invoiced, round(total_paid, 2) as total_paid, balance
        , date_format(min_d_fakt, '%Y-%m-%d') as min_d_fakt
        , date_format(max_d_fakt, '%Y-%m-%d') as max_d_fakt
        , case min_d_pay when '2050-01-01' then '1900-01-01' else min_d_pay end as min_d_pay, max_d_pay
    from yndev.customer_balance_detail as d
    join (
			select id_zak, max(step_f) as max_step_f, max(step_p) as max_step_p , min(d_fakt) as min_d_fakt, max(d_fakt) as max_d_fakt
				, min(case datum_platby when '1900-01-01' then '2050-01-01' else datum_platby end) as min_d_pay
                , max(datum_platby) as max_d_pay
            from yndev.customer_balance_detail 
            group by id_zak) as m 
		on d.id_zak = m.id_zak
		and d.step_f = m.max_step_f
		and d.step_p = m.max_step_p
	join (select id_zak, sum(suma) as total_invoiced from yndev.faktury_source group by id_zak) as f on f.id_zak = d.id_zak
	join (select id_customer, sum(suma) as total_paid from yndev.platby_source group by id_customer) as p on p.id_customer = d.id_zak
	join zakaznici as z on z.id = d.id_zak
	order by meno
	;

	# select * from yndev.customer_balance_detail where id_zak = 175

	select * from yndev.customer_balance_detail order by meno; #limit 100;
    select * from yndev.customer_balance order by meno;
    