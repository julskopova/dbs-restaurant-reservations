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
