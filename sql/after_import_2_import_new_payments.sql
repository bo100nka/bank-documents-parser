####### new payments table

	drop table if exists yndev.platby_new;

	create table yndev.platby_new as
    
	select 
		ic.id 				as id
		,z.id 				as id_customer
		,ic.amount 			as suma
		,ic.vs 				as vs
		,0 					as ss
		,ic.payment_date 	as datum_platby
		,case when origin like '%.pdf' then 'tatrabanka' else
		 case when origin like 'export_%' then 'banka' else
		 case when origin like 'st1%' then 'posta' else null end end end as zdroj
		,ic.origin			as file
		,ic.payment_index 	as day_index
		,concat(ic.payer_ref, ';', ic.bank_ref, ';', ic.payment_id, ';', ic.detail)	as popis
		,null 				as account
		,null 				as banka
		,ic.payer_name 		as sender
		,ic.payer_iban 		as iban
	from yndev.import_consolidated as ic
	left join zakaznici z on z.zmluva = ic.vs
	#where ic.payment_date between '2022-01-01' and '2022-01-03'
	order by id_customer,suma
	;
