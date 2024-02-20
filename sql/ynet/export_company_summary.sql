
	SELECT 
		z.id, z.zmluva, concat(z.meno, ' (', z.zmluva, ')') meno, coalesce(f.period, p.period) period, coalesce(f.suma, 0) invoiced, coalesce(p.suma, 0) paid, coalesce(p.suma, 0) - coalesce(f.suma, 0) saldo
	FROM zakaznici z
	left join (select id_zak, date_format(d_fakt, '%Y') as period, sum(suma) suma from yndev.faktury_new group by id_zak, date_format(d_fakt, '%Y') ) as f on f.id_zak = z.id
	left join (select id_customer, date_format(datum_platby, '%Y') as period, sum(suma) suma from yndev.platby_new group by id_customer, date_format(datum_platby, '%Y') ) as p on p.id_customer = z.id
		and p.period = f.period
	where coalesce(f.id_zak, p.id_customer) is not null
		and f.period >= 2020
        #and z.zmluva = 3044
	order by z.meno, coalesce(f.period, p.period);
    

select * from yndev.platby_new where id_customer in (1587, 1553, 1582, 1551, 1550, 1556, 1580, 1557, 1535, 1540, 1540, 1548, 1583, 1532, 1534, 1602, 1627, 1530, 1541, 1548);
select * from yndev.faktury_new where id_zak in (1587, 1553, 1582, 1551, 1550, 1556, 1580, 1557, 1535, 1540, 1540, 1548, 1583, 1532, 1534, 1602, 1627, 1530, 1541, 1548);
select * from yndev.import_consolidated where vs_from_adhoc_invoice is not null limit 10;
select * from zakaznici where id = 28;
# id	payment_index	payment_date	is_credit	amount	vs	ss	origin	payer_iban	payer_name	detail	payment_id	bank_ref	payer_ref	customer_Id	vs_orig	vs_from_payer	vs_from_typo	vs_from_iban_payer	vs_from_adhoc_invoice
#2648	4	2022-08-18	1	153.00	4118	0	export_SK0702000000002278166653_18-08-2022-18-08-2022.XML	SK7881300000002113210118	ags 92, s.r.o.		5270918496	2292017251281	/VS4118/SS/KS	-1	4118	1108220005			4118

