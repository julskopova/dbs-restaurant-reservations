-- Q3: Employees who work only as bartenders (names)
-- RA: {
-- {zamestnanec <* pozice(nazev_pozice='Barman/ka')} \ 
-- {zamestnanec <* pozice(nazev_pozice!='Barman/ka')}
-- }
-- [jmeno, prijmeni]
select z.jmeno, z.prijmeni
from zamestnanec z
where z.id_zam in (
    select z1.id_zam
    from zamestnanec z1
    join pozice p1 on z1.id_poz = p1.id_poz
    where p1.nazev_pozice = 'Barman/ka'
)
and z.id_zam not in (
    select z2.id_zam
    from zamestnanec z2
    join pozice p2 on z2.id_poz = p2.id_poz
    where p2.nazev_pozice != 'Barman/ka'
);
