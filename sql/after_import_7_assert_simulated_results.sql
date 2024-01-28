
#### assert actual matched payments with invoices against expected payments with invoices (for simulated scenarios only)

	select
		ua.id_zak,un.id_zak
		,case when ua.id_faktura = un.id_faktura then '' else '**' end _id_f
		,case when ua.id_platba = un.id_platba then '' else '**' end _id_p
		,case when ua.suma = un.suma then '' else '**' end _su
		,case when ua.suma_p = un.suma_p then '' else '**' end _sup
		,case when ua.suma_f = un.suma_f then '' else '**' end _suf
		,case when ua.datum = un.datum then '' else '**' end _datum
		,case when ua.balance = un.balance then '' else '**' end _bal
		,case when ua.step_f = un.step_f then '' else '**' end _sf
		,case when ua.step_p = un.step_p then '' else '**' end _sp

		,ua.id_faktura as exp_id_faktura	,un.id_faktura as act_id_faktura
		,ua.id_platba as exp_id_platba	,un.id_platba as act_id_platba
		,ua.suma as exp_suma			,un.suma as act_suma
		,ua.suma_p as exp_suma_p		,un.suma_p as act_suma_p
		,ua.suma_f as exp_suma_f		,un.suma_f as act_suma_f
		,ua.datum as exp_datum			,un.datum as act_datum
		,ua.balance as exp_balance		,un.balance as act_balance
		,ua.step_f as exp_step_f		,un.step_f as act_step_f
		,ua.step_p as exp_step_p		,un.step_p as act_step_p
	from yndev.uhrady_new as un
	right join yndev.uhrady_assert as ua 
		on ua.id_zak = un.id_zak
		and ua.id_faktura = un.id_faktura 
		and ua.id_platba = un.id_platba
	#where ua.id_zak = 102
	order by ua.id_zak; 

