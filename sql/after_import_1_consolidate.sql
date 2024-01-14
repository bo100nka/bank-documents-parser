
###### iban to payer lookup table
	drop table if exists yndev.import_lookup_iban2payer;

	create table yndev.import_lookup_iban2payer as
	select payer_iban, max(payer_name) as payer_name
    from yndev.import_raw
    where payer_iban is not null
    group by payer_iban
    order by 1;
    
    #select * from yndev.import_lookup_iban2payer;

###### payer to vs lookup table
	drop table if exists yndev.import_lookup_payer2vs;

	create table yndev.import_lookup_payer2vs as
	select payer_name, max(vs) as vs
	from yndev.import_raw
	where payer_name is not null
	group by payer_name
	order by 1;

	#select * from yndev.import_lookup_payer2vs;

###### iban_payer to vs
	drop table if exists yndev.import_lookup_ibanpayer2vs;

	create table yndev.import_lookup_ibanpayer2vs as
	select vs,concat(payer_iban,'_',payer_name) as iban_payer
	from yndev.import_raw
	order by 1
    limit 0;

	#                                                    vs             iban + _ + name
	insert into yndev.import_lookup_ibanpayer2vs values (2064,'SK7909000000000251455464_Adriana Tothova');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK4511000000002623730578_ART-INVEST, spol. s r.o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4263,'SK0311000000002943074637_BELLIFER s. r. o.');
	insert into yndev.import_lookup_ibanpayer2vs values (4301,'AT083250100000052530_Blanarik Jan');
	insert into yndev.import_lookup_ibanpayer2vs values (3129,'SK8209000000000037187163_Bozena Galova');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK9311000000002936634739_Dikalova Olena');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'CH7504835049814552002_Duscholux AG');
	insert into yndev.import_lookup_ibanpayer2vs values (9057,'SK6002000000003076784159_Eva Pavelkova');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK4011000000002939351208_Holkovič Peter');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK2311000000008013066785_Holkovičová Katarína, Mgr.');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK8911000000002932475742_Holkovičová Katarína, Mgr.');
	insert into yndev.import_lookup_ibanpayer2vs values (4106,'SK2009000000000252615482_Ján Havel');
	insert into yndev.import_lookup_ibanpayer2vs values (13096,'SK2302000000001825858954_Jan Valla');
	insert into yndev.import_lookup_ibanpayer2vs values (7002,'AT212011182452780000_Jana Labasova');
	insert into yndev.import_lookup_ibanpayer2vs values (10091,'SK1709000000000253660517_Jaroslav Baran');
	insert into yndev.import_lookup_ibanpayer2vs values (2149,'SK5475000000004028522079_KALAY MIROSLAV');
	#insert into yndev.import_lookup_ibanpayer2vs values (14015,'SK6711000000002616088134_Krčová Monika');
	insert into yndev.import_lookup_ibanpayer2vs values (4218,'SK7111110000001286695008_KUNKOVA VIERA');
	insert into yndev.import_lookup_ibanpayer2vs values (1159,'SK1011110000001088680112_LUBICA HLADIKOVA');
	insert into yndev.import_lookup_ibanpayer2vs values (1105,'SK0509000000000250203556_Lubica Stefkova');
	insert into yndev.import_lookup_ibanpayer2vs values (9049,'SK9152000000000019077833_MARIANA KARPITOVA');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK1211000000002619890069_Marko Martin, Ing.');
	insert into yndev.import_lookup_ibanpayer2vs values (13002,'SK5109000000000037200428_Marta Sajdikova');
	insert into yndev.import_lookup_ibanpayer2vs values (4098,'CH6180808005000529814_Martin Dzindzik');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK8302000000001783078158_MGR. FRANTISEK JANKOVIC - SINET');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK8109000000000251536520_Michala Michalkova');
	insert into yndev.import_lookup_ibanpayer2vs values (12011,'BE83967019792915_Nikolaos Baxevanis');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK0956000000003232613002_OBEC BORSKY MIKULAS');
	insert into yndev.import_lookup_ibanpayer2vs values (19022,'SK1875000000004007243740_OLAH LADISLAV');
	insert into yndev.import_lookup_ibanpayer2vs values (1063,'SK0365000000000012546959_Perickova Lucia');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK6802000000004456937457_Peter Jarabek');
	insert into yndev.import_lookup_ibanpayer2vs values (13095,'SK1709000000005028030490_Richard Nejeschleba');
	insert into yndev.import_lookup_ibanpayer2vs values (2200,'SK7109000000000252476048_Roman Jurča');
	insert into yndev.import_lookup_ibanpayer2vs values (1148,'SK4602000000002539150853_Roman Nemečkay');
	insert into yndev.import_lookup_ibanpayer2vs values (13002,'SK1711000000008018331568_Sajdikova Marta');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK9002000000001001018151_SLOVENSKY PLYNARENSKY PRIEMYSEL, A.S.');
	insert into yndev.import_lookup_ibanpayer2vs values (10058,'SK4165000000000095650734_Vacula Peter');
	#insert into yndev.import_lookup_ibanpayer2vs values (999999,'SK7711000000002946082827_Yellow INTERNET, s.r.o.');

	#select * from yndev.import_lookup_ibanpayer2vs;

###### consolidation
	drop table if exists yndev.import_consolidated;

	create table yndev.import_consolidated as

	select 
		r.id
		,r.payment_index
		,r.payment_date
		,r.is_credit
		,r.amount
		,r.vs
		,coalesce(
			case i2v.vs when 0 then null else i2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0) as vs_filled
        ,ip2v.vs as vs_manual
		,r.origin
		,r.payer_iban
		,r.payer_name
        ,i2p.payer_name as payer_name_filled
		,r.detail
		,r.payment_id
		,r.bank_ref
		,r.payer_ref
	#    ,z.*
	from yndev.import_raw as r
    left join yndev.import_lookup_iban2payer as i2p on r.payer_iban = i2p.payer_iban
    left join yndev.import_lookup_payer2vs as i2v on i2p.payer_name = i2v.payer_name
    left join yndev.import_lookup_ibanpayer2vs as ip2v on ip2v.iban_payer = concat(r.payer_iban, '_', i2p.payer_name)
	left join zakaznici as z on z.zmluva = coalesce(
			case i2v.vs when 0 then null else i2v.vs end, 
            case ip2v.vs when 0 then null else ip2v.vs end,
            0)
	where is_credit = 1 #payer_name = 'Barbora Obuchova' #and vs = 0
	order by payment_date
	;

	select payer_iban, payer_name_filled, amount
    ,concat('insert into yndev.import_lookup_ibanpayer2vs values (999999,''', payer_iban, '_', trim(payer_name_filled), ''');') as insert_statement
    from yndev.import_consolidated 
    where vs = 0 and vs_filled = 0 and is_credit = 1 
    group by payer_iban
    order by 2;
