
###### iban to payer lookup table
	drop table if exists yidev.import_lookup_iban2payer;

	create temporary table yidev.import_lookup_iban2payer as
	select payer_iban, max(payer_name) as payer_name
    from yidev.import_raw
    where payer_iban is not null
    group by payer_iban
    order by 1;
    
    #select * from yidev.import_lookup_iban2payer;

###### payer to vs lookup table
	drop table if exists yidev.import_lookup_payer2vs;

	create temporary table yidev.import_lookup_payer2vs as
	select payer_name, max(vs) as vs
	from yidev.import_raw
	where payer_name is not null
	group by payer_name
	order by 1;

	#select * from yidev.import_lookup_payer2vs;

###### vs to adhoc invoice lookup table
	drop table if exists yidev.import_lookup_vs2adhoc;
    
    create temporary table yidev.import_lookup_vs2adhoc as
    select cast(vs as unsigned) as vs, payer_name, bank_ref as invoice_id, payment_date as invoice_date, cast(null as signed) amount_id, amount
    from yidev.import_raw
    order by 1
    limit 0;
    
    # insert statements below generated from the "payments_wrong_vs" google sheets document located on the shared yellownet google drive folder
    
	#insert into yidev.import_lookup_vs2adhoc values (4118,'AGS 92, s.r.o. (4118)', '011022/357', '2022-11-01', null, 153);



	
    # select * from yidev.import_lookup_vs2adhoc where vs = 1108220005
    # select vs, count(*) from yidev.import_lookup_vs2adhoc group by vs having count(*) > 1

