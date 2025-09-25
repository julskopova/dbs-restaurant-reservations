-- Q11: Cash payments
select r.id_rez, r.cislo_stolu
from rezervace r
where r.id_rez in (
    select p.id_rez
    from platba p
    where p.typ = 'hotově'
);
