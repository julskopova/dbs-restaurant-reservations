-- Q1: employees with HPP contract
-- RA: {zamestnanec <* smlouva(typ_smlouvy='HPP')}[jmeno, prijmeni]
select zamestnanec.jmeno, zamestnanec.prijmeni
from zamestnanec
join smlouva on zamestnanec.id_zam = smlouva.id_zam
where smlouva.typ_smlouvy = 'HPP';
