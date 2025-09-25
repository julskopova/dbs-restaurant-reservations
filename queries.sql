-- Q1: employees with HPP contract
-- RA: {zamestnanec <* smlouva(typ_smlouvy='HPP')}[jmeno, prijmeni]
select zamestnanec.jmeno, zamestnanec.prijmeni
from zamestnanec
join smlouva on zamestnanec.id_zam = smlouva.id_zam
where smlouva.typ_smlouvy = 'HPP';


-- =============================================================================================


-- Q2: Owners with no assigned manager 
-- RA: majitel[id_maj] !<* manazer[id_maj] * majitel
select *
from majitel
where id_maj not in (
    select id_maj
    from manazer
);


-- =============================================================================================


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


-- =============================================================================================


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


-- =============================================================================================


-- Q5: Validation of D1 query
-- RA: rozvrh[id_sme] \ rozvrh(id_zam='19')[id_sme]
select id_sme
from rozvrh

except

select id_sme
from rozvrh z join zamestnanec using(id_zam)
where id_zam = 19;


-- =============================================================================================


-- Q6: Payments and reservations paid by card (all columns)
-- RA: rezervace *> platba(typ='kartou')
select p.id_pla, r.id_rez, p.datum, p.typ, p.castka
from rezervace r
join platba p on r.id_rez = p.id_rez
where p.typ = 'kartou';


-- =============================================================================================


-- Q7: Reserved tables (all columns)
-- RA: rezervace *> stul
select distinct s.*
from stul s
natural join rezervace r;


-- =============================================================================================


-- Q8: All employee–shift combinations
-- RA: zamestnanec[id_zam, jmeno, prijmeni] × smena[den_v_tydnu, typ_smeny]
select z.id_zam, z.jmeno, z.prijmeni, s.den_v_tydnu, s.typ_smeny
from zamestnanec z
cross join smena s;


-- =============================================================================================


-- Q9: Tables without any reservation (number & capacity)
-- RA: stul[cislo_stolu, kapacita, k_dispozici]!<*rezervace
select s.cislo_stolu, s.kapacita, s.k_dispozici
from rezervace r
right join stul s on s.cislo_stolu = r.cislo_stolu
where r.id_rez is null;


-- =============================================================================================


-- Q10: Managers and owners incl. owners without a manager
select man.jmeno as manazer_jmeno, man.id_man, maj.jmeno as majitel_jmeno, maj.id_maj
from manazer man
full outer join majitel maj on man.id_maj = maj.id_maj;


-- =============================================================================================


-- Q11: Cash payments
select r.id_rez, r.cislo_stolu
from rezervace r
where r.id_rez in (
    select p.id_rez
    from platba p
    where p.typ = 'hotově'
);


-- =============================================================================================


-- Q12: Employees working on Monday (names)
select z.jmeno, z.prijmeni
from (
    select r.id_zam
    from rozvrh r
    join smena s on r.id_sme = s.id_sme
    where s.den_v_tydnu = 'pondělí'
) as zamestnanci_v_pondeli
join zamestnanec z on zamestnanci_v_pondeli.id_zam = z.id_zam;


-- =============================================================================================


-- Q13: Shifts per employee (id, name, surname, total shifts)
select z.id_zam, z.jmeno, z.prijmeni, 
       (select count(*) 
        from rozvrh r 
        where r.id_zam = z.id_zam) as pocet_smen
from zamestnanec z;


-- =============================================================================================


-- Q14: Unreserved table numbers (ascending)
select s.cislo_stolu
from stul s
where not exists (
    select 1
    from rezervace r
    where r.cislo_stolu = s.cislo_stolu
)
order by cislo_stolu ASC;


-- =============================================================================================


-- Q15: Table numbers: reserved OR capacity > 4
select cislo_stolu
from rezervace
union
select cislo_stolu
from stul
where kapacita > 4;


-- =============================================================================================


-- Q16: Owners with no manager (names, alphabetical)
select jmeno
from majitel
except
select  maj.jmeno
from majitel maj
join manazer man on maj.id_maj = man.id_maj
order by jmeno ASC;


-- =============================================================================================


-- Q17: Employees working as cleaners
select id_zam, jmeno, prijmeni from zamestnanec where id_zam in (
    select id_zam from zamestnanec
    intersect
    select z.id_zam from zamestnanec z where z.id_poz = (
        select p.id_poz from pozice p where p.nazev_pozice = 'Uklízeč/ka'
    )
);


-- =============================================================================================


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


-- =============================================================================================


-- Q19: Female employees with ≥2 shifts (names + count, desc)
select z.jmeno, z.prijmeni, count(r.id_sme) as pocet_smen
from zamestnanec z 
join rozvrh r on z.id_zam = r.id_zam
where pohlavi = 'žena'
group by z.id_zam, z.jmeno, z.prijmeni
having count(r.id_sme) > 1
order by pocet_smen desc;


-- =============================================================================================


-- Q20: Create view: hardworking employees (>3 times per week)
create or replace view pracovitiZamestnanci as
select z.id_zam, z.jmeno, z.prijmeni
from zamestnanec z
where (select count (r.id_sme) as pocet_smen from rozvrh r where r.id_zam=z.id_zam)>3
;

select * from pracovitiZamestnanci;


-- =============================================================================================


-- Q21: Select from view: hardworking employees (all columns)
select *
from zamestnanec z
where exists (select 1 from pracovitiZamestnanci p where p.id_zam = z.id_zam);


-- =============================================================================================


-- Q22: Delete employees present in the hardworking view
begin;
select count (id_zam)
from pracovitiZamestnanci;
delete
    from zamestnanec
    where id_zam in (select id_zam from pracovitiZamestnanci);
select count (id_zam)
from pracovitiZamestnanci;
rollback;


-- =============================================================================================


-- Q23: Insert random reservation (random customer/table/people, current timestamp)
begin;
select count(*)
from rezervace;

insert into rezervace (cislo_stolu, id_zak, id_zam, pocet_lidi)
select 
    cislo_stolu,
    id_zak,
    id_zam,
    floor(random() * 6 + 1)::integer
from (
    select s.cislo_stolu, z.id_zak, zam.id_zam
    from stul s
    cross join zakaznik z
    cross join zamestnanec zam
) vstup
order by random()
limit 5;

select count(*)
from rezervace;

rollback;


-- =============================================================================================


-- Q24: Transaction: decrease card payments by 200
begin;
select *
from platba
where typ = 'kartou';

update platba
set castka = castka - 200
where id_pla in (
    select id_pla
    from platba
    where typ = 'kartou'
);

select *
from platba
where typ = 'kartou';

rollback;


