############ SPECIFY CUSTOMERS TO PROCESS

	drop table if exists yndev.customers_limit;
    
    create temporary table yndev.customers_limit as
    select distinct id
    from zakaznici
    #where id in (978)
    ;


############ create currency rates

	drop table if exists yndev.currency_rates;

	create table yndev.currency_rates
	(
		dt_start date not null,
		dt_end date not null,
		name varchar(3) not null,
		rate_to_eur decimal(10,7) not null
	);

	insert into yndev.currency_rates values ('1980-01-01', '2008-12-31', 'SKK', 0.0331939);
	insert into yndev.currency_rates values ('2009-01-01', '2030-12-31', 'EUR', 1);

############ create temp of invoices

	drop table if exists yndev.faktury_source;

	create temporary table yndev.faktury_source as

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
		,row_number() over(partition by id_zak order by d_fakt) as step 
	from yndev.faktury_new as f
	join yndev.currency_rates on d_fakt between dt_start and dt_end
    join yndev.customers_limit as cl on cl.id = f.id_zak
    order by d_fakt
	;

############ create temp of payments

	drop table if exists yndev.platby_source;

	create temporary table yndev.platby_source as
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
	from yndev.platby_new as p
	join yndev.currency_rates on datum_platby between dt_start and dt_end
    join yndev.customers_limit as cl on cl.id = p.id_customer
	order by datum_platby
	;
