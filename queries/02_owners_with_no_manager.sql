-- Q2: Owners with no assigned manager 
-- RA: majitel[id_maj] !<* manazer[id_maj] * majitel
select *
from majitel
where id_maj not in (
    select id_maj
    from manazer
);
