-- Q12: Employees working on Monday (names)
select z.jmeno, z.prijmeni
from (
    select r.id_zam
    from rozvrh r
    join smena s on r.id_sme = s.id_sme
    where s.den_v_tydnu = 'pondělí'
) as zamestnanci_v_pondeli
join zamestnanec z on zamestnanci_v_pondeli.id_zam = z.id_zam;
