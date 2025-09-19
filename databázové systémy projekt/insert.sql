
CREATE OR REPLACE FUNCTION clean_tables() RETURNS void AS
$$
DECLARE
    l_stmt text;
BEGIN
    SELECT 'truncate ' || STRING_AGG(FORMAT('%I.%I', schemaname, tablename), ',')
    INTO l_stmt
    FROM pg_tables
    WHERE schemaname IN ('public');

    EXECUTE l_stmt || ' cascade';
END;
$$ LANGUAGE plpgsql;

SELECT clean_tables();

CREATE OR REPLACE FUNCTION restart_sequences() RETURNS void AS
$$
DECLARE
    i TEXT;
BEGIN
    FOR i IN (SELECT column_default FROM information_schema.columns WHERE column_default SIMILAR TO 'nextval%')
        LOOP
            EXECUTE 'ALTER SEQUENCE' || ' ' || SUBSTRING(SUBSTRING(i FROM '''[a-z_]*') FROM '[a-z_]+') || ' ' ||
                    ' RESTART 1;';
        END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT restart_sequences();

insert into majitel (id_maj, jmeno, datum_narozeni) values
(1, 'Monika Vaňková', '1979-09-24'),
(2, 'Štěpán Jelínek', '1966-02-06'),
(3, 'Alexandr Doležal', '1974-06-13'),
(4, 'Jana Marešová', '1965-08-18'),
(5, 'František Kratochvíl', '1970-04-01');

insert into manazer (id_maj, jmeno, datum_narozeni) values
(1, 'Žaneta Kolářová', '1968-05-04'),
(2, 'Rudolf Dvořák', '1979-01-24'),
(3, 'Dominik Beneš', '2000-05-01'),
(2, 'Martin Musil', '1994-11-24'),
(1, 'Tomáš Jedno', '1989-10-13');

insert into pozice (id_poz, nazev_pozice) values
(1, 'Barman/ka'),
(2, 'Číšník/Servírka'),
(3, 'Kuchař/ka'),
(4, 'Uklízeč/ka');

insert into zamestnanec (id_man, id_poz, jmeno, prijmeni, rodne_cislo, pohlavi) values
(1, 1, 'Karel', 'Marek', 9418585150, 'muz'),
(2, 2, 'Naděžda', 'Mašková', 8055103695, 'žena'),
(3, 3, 'Robert', 'Doležal', 8308766708, 'muž'),
(1, 1, 'Lubomír', 'Blažek', 8103824432, 'muž'),
(2, 2, 'Marie', 'Novotná', 9254766651, 'žena'),
(3, 4,'Richard', 'Vlček', 9731135610, 'muž'),
(1, 1, 'Barbora', 'Machová', 9573867682, 'žena'),
(1, 1,  'Lenka', 'Němcová', 9085034800, 'žena'),
(2, 2, 'Kristýna', 'Pospíšilová', 9296535768, 'žena'),
(2, 2, 'Marek', 'Růžička', 8739859673, 'muž'),
(3, 3, 'Anežka', 'Krejčí', 8681764990, 'žena'),
(3, 4, 'Filip', 'Soukup', 8092659890, 'muž'),
(3, 3, 'Ivana', 'Kratochvílová', 9287486066, 'žena'),
(2, 2, 'Matěj', 'Štěpánek', 8207712682, 'muž'),
(1, 1, 'Zuzana', 'Poláková', 7202184316, 'žena'),
(2, 2, 'Ondřej', 'Kříž', 7730739834, 'muž'),
(3, 4, 'Denisa', 'Urbanová', 8094328182, 'žena'),
(1, 1, 'Matyáš', 'Sedláček', 9209368833, 'muž'),
(3, 1, 'Ludvík', 'Opozdil', 8973455566, 'muž');

insert into smena (den_v_tydnu, typ_smeny) values
('pondělí', 'otevírací'),
('pondělí', 'zavírací'),
('úterý', 'otevírací'),
('úterý', 'zavírací'),
('středa', 'otevírací'),
('středa', 'zavírací'),
('čtvrtek', 'otevírací'),
('čtvrtek', 'zavírací'),
('pátek', 'otevírací'),
('pátek', 'zavírací'),
('sobota', 'otevírací'),
('sobota', 'zavírací'),
('neděle', 'otevírací'),
('neděle', 'zavírací');

insert into stul (kapacita, k_dispozici) values
(4, false),
(4, true),
(2, false),
(6, true),
(4, true),
(4, false),
(4, false),
(8, true),
(4, false);

insert into zakaznik (jmeno) values
('Antonín Dvořák'),
('Julie Skopová'),
('John Reed'),
('Josef Pavlíček'),
('Bedřich Smetana');

insert into rezervace (cislo_stolu, id_zak, id_zam, pocet_lidi) values
(1, 1, 2, 4),
(3, 2, 5, 2),
(6, 3, 9, 4),
(7, 4, 10, 4),
(9, 5, 14, 4);

insert into adresa (id_zam, ulice, cislo, mesto, psc) values
(1, 'Heineho', 29, 'Ostrava', '710 00'),
(2, 'Ke Břvům', 60, 'Ostrava', '702 00'),
(3, 'U Rajské Zahrady', 85, 'Plzeň', '301 00'),
(4, 'Pod Spiritkou', 40, 'Brno', '603 00'),
(5, 'Vítězná', 89, 'Ostrava', '712 00'),
(6, 'Trojská', 56, 'Praha', '120 00'),
(7, 'Zápská', 19, 'Liberec', '460 02'),
(8, 'Třebízského', 76, 'Plzeň', '313 00'),
(9, 'Žitná', 84, 'Praha', '130 00'),
(10, 'Vinohradská', 63, 'Praha', '110 00'),
(11, 'Husitská', 11, 'Liberec', '460 04'),
(12, 'Na Pláni', 22, 'Brno', '617 00'),
(13, 'Krymská', 49, 'Plzeň', '302 00'),
(14, 'Na Valech', 67, 'Praha', '140 00'),
(15, 'K Letišti', 75, 'Ostrava', '711 00'),
(16, 'Vojtěšská', 32, 'Praha', '150 00'),
(17, 'K Zámku', 18, 'Liberec', '460 01'),
(18, 'Na Záhonech', 88, 'Brno', '612 00');

insert into smlouva (id_zam, typ_smlouvy, datum_uzavreni, platnost_do) values
(1, 'HPP', '2021-01-01', '2026-10-17'),
(2, 'DPP', '2023-03-01', '2025-12-31'),
(3, 'DPČ', '2023-05-15', '2026-05-15'),
(4, 'HPP', '2022-06-01', '2025-06-07'),
(5, 'HPP', '2020-10-01', '2027-09-23'),
(6, 'DPP', '2022-11-01', '2025-06-30'),
(7, 'DPČ', '2023-01-10', '2025-12-31'),
(8, 'HPP', '2019-07-01', '2026-11-03'),
(9, 'DPP', '2023-04-15', '2025-10-15'),
(10, 'HPP', '2020-09-01', '2025-08-27'),
(11, 'HPP', '2018-05-20', '2025-02-15'),
(12, 'DPČ', '2021-02-01', '2026-02-01'),
(13, 'DPP', '2023-03-10', '2025-09-10'),
(14, 'HPP', '2023-07-01', '2025-02-03'),
(15, 'DPČ', '2022-10-01', '2025-03-31'),
(16, 'HPP', '2020-06-01', '2025-08-04'),
(17, 'DPP', '2023-08-15', '2026-12-31'),
(18, 'HPP', '2021-03-01', '2026-01-01');

insert into rozvrh (id_sme, id_zam, datum) values
(1, 19, '2024-12-28'),
(1, 5, '2024-12-28'),
(1, 16, '2024-12-28'),
(1, 17, '2024-12-28'),
(2, 19, '2024-12-28'),
(2, 7, '2024-12-28'),
(2, 3, '2024-12-28'),
(2, 6, '2024-12-28'),
(3, 19, '2024-12-29'),
(3, 2, '2024-12-29'),
(3, 6, '2024-12-29'),
(3, 1, '2024-12-29'),
(4, 19, '2024-12-29'),
(4, 9, '2024-12-29'),
(4, 6, '2024-12-29'),
(4, 10, '2024-12-29'),
(5, 19, '2024-12-30'),
(5, 5, '2024-12-30'),
(5, 15, '2024-12-30'),
(5, 1, '2024-12-30'),
(6, 19, '2024-12-30'),
(6, 3, '2024-12-30'),
(6, 6, '2024-12-30'),
(6, 2, '2024-12-30'),
(7, 19, '2024-12-31'),
(7, 17, '2024-12-31'),
(7, 15, '2024-12-31'),
(7, 1, '2024-12-31'),
(8, 19, '2024-12-31'),
(8, 6, '2024-12-31'),
(8, 11, '2024-12-31'),
(8, 2, '2024-12-31'),
(9, 19, '2025-01-01'),
(9, 16, '2025-01-01'),
(9, 14, '2025-01-01'),
(9, 1, '2025-01-01'),
(10, 19, '2025-01-01'),
(10, 7, '2025-01-01'),
(10, 2, '2025-01-01'),
(10, 3, '2025-01-01'),
(11, 19, '2025-01-02'),
(11, 18, '2025-01-02'),
(11, 6, '2025-01-02'),
(11, 2, '2025-01-02'),
(12, 19, '2025-01-02'),
(12, 9, '2025-01-02'),
(12, 4, '2025-01-02'),
(12, 11, '2025-01-02'),
(13, 19, '2025-01-03'),
(13, 5, '2025-01-03'),
(13, 1, '2025-01-03'),
(13, 3, '2025-01-03'),
(14, 19, '2025-01-03'),
(14, 2, '2025-01-03'),
(14, 3, '2025-01-03'),
(14, 6, '2025-01-03');

INSERT INTO platba (id_rez, datum, typ, castka) VALUES
(1, '2024-12-21', 'kartou', 1068),
(2, '2024-12-19', 'hotově', 688),
(3, '2024-12-28', 'kartou', 1000),
(4, '2024-12-18', 'kartou', 1268),
(5, '2024-12-17', 'hotově', 1384);

