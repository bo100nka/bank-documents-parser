drop table if exists faktury_max;

create table faktury_max as
select id_zak, max(d_fakt) d_fakt_max
from (select id,id_zak,max(id_sluzby) id_sluzby, max(d_fakt) d_fakt from faktury as f group by id,id_zak) f
group by id_zak;


select
	z.id as zak_id,
    z.zmluva,
	z.meno, 
    z.c_op,
    z.psc,
    coalesce(case z.install_obec when '' then null else z.install_obec end, z.obec) as obec, 
    z.ulica,
    z.stat,
    z.koresp_meno,
    z.koresp_ulica,
    z.koresp_stat,
    z.koresp_psc,
    z.telefon,
    z.email,
    z.ico,
    z.icdph,
    s.popis,
    s.rychlost as rychlost_Mbit,
    f.id as posledna_faktura_id,
    f.d_fakt as posledna_faktura_datum
from zakaznici z
left join (
	select f.id_zak,max(f.id) id,max(f.id_sluzby) id_sluzby, max(f.d_fakt) d_fakt 
    from faktury as f 
    #where f.id_zak = 1416
    group by f.id_zak 
    ) f on f.id_zak = z.id
inner join faktury_max as mx on mx.id_zak = f.id_zak and mx.d_fakt_max = f.d_fakt
left join sluzby as s on s.id = f.id_sluzby
#where meno like '%byt%'
order by f.d_fakt desc
;
