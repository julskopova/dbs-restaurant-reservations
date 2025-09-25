-- Q19: Female employees with ≥2 shifts (names + count, desc)
select z.jmeno, z.prijmeni, count(r.id_sme) as pocet_smen
from zamestnanec z 
join rozvrh r on z.id_zam = r.id_zam
where pohlavi = 'žena'
group by z.id_zam, z.jmeno, z.prijmeni
having count(r.id_sme) > 1
order by pocet_smen desc;
