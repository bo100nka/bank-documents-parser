
# call yndev.match_payments_to_invoices();


	truncate table yndev.uhrady_new;
	truncate table yndev.customer_steps;

	insert into yndev.customer_steps
	select distinct id_zak, 1, 1, 1, 1, 0 
	from yndev.faktury_source
    #where id_zak in (107)
    ;
    
    update yndev.customer_steps as cs
    join (select id_zak, max(step) as step_max from yndev.faktury_source group by id_zak) as f on f.id_zak = cs.id_zak
    set cs.steps_f = f.step_max
    ;
    
    update yndev.customer_steps as cs
    join (select id_customer, max(step) as step_max from yndev.platby_source group by id_customer) as p on p.id_customer = cs.id_zak
    set cs.steps_p = p.step_max
    ;
    
    
    
    select * from yndev.faktury_source;
    select * from yndev.platby_source;
    
    select u.*, cs.steps_f, cs.steps_p
    from yndev.uhrady_new as u
    join yndev.customer_steps as cs on cs.id_zak = u.id_zak
    order by u.id_zak, u.step_f, u.step_p;
    
    select id_zak, saldo, step_f, step_p, steps_f, steps_p from yndev.customer_steps;


		# insert into yndev.uhrady_new
		select 
			null as id, 
			coalesce(f.id, -1) as f_id, 
			coalesce(p.id, -1) as p_id, 

			coalesce(
				case when /*PREVIOUS DEBT*/ cs.saldo < 0 then
					case when /*SUFFICIENT PAY*/ p.suma >= -cs.saldo then -cs.saldo else /*INSUFFICIENT PAYMENT*/ p.suma end
				else 
					case when f.id is null then 
						p.suma 
					else
						case when /*UNSPENT CREDIT*/ cs.saldo > 0 then
							case when /*SUFFICIENT CREDIT*/ cs.saldo >= f.suma then f.suma else /*INSUFFICIENT CREDIT*/ cs.saldo end
						else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/
							case when /*SUFFICIENT PAYMENT*/ p.suma >= f.suma then f.suma else /*INSUFFICIENT PAYMENT*/ p.suma end
						end 
					end
				end
			, 0) as suma,
            #case when /*SUFFICIENT PAYMENT*/ p.suma >= f.suma then f.suma else /*INSUFFICIENT PAYMENT*/ p.suma end as test123,
            #case when /*SUFFICIENT CREDIT*/ cs.saldo >= f.suma then f.suma else /*INSUFFICIENT CREDIT*/ cs.saldo end as testxyz,
            #cs.saldo as test444,
			coalesce(p.suma, 0) as suma_p, 
			coalesce(f.suma, 0) as suma_f, 
 			coalesce(p.datum_platby, '1900-01-01') as datum,
			coalesce(f.id_zak, p.id_customer) as id_zak,

			coalesce(
				case when /*PREVIOUS DEBT*/ cs.saldo < 0 then cs.saldo + p.suma
				else 
					case when /*UNSPENT CREDIT*/ cs.saldo > 0 then cs.saldo - f.suma
					else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/ p.suma - f.suma
				end end
				, /*invoice left, no payment left*/ cs.saldo - f.suma
                , /*payment left, no invoice left*/ cs.saldo + p.suma) as balance,
			cs.step_f, 
			cs.step_p
		from yndev.customer_steps as cs
        left join yndev.faktury_source as f on f.id_zak = cs.id_zak and f.step = cs.step_f
		left join yndev.platby_source as p on p.id_customer = cs.id_zak and p.step = cs.step_p
		where coalesce(f.id, p.id) is not null
		order by id_zak, step_f, step_p
		#limit 1
		;
        
        #select * from yndev.customer_steps as c left join yndev.platby_source p on p.id_customer = c.id_zak and p.step = c.step_p;

		#### affected rows
		set @rowcount = row_count();
        
        
        ####### increase invoice/payment step per customer
        
		update yndev.customer_steps as cs
		join yndev.uhrady_new as u on u.id_zak = cs.id_zak
			and cs.step_f = u.step_f 
			and cs.step_p = u.step_p
		set
			 cs.step_f = case when balance >= 0 or (/*got invoices but no payments left*/ u.step_p >= cs.steps_p and u.step_f <= cs.steps_f) then u.step_f + 1 else u.step_f end
			,cs.step_p = case when balance <= 0 or (/*got payments but no invoices left*/ u.step_f >= cs.steps_f and u.step_p <= cs.steps_p) then u.step_p + 1 else u.step_p end
			,saldo = u.balance
		;




select * from yndev.customer_steps;
update yndev.customer_steps set step_f = 4, step_p = 4, saldo = 0;




select * from yndev.customer_balance_detail order by id_zak, step_f, step_p limit 0,40000;
select * from yndev.customer_balance_detail order by id_zak, step_f, step_p limit 40001,40000;
select * from yndev.customer_balance_detail order by id_zak, step_f, step_p limit 80002,40000;

select * from yndev.uhrady_new limit 5;


select * from yndev.customer_balance where id_zak = 1583 order by datum_platby desc;
select * from yndev.customer_balance where meno like '%albrecht%';


select * from yndev.platby_source where id_customer = 978;

select sum(suma) from yndev.platby_source where id_customer = 978;
select 
	sum(case when coalesce(id_customer, -1) = -1 then suma else 0 end) as unmatched_payments_amount
	,sum(case when coalesce(id_customer, -1) = -1 then 0 else suma end) as matched_payments_amount
    , sum(suma) as total_payments_amount  from yndev.platby_source 

;

select id_customer, count(*) from yndev.platby_source group by id_customer order by 1;

