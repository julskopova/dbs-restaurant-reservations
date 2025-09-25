-- Q6: Payments and reservations paid by card (all columns)
-- RA: rezervace *> platba(typ='kartou')
select p.id_pla, r.id_rez, p.datum, p.typ, p.castka
from rezervace r
join platba p on r.id_rez = p.id_rez
where p.typ = 'kartou';
