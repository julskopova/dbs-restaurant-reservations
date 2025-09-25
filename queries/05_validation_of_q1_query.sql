-- Q5: Validation of Q1 query
-- RA: rozvrh[id_sme] \ rozvrh(id_zam='19')[id_sme]
select id_sme
from rozvrh

except

select id_sme
from rozvrh z join zamestnanec using(id_zam)
where id_zam = 19;
