-- Q13: Shifts per employee (id, name, surname, total shifts)
select z.id_zam, z.jmeno, z.prijmeni, 
       (select count(*) 
        from rozvrh r 
        where r.id_zam = z.id_zam) as pocet_smen
from zamestnanec z;
