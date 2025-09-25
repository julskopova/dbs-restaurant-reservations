-- Q9: Tables without any reservation (number & capacity)
-- RA: stul[cislo_stolu, kapacita, k_dispozici]!<*rezervace
select s.cislo_stolu, s.kapacita, s.k_dispozici
from rezervace r
right join stul s on s.cislo_stolu = r.cislo_stolu
where r.id_rez is null;
