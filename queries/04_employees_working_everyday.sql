-- Q4: Employees who work every day
-- RA: {rozvrh[id_zam, id_sme] ÷ rozvrh[id_sme]}*zamestnanec
select *
from zamestnanec z
where z.id_zam in (
    select id_zam
    from rozvrh
    group by id_zam
    having count(distinct id_sme) = (select count(distinct id_sme) from rozvrh)
);
