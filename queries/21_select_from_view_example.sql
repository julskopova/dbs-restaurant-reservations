-- Q21: Select from view: hardworking employees (all columns)
select *
from zamestnanec z
where exists (select 1 from pracovitiZamestnanci p where p.id_zam = z.id_zam);
