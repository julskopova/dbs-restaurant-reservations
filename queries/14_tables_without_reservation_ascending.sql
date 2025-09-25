-- Q14: Unreserved table numbers (ascending)
select s.cislo_stolu
from stul s
where not exists (
    select 1
    from rezervace r
    where r.cislo_stolu = s.cislo_stolu
)
order by cislo_stolu ASC;
