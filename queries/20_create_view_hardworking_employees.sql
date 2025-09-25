-- Q20: Create view: hardworking employees (>3 times per week)
create or replace view pracovitiZamestnanci as
select z.id_zam, z.jmeno, z.prijmeni
from zamestnanec z
where (select count (r.id_sme) as pocet_smen from rozvrh r where r.id_zam=z.id_zam)>3
;

select * from pracovitiZamestnanci;