###### iban_payer to vs
	drop table if exists yidev.import_lookup_ibanpayer2vs;

	create temporary table yidev.import_lookup_ibanpayer2vs as
	select vs,concat(payer_iban,'_',payer_name) as iban_payer
	from yidev.import_raw
	order by 1
    limit 0;

	insert into yidev.import_lookup_ibanpayer2vs values (9045, '_ANNA ONDRASKOVA');
	insert into yidev.import_lookup_ibanpayer2vs values (3353, '_Anton Suchanek');
	insert into yidev.import_lookup_ibanpayer2vs values (813040, '_JOZEF REHAK');
	insert into yidev.import_lookup_ibanpayer2vs values (8009, '_Jozef Spurny');
	insert into yidev.import_lookup_ibanpayer2vs values (814036, '_PETER CULEN');
	insert into yidev.import_lookup_ibanpayer2vs values (2089, '_PETER Pokryvka');
	insert into yidev.import_lookup_ibanpayer2vs values (822000, 'AT302011183960503800_Miroslav Nestarec');
	#insert into yidev.import_lookup_ibanpayer2vs values (-1, 'AT501400006210018610_Jaroslav Jaroska');
	insert into yidev.import_lookup_ibanpayer2vs values (2174, 'CZ3462106701002209845847_NADEZDA MICHALCOVA');
	insert into yidev.import_lookup_ibanpayer2vs values (2023, 'LT413250047420214440_Jan Sloboda');
	insert into yidev.import_lookup_ibanpayer2vs values (801034, 'SK1356000000002713001002_ORSAG PETER');
	insert into yidev.import_lookup_ibanpayer2vs values (804014, 'SK1502000000002402981453_Pediater, s.r.o.');
	insert into yidev.import_lookup_ibanpayer2vs values (815003, 'SK1709000000000037052824_Stanislav Holoďák');
	insert into yidev.import_lookup_ibanpayer2vs values (801028, 'SK2383200000003220227251_Krist?na ?ern?');
	insert into yidev.import_lookup_ibanpayer2vs values (801028, 'SK2383200000003220227251_Kristína Černá');
	insert into yidev.import_lookup_ibanpayer2vs values (815011, 'SK2502000000002545655954_Branislav Krcha');
	insert into yidev.import_lookup_ibanpayer2vs values (819016, 'SK2565000000000015853778_Jonasova Anna');
	insert into yidev.import_lookup_ibanpayer2vs values (-1, 'SK2611000000002947133382_Martin Malík');
	insert into yidev.import_lookup_ibanpayer2vs values (819015, 'SK2765000000000012448945_Svatikova Zdenka');
	insert into yidev.import_lookup_ibanpayer2vs values (2060, 'SK2909000000000252370104_Maria Olsovska');
	insert into yidev.import_lookup_ibanpayer2vs values (820007, 'SK3609000000000281761948_Andrea Knoblochova');
	insert into yidev.import_lookup_ibanpayer2vs values (10071, 'SK3811000000002910876991_Hladká Jana');
	insert into yidev.import_lookup_ibanpayer2vs values (804031, 'SK4311000000008018219744_Flajžík Branislav');
	insert into yidev.import_lookup_ibanpayer2vs values (814029, 'SK4565000000000017273013_Hutova Elena');
	insert into yidev.import_lookup_ibanpayer2vs values (804011, 'SK5583300000007711771188_FERnet SK s. r. o.');
	insert into yidev.import_lookup_ibanpayer2vs values (9022, 'SK5809000000000252026784_Andrea Zakova');
	insert into yidev.import_lookup_ibanpayer2vs values (815000, 'SK5811110000001273304004_Mednansky Andrej');
	insert into yidev.import_lookup_ibanpayer2vs values (818000, 'SK6056000000005221923004_KOVAC JURAJ');
	insert into yidev.import_lookup_ibanpayer2vs values (2139, 'SK6156000000002597581002_HOLUBOVA SYLVIA');
	insert into yidev.import_lookup_ibanpayer2vs values (819017, 'SK6711110000006842585129_PAVOL TULAK');
	insert into yidev.import_lookup_ibanpayer2vs values (-1, 'SK6902000020140015805012_SLOVENSKÁ POŠTA, A.S.');
	insert into yidev.import_lookup_ibanpayer2vs values (809001, 'SK7109000000000037024110_Peter Surový');
	insert into yidev.import_lookup_ibanpayer2vs values (801031, 'SK7109000000005185672948_Denisa Pacalajová');
	insert into yidev.import_lookup_ibanpayer2vs values (801006, 'SK7175000000004012736187_SKURKA DUSAN');
	insert into yidev.import_lookup_ibanpayer2vs values (817000, 'SK7275000000004008237115_RAVAS LUDOVIT');
	insert into yidev.import_lookup_ibanpayer2vs values (813020, 'SK7411000000002910985565_Gavorníková Nela, In');
	insert into yidev.import_lookup_ibanpayer2vs values (813020, 'SK7411000000002910985565_Michálková Nela');
	insert into yidev.import_lookup_ibanpayer2vs values (813042, 'SK7611000000002612478602_Bučko Martin');
	insert into yidev.import_lookup_ibanpayer2vs values (818000, 'SK7611110000001184881002_KOVAC JURAJ');
	insert into yidev.import_lookup_ibanpayer2vs values (810003, 'SK8209000000000037043215_Jaroslava Vrablecova');
	insert into yidev.import_lookup_ibanpayer2vs values (2174, 'SK9709000000005129462532_Rene Keves');
	insert into yidev.import_lookup_ibanpayer2vs values (818001, 'SK9709000000005176307906_Renáta Tomšejová');
	insert into yidev.import_lookup_ibanpayer2vs values (-1, 'SK8911000000002932475742_Holkovičová Katarína, Mgr.');
	insert into yidev.import_lookup_ibanpayer2vs values (-1, 'AT501400006210018610_Jaroslav Jaroska');
    insert into yidev.import_lookup_ibanpayer2vs values (818001, 'SK9456000000004670962004_TOMSEJOVA RENATA');
    insert into yidev.import_lookup_ibanpayer2vs values (801006, 'SK7175000000004012736187_Dusan Skurka');
    insert into yidev.import_lookup_ibanpayer2vs values (3146, 'SK8509000000005051109252_Tibor Malík');
    
	# from payments with missing vs
	#                                                    vs             iban + _ + name
	#insert into yidev.import_lookup_ibanpayer2vs values (2064,'SK7909000000000251455464_Adriana Tothova');
	#insert into yidev.import_lookup_ibanpayer2vs values (-1,'SK4511000000002623730578_ART-INVEST, spol. s r.o.');

	# from payments with wrong vs
	#                                                    vs             iban + _ + name
	#insert into yidev.import_lookup_ibanpayer2vs values (9058, 'SK4402000000002874771956_ADIC SK, S.R.O.');
	#insert into yidev.import_lookup_ibanpayer2vs values (-1, 'SK5111000000002948142993_BRIGHT INVESTMENT GROUP s.r.o.');

	#select iban_payer, count(*) cnt from yidev.import_lookup_ibanpayer2vs group by iban_payer having cnt > 1;

