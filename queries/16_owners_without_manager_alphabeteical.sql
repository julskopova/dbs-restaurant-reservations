-- Q16: Owners with no manager (names, alphabetical)
select jmeno
from majitel
except
select  maj.jmeno
from majitel maj
join manazer man on maj.id_maj = man.id_maj
order by jmeno ASC;
