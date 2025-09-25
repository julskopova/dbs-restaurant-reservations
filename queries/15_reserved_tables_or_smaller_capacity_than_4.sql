-- Q15: Table numbers: reserved OR capacity > 4
select cislo_stolu
from rezervace
union
select cislo_stolu
from stul
where kapacita > 4;