###### replace vs

	drop table if exists yidev.import_lookup_pv2vs;
    
    create temporary table yidev.import_lookup_pv2vs as
    select payer_name, vs, vs as vs_new
    from yidev.import_raw
    limit 0;
    
    #insert into yidev.import_lookup_pv2vs values ('Čech Jozef', 4149, 4194);
    
###### consolidation
	drop table if exists yidev.import_consolidated;

	create table yidev.import_consolidated as

	select 
		r.id
		,r.payment_index
		,r.payment_date
		,r.is_credit
		,r.amount
		,coalesce(
			case vs2a.vs when 0 then null else vs2a.vs end, # ignored due to adhoc invoice reference
            case ip2v.vs when 0 then null else ip2v.vs end, # ignored due to blacklisted payer
            case pv2v.vs_new when 0 then null else pv2v.vs_new end, # manually corrected typo
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0) as vs
		,r.ss
        ,r.origin
		,r.payer_iban
        ,coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) as payer_name
		,r.detail
		,r.payment_id
		,r.bank_ref
		,r.payer_ref
        ,coalesce(z.id, case ip2v.vs when -1 then -1 end, case when vs2a.invoice_id is not null then -1 end) as customer_Id
        ,r.vs as vs_orig
        ,p2v.vs as vs_from_payer
        ,pv2v.vs_new as vs_from_typo
        ,ip2v.vs as vs_from_iban_payer
        ,vs2a.vs as vs_from_adhoc_invoice
	from yidev.import_raw as r
    left join yidev.import_lookup_iban2payer as i2p on r.payer_iban = i2p.payer_iban
    left join yidev.import_lookup_payer2vs as p2v on i2p.payer_name = p2v.payer_name
    left join yidev.import_lookup_ibanpayer2vs as ip2v on ip2v.iban_payer = concat(coalesce(r.payer_iban, ''), '_', coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name))
    left join yidev.import_lookup_pv2vs as pv2v on pv2v.vs = r.vs and pv2v.payer_name = coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name)
    left join yidev.import_lookup_vs2adhoc as vs2a on coalesce(vs2a.amount_id, r.amount) = r.amount and vs2a.vs = coalesce(
			case pv2v.vs_new when 0 then null else pv2v.vs_new end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0)
	left join zakaznici as z on z.zmluva = coalesce(
			case when vs2a.invoice_id is not null then -1 else null end, # this will not join customers with payments where vs is pointing to existing adhoc invoices
            case ip2v.vs when 0 then null else ip2v.vs end,
			case pv2v.vs_new when 0 then null else pv2v.vs_new end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0)
	where is_credit = 1 #and coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) like '%kapsa%'
    and r.payment_date >= '2023-01-01'
