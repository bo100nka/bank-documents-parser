drop procedure if exists yndev.match_payments_to_invoices;

delimiter $$

create procedure yndev.match_payments_to_invoices()
begin


############ create steps table

	drop table if exists yndev.customer_steps;

	create table yndev.customer_steps
	(
		id_zak int primary key,
		step_f int not null,
		step_p int not null,
		steps_f int not null,
		steps_p int not null,
		saldo decimal(8,2) not null
	);

############ create extended invoice_payments

	drop table if exists yndev.uhrady_new;


	create table yndev.uhrady_new like yellownet.uhrady;
	alter table yndev.uhrady_new add suma_p decimal(10,2);
	alter table yndev.uhrady_new add suma_f decimal(10,2);
	alter table yndev.uhrady_new add datum date;
	alter table yndev.uhrady_new add id_zak int;
	alter table yndev.uhrady_new add balance decimal(10,2);
	alter table yndev.uhrady_new add step_f int;
	alter table yndev.uhrady_new add step_p int;

############ init first step one time

	truncate table yndev.uhrady_new;
	truncate table yndev.customer_steps;

	insert into yndev.customer_steps
	select distinct id_zak, 1, 1, 1, 1, 0 
	from yndev.faktury_source
    #where id_zak = 102
    ;

	set @rowcount = row_count();
    
    update yndev.customer_steps as cs
    join (select id_zak, max(step) as step_max from yndev.faktury_source group by id_zak) as f on f.id_zak = cs.id_zak
    set cs.steps_f = f.step_max
    ;
    
    update yndev.customer_steps as cs
    join (select id_customer, max(step) as step_max from yndev.platby_source group by id_customer) as p on p.id_customer = cs.id_zak
    set cs.steps_p = p.step_max
    ;
    
	#select * from yndev.customer_steps;
    #select * from yndev.platby_source

############ loop

	while @rowcount > 0 do

		##### pair payments with invoices for the current step per customer

		insert into yndev.uhrady_new
        
		select 
			null as id, 
			coalesce(f.id, -1) as f_id, 
			coalesce(p.id, -1) as p_id, 

			coalesce(
				case when /*PREVIOUS DEBT*/ cs.saldo < 0 then
					case when /*SUFFICIENT PAY*/ p.suma >= -cs.saldo then -cs.saldo else /*INSUFFICIENT PAYMENT*/ p.suma end
				else 
					case when /*UNSPENT CREDIT*/ cs.saldo > 0 then
						case when /*SUFFICIENT CREDIT*/ cs.saldo >= f.suma then f.suma else /*INSUFFICIENT CREDIT*/ cs.saldo end
					else /*NO PREVIOUS DEBT TO PAY NOR CREDIT TO DRAIN*/
						case when /*SUFFICIENT PAYMENT*/ p.suma >= f.suma then f.suma else /*INSUFFICIENT PAYMENT*/ p.suma end
				end end
			, 0) as suma,
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

	end while;

end$$

delimiter ;