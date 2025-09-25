-- Q17: Employees working as cleaners
select id_zam, jmeno, prijmeni from zamestnanec where id_zam in (
    select id_zam from zamestnanec
    intersect
    select z.id_zam from zamestnanec z where z.id_poz = (
        select p.id_poz from pozice p where p.nazev_pozice = 'Uklízeč/ka'
    )
);
