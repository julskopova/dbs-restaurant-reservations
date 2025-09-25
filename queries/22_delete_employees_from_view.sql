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
