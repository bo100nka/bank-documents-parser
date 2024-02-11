####### new payments table

	drop table if exists yidev.platby_new;
	create table yidev.platby_new like platby;
    
    #select count(*) from yidev.platby_new;
    
    insert into yidev.platby_new
	select 
		 null
		,coalesce(z.id, -1) as id_customer
		,ic.amount 			as suma
		,ic.vs				as vs
		,0					as ss
		,ic.payment_date 	as datum_platby
		,case when origin like '%.pdf' then 'tatrabanka' else
		 case when origin like 'st1%' then 'posta' else null end end as zdroj
		,ic.origin			as file
		,ic.payment_index 	as day_index
		,coalesce(ic.detail, '')	as popis
		,null				as account
		,null				as banka
		,ic.payer_name 		as sender
		,ic.payer_iban 		as iban
	from yidev.import_consolidated as ic
	left join zakaznici z on z.zmluva = ic.vs
    #where z.id = 5904
	order by datum_platby, id_customer, suma
	;
    #select id_customer, count(*) from platby group by id_customer order by 1;
    #select * from platby where id_customer = -1 limit 100;
    #select * from yidev.import_consolidated where amount = 5904.00 order by id desc

####### blacklist existing payments so that they can be replaced

	drop table if exists yidev.platby_blacklist;
    
    create temporary table yidev.platby_blacklist as
	select p.id
	from yidev.platby_new as pn
	join platby as p 
		on p.datum_platby = pn.datum_platby 
        and (p.id_customer = pn.id_customer or p.sender = pn.sender)
		#and p.vs = pn.vs
	#where pn.id_customer = 1214 and pn.datum_platby = '2022-01-04'
	order by p.datum_platby asc
	;

######## insert old payments


	insert into yidev.platby_new
	select null /*p.id*/, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yidev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2020-01-01' and '2021-12-31'
    order by datum_platby
    ;

	insert into yidev.platby_new
	select null /*p.id*/, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yidev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2022-01-01' and '2023-12-31'
    order by datum_platby
    ;

    /*
    
    select *
    from yidev.platby_new
    where #id_customer = 604 and 
    datum_platby >= '2022-01-01';
    
    select *
    from platby
    where id_customer = 1214
    and datum_platby = '2022-01-04';
    
	1214	15.00	0		0	2022-01-04	banka	export_SK0702000000002278166653_04-01-2022-04-01-2022.TXT	0	Valla
41	1214	15.00	13096	0	2022-01-04	banka	export_SK0702000000002278166653_04-01-2022-04-01-2022.XML	1	Valla			Jan Valla	SK2302000000001825858954
		
	select * from yidev.platby_blacklist where id = 84927;


*/