order by payer_name, payment_date
	;

	insert into yidev.import_consolidated
    select 
		r.id
		,r.payment_index
		,r.payment_date
		,r.is_credit
		,r.amount
		,r.vs
		,r.ss
        ,r.origin
		,r.payer_iban
        ,r.payer_name
		,r.detail
		,r.payment_id
		,r.bank_ref
		,r.payer_ref
        ,-1 as customer_Id
        ,r.vs as vs_orig
        ,r.vs as vs_from_payer
        ,r.vs as vs_from_typo
        ,r.vs as vs_from_iban_payer
        ,r.vs as vs_from_adhoc_invoice
	from yidev.import_raw as r
	where is_credit = 0 and origin like 'st1%'
    ;



	# payments with missing vs after consolidated
	select * 
    from yidev.import_consolidated 
    where (vs = 0 or customer_id is null) and is_credit = 1 
    order by payer_name, payment_date;

	# payments with ignored customer_id after consolidated
	select * 
    from yidev.import_consolidated 
    where customer_id = -1 and is_credit = 1 
    order by payer_name, payment_date;

	# payments with missing vs or missing customer after consolidation
	select ic.payer_iban, coalesce(ic.payer_name, ''), ic.amount, ic.vs
    ,concat('insert into yidev.import_lookup_ibanpayer2vs values (-1, ''', coalesce(ic.payer_iban, ''), '_', trim(coalesce(ic.payer_name, '')), ''');') as insert_statement
    from yidev.import_consolidated ic
    where (ic.vs = 0 or ic.customer_id is null) and ic.is_credit = 1 
    group by ic.payer_iban, ic.payer_name
    order by 2;

/*

select id,count(*) from yidev.import_consolidated group by id having count(*) > 1 order by 2 desc;
select id,count(*) from yidev.import_raw group by id having count(*) > 1 order by 2 desc;
select * from yidev.import_consolidated where id in (1681,2214);
select * from yidev.import_consolidated where coalesce(payer_name, payer_iban) is null

select * from yidev.import_raw where payment_id in (4922629471,5315643391,5918366729,5980750398,6111308683,6146555296)


select * from zakaznici where id = 2024

	select *
	from yidev.import_raw as r
    left join yidev.import_lookup_iban2payer as i2p on r.payer_iban = i2p.payer_iban
    left join yidev.import_lookup_payer2vs as p2v on i2p.payer_name = p2v.payer_name
    left join yidev.import_lookup_ibanpayer2vs as ip2v on ip2v.iban_payer = concat(r.payer_iban, '_', coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name))
    left join yidev.import_lookup_vs2adhoc as vs2a on vs2a.vs = coalesce(
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0)
	left join zakaznici as z on z.zmluva = coalesce(
			case when vs2a.invoice_id is not null then -1 else null end, # this will not join customers with payments where vs is pointing to existing adhoc invoices
            case ip2v.vs when 0 then null else ip2v.vs end,
			case r.vs when 0 then null else r.vs end,
			case p2v.vs when 0 then null else p2v.vs end, 
            0)
	where is_credit = 1 and r.id = 1681 #coalesce(case r.payer_name when '' then null else r.payer_name end, i2p.payer_name) like '%kapsa%'
    order by r.payer_name, r.id
;

select * from yidev.platby_new where datum_platby = '2022-01-10' and sender like '%matomi%';
select * from yidev.import_raw left join zakaznici on zmluva = vs where payment_date = '2022-01-10' and payer_name like '%matomi%';
select ic.*, z.id customer_id, z.meno from yidev.import_consolidated as ic left join zakaznici as z on zmluva = vs where payment_date = '2022-01-05' and amount = 10;

select * from zakaznici where zmluva = 4194;
select * from zakaznici where id = 1083;
select * from yidev.faktury_source where id_zak = 964;

select * from yidev.uhrady_new where id_zak = 964;

select * from yidev.import_consolidated where is_credit = 0;
select * from yidev.import_raw where is_credit = 0 and origin like 'st1%';
*/
