-- Q23: Insert random reservation (random customer/table/people, current timestamp)
begin;
select count(*)
from rezervace;

insert into rezervace (cislo_stolu, id_zak, id_zam, pocet_lidi)
select 
    cislo_stolu,
    id_zak,
    id_zam,
    floor(random() * 6 + 1)::integer
from (
    select s.cislo_stolu, z.id_zak, zam.id_zam
    from stul s
    cross join zakaznik z
    cross join zamestnanec zam
) vstup
order by random()
limit 5;

select count(*)
from rezervace;

rollback;
