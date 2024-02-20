####### new payments table

	drop table if exists yndev.platby_new;
	create table yndev.platby_new like platby;
    
    #select count(*) from yndev.platby_new;
    
    insert into yndev.platby_new
	select 
		 null
		,coalesce(z.id, -1) as id_customer
		,ic.amount 			as suma
		,ic.vs				as vs
		,0					as ss
		,ic.payment_date 	as datum_platby
		,case when origin like '%.pdf' then 'tatrabanka' else
		 case when origin like 'export_%' then 'banka' else
		 case when origin like 'st1%' then 'posta' else null end end end as zdroj
		,ic.origin			as file
		,ic.payment_index 	as day_index
		,coalesce(ic.detail, '')	as popis
		,null				as account
		,null				as banka
		,ic.payer_name 		as sender
		,ic.payer_iban 		as iban
	from yndev.import_consolidated as ic
	left join zakaznici z on z.zmluva = ic.vs
    #where payment_date >= '2023-01-01' #z.id = 5904
	order by datum_platby, id_customer, suma
	;
    #select id_customer, count(*) from platby group by id_customer order by 1;
    #select * from platby where id_customer = -1 limit 100;
    #select * from yndev.import_consolidated where amount = 5904.00 order by id desc

####### blacklist existing payments so that they can be replaced
/*
	drop table if exists yndev.platby_blacklist;
    
    create temporary table yndev.platby_blacklist as
	select p.id
	from yndev.platby_new as pn
	join platby as p 
		on p.datum_platby = pn.datum_platby 
        and (p.id_customer = pn.id_customer or p.sender = pn.sender)
		#and p.vs = pn.vs
	#where pn.id_customer = 1214 and pn.datum_platby = '2022-01-04'
	order by p.datum_platby asc
	;
*/
######## insert old payments
	/*
	insert into yndev.platby_new
	select null  as id, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2001-01-01' and '2010-12-31'
    order by datum_platby
    ;

	insert into yndev.platby_new
	select null  as id, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2011-01-01' and '2015-12-31'
    order by datum_platby
    ;

	insert into yndev.platby_new
	select null  as id, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2016-01-01' and '2017-12-31'
    order by datum_platby
    ;

	insert into yndev.platby_new
	select null  as id, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2018-01-01' and '2019-12-31'
    order by datum_platby
    ;

	insert into yndev.platby_new
	select null  as id, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2020-01-01' and '2021-12-31'
    order by datum_platby
    ;
*/
/*
	#insert into yndev.platby_new
	select null  as id/*, p.id_customer, p.suma, p.vs, p.ss, p.datum_platby, p.zdroj, p.file, p.day_index, p.popis, p.account, p.bank, p.sender, p.iban
	from platby as p
    left join yndev.platby_blacklist as pb on pb.id = p.id
    where pb.id is null and datum_platby between '2022-01-01' and '2023-12-31'
    order by datum_platby
    ;
  */  
    /*
    
    select *
    from yndev.platby_new
    where #id_customer = 604 and 
    datum_platby >= '2022-01-01';
    
    select *
    from platby
    where id_customer = 1214
    and datum_platby = '2022-01-04';
    
	1214	15.00	0		0	2022-01-04	banka	export_SK0702000000002278166653_04-01-2022-04-01-2022.TXT	0	Valla
41	1214	15.00	13096	0	2022-01-04	banka	export_SK0702000000002278166653_04-01-2022-04-01-2022.XML	1	Valla			Jan Valla	SK2302000000001825858954
		
	select * from yndev.platby_blacklist where id = 84927;


*/