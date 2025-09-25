-- Q10: Managers and owners incl. owners without a manager
select man.jmeno as manazer_jmeno, man.id_man, maj.jmeno as majitel_jmeno, maj.id_maj
from manazer man
full outer join majitel maj on man.id_maj = maj.id_maj;
