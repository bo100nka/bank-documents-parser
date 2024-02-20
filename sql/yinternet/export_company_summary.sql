
	SELECT 
		z.id, z.zmluva, concat(z.meno, ' (', z.zmluva, ')') meno, coalesce(f.period, p.period) period, coalesce(f.suma, 0) invoiced, coalesce(p.suma, 0) paid, coalesce(p.suma, 0) - coalesce(f.suma, 0) saldo
	FROM zakaznici z
	left join (select id_zak, date_format(d_fakt, '%Y') as period, sum(suma) suma from yidev.faktury_new group by id_zak, date_format(d_fakt, '%Y') ) as f on f.id_zak = z.id
	left join (select id_customer, date_format(datum_platby, '%Y') as period, sum(suma) suma from yidev.platby_new group by id_customer, date_format(datum_platby, '%Y') ) as p on p.id_customer = z.id
		and p.period = f.period
	where coalesce(f.id_zak, p.id_customer) is not null
		and f.period >= 2020
	order by z.meno, coalesce(f.period, p.period);
    


select * from yidev.platby_new where id_customer in (1712, 1703) or id_customer in (1636, 1636, 1703, 1703, 1832, 1644, 1579, 1701, 886, 1608, 1677, 1676, 1615, 1644, 1748, 1612, 1121, 1559, 1697, 1693, 1678, 1720, 1624, 1818, 1660, 1709, 1719, 529, 1201, 1729, 1684, 1546, 1546, 1678, 1829, 1767, 1596, 1542, 1676, 1705, 693, 1824, 1710, 1667, 1600, 1572, 1592, 1308, 1598, 1631, 1599, 1686, 1675, 1675, 1566, 1659, 960, 10, 154, 450, 572, 1703, 684, 1681, 1652, 885, 1487, 1669, 1651, 1696, 1648, 626, 1611, 1801, 1802, 1826, 1621, 1594, 1711, 1654, 1003, 689, 1610, 1147, 636, 485, 485, 666, 338, 1530, 1699, 1635, 1640, 1547, 399, 1590);
select * from yidev.faktury_new where id_zak in (1712, 1703) or id_zak in (1636, 1636, 1703, 1703, 1832, 1644, 1579, 1701, 886, 1608, 1677, 1676, 1615, 1644, 1748, 1612, 1121, 1559, 1697, 1693, 1678, 1720, 1624, 1818, 1660, 1709, 1719, 529, 1201, 1729, 1684, 1546, 1546, 1678, 1829, 1767, 1596, 1542, 1676, 1705, 693, 1824, 1710, 1667, 1600, 1572, 1592, 1308, 1598, 1631, 1599, 1686, 1675, 1675, 1566, 1659, 960, 10, 154, 450, 572, 1703, 684, 1681, 1652, 885, 1487, 1669, 1651, 1696, 1648, 626, 1611, 1801, 1802, 1826, 1621, 1594, 1711, 1654, 1003, 689, 1610, 1147, 636, 485, 485, 666, 338, 1530, 1699, 1635, 1640, 1547, 399, 1590);
select * from yidev.import_consolidated where vs_from_adhoc_invoice is not null limit 10;
select * from zakaznici where id = 28;
# id	payment_index	payment_date	is_credit	amount	vs	ss	origin	payer_iban	payer_name	detail	payment_id	bank_ref	payer_ref	customer_Id	vs_orig	vs_from_payer	vs_from_typo	vs_from_iban_payer	vs_from_adhoc_invoice
#2648	4	2022-08-18	1	153.00	4118	0	export_SK0702000000002278166653_18-08-2022-18-08-2022.XML	SK7881300000002113210118	ags 92, s.r.o.		5270918496	2292017251281	/VS4118/SS/KS	-1	4118	1108220005			4118


select sum(suma) x, date_format(datum_platby, '%Y') dt from yidev.platby_new where id_customer = 1712 group by date_format(datum_platby, '%Y') order by 2;
