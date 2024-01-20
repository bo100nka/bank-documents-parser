drop procedure if exists yndev.match_payments_to_invoices;

delimiter $$

create procedure yndev.match_payments_to_invoices()
begin

############ assign steps to invoices

	drop table if exists yndev.faktury_steps;
	create temporary table yndev.faktury_steps as
	select f.id_zak, f.d_fakt, f.id, f.cislo, row_number() over(partition by f.id_zak) as step
	from faktury f
	where f.id_zak in (1635,1647)
	order by f.id_zak, f.d_fakt, step;

	#select * from yndev.faktury_steps;

############ assign steps to payments

	drop table if exists yndev.platby_steps;
	create temporary table yndev.platby_steps as
	select p.vs, p.datum_platby, p.id, row_number() over(partition by p.vs) as step
	from yndev.platby_new p
	where p.vs != 0 and p.id_customer in (1635,1647)
	order by p.vs, p.datum_platby, step;

	#select * from yndev.platby_steps;


############ loop

	while @step <= @max_step

		select * from yndev.faktury_steps where step = @step;

		set @step = @step + 1;

	end while;

end$$