-- odeberu pokud existuje funkce na oodebrání tabulek a sekvencí
DROP FUNCTION IF EXISTS remove_all();

-- vytvořím funkci která odebere tabulky a sekvence
-- chcete také umět psát PLSQL? Zapište si předmět BI-SQL ;-)
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- zavolám funkci co odebere tabulky a sekvence - Mohl bych dropnout celé schéma a znovu jej vytvořit, použíjeme však PLSQL
select remove_all();

-- Remove conflicting tables
--DROP TABLE IF EXISTS adresa CASCADE;
--DROP TABLE IF EXISTS majitel CASCADE;
--DROP TABLE IF EXISTS manazer CASCADE;
--DROP TABLE IF EXISTS platba CASCADE;
--DROP TABLE IF EXISTS pozice CASCADE;
--DROP TABLE IF EXISTS rezervace CASCADE;
--DROP TABLE IF EXISTS rozvrh CASCADE;
--DROP TABLE IF EXISTS smena CASCADE;
--DROP TABLE IF EXISTS smlouva CASCADE;
--DROP TABLE IF EXISTS stul CASCADE;
--DROP TABLE IF EXISTS zakaznik CASCADE;
--DROP TABLE IF EXISTS zamestnanec CASCADE;
-- End of removing

CREATE TABLE adresa (
    id_adresa SERIAL NOT NULL,
    id_zam INTEGER NOT NULL,
    ulice VARCHAR(30) NOT NULL,
    cislo INTEGER NOT NULL,
    mesto VARCHAR(30) NOT NULL,
    psc VARCHAR(10) NOT NULL
);
ALTER TABLE adresa ADD CONSTRAINT pk_adresa PRIMARY KEY (id_adresa);

CREATE TABLE majitel (
    id_maj SERIAL NOT NULL,
    jmeno VARCHAR(30) NOT NULL,
    datum_narozeni DATE
);
ALTER TABLE majitel ADD CONSTRAINT pk_majitel PRIMARY KEY (id_maj);

CREATE TABLE manazer (
    id_man SERIAL NOT NULL,
    id_maj INTEGER NOT NULL,
    jmeno VARCHAR(30) NOT NULL,
    datum_narozeni DATE
);
ALTER TABLE manazer ADD CONSTRAINT pk_manazer PRIMARY KEY (id_man);

CREATE TABLE platba (
    id_pla SERIAL NOT NULL,
    id_rez INTEGER NOT NULL,
    datum DATE NOT NULL,
    typ VARCHAR(30) NOT NULL,
    castka INTEGER NOT NULL
);
ALTER TABLE platba ADD CONSTRAINT pk_platba PRIMARY KEY (id_pla);
ALTER TABLE platba ADD CONSTRAINT u_fk_platba_rezervace UNIQUE (id_rez);

CREATE TABLE pozice (
    id_poz SERIAL NOT NULL,
    nazev_pozice VARCHAR(20) NOT NULL
);
ALTER TABLE pozice ADD CONSTRAINT pk_pozice PRIMARY KEY (id_poz);

CREATE TABLE rezervace (
    id_rez SERIAL NOT NULL,
    cislo_stolu INTEGER NOT NULL,
    id_zak INTEGER NOT NULL,
    id_zam INTEGER NOT NULL,
    pocet_lidi INTEGER NOT NULL
);
ALTER TABLE rezervace ADD CONSTRAINT pk_rezervace PRIMARY KEY (id_rez);

CREATE TABLE rozvrh (
    id_roz SERIAL NOT NULL,
    id_sme INTEGER NOT NULL,
    id_zam INTEGER NOT NULL,
    datum DATE NOT NULL
);
ALTER TABLE rozvrh ADD CONSTRAINT pk_rozvrh PRIMARY KEY (id_roz);

CREATE TABLE smena (
    id_sme SERIAL NOT NULL,
    den_v_tydnu VARCHAR(10) NOT NULL,
    typ_smeny VARCHAR(20) NOT NULL
);
ALTER TABLE smena ADD CONSTRAINT pk_smena PRIMARY KEY (id_sme);

