-- Q18: Employees living in Liberec
select z.id_zam, z.jmeno, z.prijmeni
from zamestnanec z
    join adresa a on z.id_zam = a.id_zam where a.mesto = 'Liberec';
    
select id_zam, jmeno, prijmeni
from zamestnanec 
where id_zam in (
    select id_zam
    from adresa a 
    where a.mesto = 'Liberec'
);

select z.id_zam, z.jmeno, z.prijmeni
from zamestnanec z
where exists (
    select 1 
    from adresa a
    where a.id_zam = z.id_zam and a.mesto = 'Liberec'
);
