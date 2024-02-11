
############ SPECIFY CUSTOMERS TO PROCESS

	drop table if exists yidev.customers_limit;
    
    create temporary table yidev.customers_limit as
    select distinct id
    from zakaznici
    #where id in (978)
    ;
    
    insert into yidev.customers_limit values (-1);


############ create currency rates

	drop table if exists yidev.currency_rates;

	create table yidev.currency_rates
	(
		dt_start date not null,
		dt_end date not null,
		name varchar(3) not null,
		rate_to_eur decimal(10,7) not null
	);

	insert into yidev.currency_rates values ('1980-01-01', '2008-12-31', 'SKK', 0.0331939);
	insert into yidev.currency_rates values ('2009-01-01', '2030-12-31', 'EUR', 1);

############ create unpaid invoices

	drop table if exists yidev.faktury_unpaid;
    
    create table yidev.faktury_unpaid as
    
	select f.id
	from yidev.faktury_new f
	left join uhrady u on u.id_faktura = f.id
	where u.id is null #and d_fakt >= '20230101'
    ;

############ create unused payments

	drop table if exists yidev.platby_unused;
    
    create table yidev.platby_unused as
    
	select p.id
	from yidev.platby_new p
	left join uhrady u on u.id_platba = p.id
	where u.id is null #and datum_platby >= '20230101'
    ;
    

############ create temp of invoices

	drop table if exists yidev.faktury_source;

	create temporary table yidev.faktury_source as

	SELECT f.id,
		id_zak,
		cislo,
		d_fakt,
		d_splat,
		suma as suma_old,
		round(suma * rate_to_eur, 2) as suma,
		id_sluzby,
		d_platne_do,
		zlava,
		cena_sluzby,
		stav,
		dph,
		cena_bez_dph,
		uhradena
		,row_number() over(partition by id_zak order by case date_format(d_fakt, '%Y') when '2023' then 1 when '2024' then 2 else 3 end, d_fakt) as step 
	from yidev.faktury_new as f
	join yidev.currency_rates on d_fakt between dt_start and dt_end
    join yidev.customers_limit as cl on cl.id = f.id_zak
    join yidev.faktury_unpaid as fu on fu.id = f.id
    order by d_fakt
	;

#select date_format(d_fakt, '%Y'), f.* from yidev.faktury_source f where id_zak = 1527

############ create temp of payments

	drop table if exists yidev.platby_source;

	create temporary table yidev.platby_source as
	select 
		p.id,
		id_customer,
		suma as suma_old,
		round(suma * rate_to_eur, 2) as suma,
		vs,
		ss,
		datum_platby,
		zdroj,
		file,
		day_index,
		popis,
		account,
		bank,
		sender,
		iban
		,row_number() over(partition by id_customer order by datum_platby) as step 
	from yidev.platby_new as p
	join yidev.currency_rates on datum_platby between dt_start and dt_end
    join yidev.customers_limit as cl on cl.id = p.id_customer
    join yidev.platby_unused as pu on pu.id = p.id
    order by datum_platby
	;
