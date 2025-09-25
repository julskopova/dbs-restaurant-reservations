-- Q7: Reserved tables (all columns)
-- RA: rezervace *> stul
select distinct s.*
from stul s
natural join rezervace r;
