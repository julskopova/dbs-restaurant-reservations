-- Q8: All employee–shift combinations
-- RA: zamestnanec[id_zam, jmeno, prijmeni] × smena[den_v_tydnu, typ_smeny]
select z.id_zam, z.jmeno, z.prijmeni, s.den_v_tydnu, s.typ_smeny
from zamestnanec z
cross join smena s;