CREATE TABLE smlouva (
    id_zam INTEGER NOT NULL,
    typ_smlouvy VARCHAR(10) NOT NULL,
    datum_uzavreni DATE NOT NULL,
    platnost_do DATE NOT NULL
);
ALTER TABLE smlouva ADD CONSTRAINT pk_smlouva PRIMARY KEY (id_zam);

CREATE TABLE stul (
    cislo_stolu SERIAL NOT NULL,
    kapacita INTEGER NOT NULL,
    k_dispozici BOOLEAN NOT NULL
);
ALTER TABLE stul ADD CONSTRAINT pk_stul PRIMARY KEY (cislo_stolu);

CREATE TABLE zakaznik (
    id_zak SERIAL NOT NULL,
    jmeno VARCHAR(30) NOT NULL
);
ALTER TABLE zakaznik ADD CONSTRAINT pk_zakaznik PRIMARY KEY (id_zak);

CREATE TABLE zamestnanec (
    id_zam SERIAL NOT NULL,
    id_man INTEGER NOT NULL,
    id_poz INTEGER NOT NULL,
    jmeno VARCHAR(30) NOT NULL,
    prijmeni VARCHAR(30) NOT NULL,
    rodne_cislo BIGINT NOT NULL,
    pohlavi VARCHAR(10)
);
ALTER TABLE zamestnanec ADD CONSTRAINT pk_zamestnanec PRIMARY KEY (id_zam);
ALTER TABLE zamestnanec ADD CONSTRAINT uc_zamestnanec_rodne_cislo UNIQUE (rodne_cislo);

ALTER TABLE adresa ADD CONSTRAINT fk_adresa_zamestnanec FOREIGN KEY (id_zam) REFERENCES zamestnanec (id_zam) ON DELETE CASCADE;

ALTER TABLE manazer ADD CONSTRAINT fk_manazer_majitel FOREIGN KEY (id_maj) REFERENCES majitel (id_maj) ON DELETE CASCADE;

ALTER TABLE platba ADD CONSTRAINT fk_platba_rezervace FOREIGN KEY (id_rez) REFERENCES rezervace (id_rez) ON DELETE CASCADE;

ALTER TABLE rezervace ADD CONSTRAINT fk_rezervace_stul FOREIGN KEY (cislo_stolu) REFERENCES stul (cislo_stolu) ON DELETE CASCADE;
ALTER TABLE rezervace ADD CONSTRAINT fk_rezervace_zakaznik FOREIGN KEY (id_zak) REFERENCES zakaznik (id_zak) ON DELETE CASCADE;
ALTER TABLE rezervace ADD CONSTRAINT fk_rezervace_zamestnanec FOREIGN KEY (id_zam) REFERENCES zamestnanec (id_zam) ON DELETE CASCADE;

ALTER TABLE rozvrh ADD CONSTRAINT fk_rozvrh_smena FOREIGN KEY (id_sme) REFERENCES smena (id_sme) ON DELETE CASCADE;
ALTER TABLE rozvrh ADD CONSTRAINT fk_rozvrh_zamestnanec FOREIGN KEY (id_zam) REFERENCES zamestnanec (id_zam) ON DELETE CASCADE;

ALTER TABLE smlouva ADD CONSTRAINT fk_smlouva_zamestnanec FOREIGN KEY (id_zam) REFERENCES zamestnanec (id_zam) ON DELETE CASCADE;

ALTER TABLE zamestnanec ADD CONSTRAINT fk_zamestnanec_manazer FOREIGN KEY (id_man) REFERENCES manazer (id_man) ON DELETE CASCADE;
ALTER TABLE zamestnanec ADD CONSTRAINT fk_zamestnanec_pozice FOREIGN KEY (id_poz) REFERENCES pozice (id_poz) ON DELETE CASCADE;

