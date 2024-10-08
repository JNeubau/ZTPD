-- Joanna Neubauer
-- 2024-10-04
-- Obiektowo-relacyjne bazy danych

-- zad1
CREATE OR REPLACE TYPE Samochod AS OBJECT (
    marka VARCHAR2(50),
    model VARCHAR2(50),
    liczba_kilometrow NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2)
);
/

CREATE TABLE Samochody OF Samochod;

INSERT INTO Samochody VALUES (Samochod('Fiat', 'Brava', 60000, DATE '1999-11-30', 25000));
INSERT INTO Samochody VALUES (Samochod('Ford', 'Mondeo', 80000, DATE '1997-05-10', 45000));
INSERT INTO Samochody VALUES (Samochod('Mazda', '323', 12000, DATE '2000-09-12', 52000));

SELECT * FROM Samochody;


-- zad2
CREATE TABLE Wlasciciele (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100),
    auto Samochod
);

INSERT INTO Wlasciciele VALUES (
    'Jan', 'Kowalski',
    NEW Samochod('Fiat', 'Seicento', 30000, DATE '2010-12-02', 19500)
);

INSERT INTO Wlasciciele VALUES (
    'Adam', 'Nowak',
    NEW Samochod('Opel', 'Astra', 34000, DATE '2009-06-01', 33700)
);

SELECT 
    imie,
    nazwisko,
    w.auto.marka,
    w.auto.model,
    w.auto.liczba_kilometrow,
    w.auto.data_produkcji,
    w.auto.cena
FROM Wlasciciele w;


-- zad3
ALTER TYPE Samochod REPLACE AS OBJECT (
    marka VARCHAR2(50),
    model VARCHAR2(50),
    liczba_kilometrow NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2),
    MEMBER FUNCTION calc_value RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION calc_value RETURN NUMBER IS
        years NUMBER;
        new_val NUMBER;
    BEGIN
        years := FLOOR(MONTHS_BETWEEN(SYSDATE, data_produkcji) / 12);
        new_val := cena * POWER(0.9, years);
        RETURN new_val;
    END;
END;
/

SELECT 
    s.marka,
    s.cena,
    s.calc_value()
FROM 
    Samochody s;


-- zad4
ALTER TYPE Samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION calc_value RETURN NUMBER IS
        years NUMBER;
        new_val NUMBER;
    BEGIN
        years := FLOOR(MONTHS_BETWEEN(SYSDATE, data_produkcji) / 12);
        new_val := cena * POWER(0.9, years);
        RETURN new_val;
    END;

    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, data_produkcji) / 12) + FLOOR(liczba_kilometrow / 10000); -- Example implementation
    END;
END;
/

SELECT 
    s.marka,
    s.model,
    s.liczba_kilometrow,
    s.data_produkcji,
    s.calc_value()
FROM SAMOCHODY s
ORDER BY VALUE(s);


-- zad5
CREATE OR REPLACE TYPE Wlasciciel AS OBJECT (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100),
    auto_r REF Samochod
);
/

CREATE TABLE Wlasciciele_2 OF Wlasciciel;
ALTER TABLE Wlasciciele_2 ADD SCOPE FOR(auto_r) IS SAMOCHODY;

INSERT INTO Wlasciciele_2 VALUES (NEW Wlasciciel('Jan', 'Kowalski', null));
UPDATE Wlasciciele_2 w SET w.auto_r = (
    SELECT REF(s) FROM Samochody s WHERE s.marka = 'Fiat' AND s.model = 'Brava'
);
/

SELECT 
    w.imie,
    w.nazwisko,
    DEREF(w.auto_r).marka AS marka,
    DEREF(w.auto_r).model AS model,
    DEREF(w.auto_r).liczba_kilometrow AS liczba_kilometrow,
    DEREF(w.auto_r).data_produkcji AS data_produkcji,
    DEREF(w.auto_r).cena AS cena
FROM 
    Wlasciciele_2 w;


-- zad6 - pdf
DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    moje_przedmioty.TRIM(2);
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;
/

-- zad7
DECLARE
    TYPE Title IS VARRAY(10) OF VARCHAR(20);
    books Title := Title();
BEGIN
    books.EXTEND();
    books(1) := 'book 1';
    books.EXTEND(books.LIMIT()-books.COUNT(), 1);
    
    DBMS_OUTPUT.PUT_LINE('Start: ');
    FOR i IN 1..books.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(books(i));
    END LOOP;
    
    books.TRIM(2);    
    DBMS_OUTPUT.PUT_LINE('After TRIM: ');
    FOR i IN 1..books.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(books(i));
    END LOOP;

    books(2) := 'book 2';
    books(5) := 'book 5';

    DBMS_OUTPUT.PUT_LINE('After adding elements: ');
    FOR i IN 1..books.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(books(i));
    END LOOP;
END;
/

-- zad8 - pdf
DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.EXTEND(8);

    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.TRIM(2);
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.DELETE(5,7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;
/

-- zad9
DECLARE
    TYPE months_t IS TABLE OF VARCHAR2(20);
    months months_t := months_t();
BEGIN
    months.EXTEND(12);
    months(1) := 'January';
    months(2) := 'February';
    
    FOR i IN months.FIRST()..months.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(months(i));
    END LOOP;
    
    FOR i IN 3..10 LOOP
        months(i) := 'Month ' || i;
    END LOOP;

    FOR i IN months.FIRST()..months.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(months(i));
    END LOOP;

    months.TRIM(5);

    FOR i IN months.FIRST()..months.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(months(i));
    END LOOP;

    months.DELETE(2, 3);

    FOR i IN months.FIRST()..months.LAST() LOOP
        IF months.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(months(i));
        END IF;
    END LOOP;

    months(2) := 'December';
    FOR i IN months.FIRST()..months.LAST() LOOP
        IF months.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(months(i));
        END IF;
    END LOOP;
END;
/

-- zad10 - pdf
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT (
    nazwa VARCHAR2(50),
    kraj VARCHAR2(30),
    jezyki jezyki_obce );
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES
    ('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
    ('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
    SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
    WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
    numer NUMBER,
    egzaminy lista_egzaminow );
/

CREATE TABLE semestry OF semestr
    NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES
    (semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
    (semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));

SELECT s.numer, e.*
    FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.*
    FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
    VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
    SET e.column_value = 'SYSTEMY ROZPROSZONE'
    WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
    WHERE e.column_value = 'BAZY DANYCH';

-- zad11
CREATE TYPE koszyk_t AS TABLE OF varchar2(50);
/

CREATE TABLE Zakupy (
    id NUMBER,
    koszyk_produktow koszyk_t
) NESTED TABLE koszyk_produktow STORE AS KoszykProduktow_Tab;
/

INSERT INTO Zakupy VALUES (
    1, koszyk_t('Chleb', 'Mleko')
);

INSERT INTO Zakupy VALUES (
    2, koszyk_t('Masło', 'Ser')
);

INSERT INTO Zakupy VALUES (
    3, koszyk_t('Chleb', 'Jabłka')
);

SELECT z.id, p.*
FROM Zakupy z, TABLE(z.koszyk_produktow) p;

SELECT p.*
FROM Zakupy z, TABLE(z.koszyk_produktow) p;

DELETE FROM Zakupy z
WHERE EXISTS (
    SELECT 1
    FROM TABLE(z.koszyk_produktow) p
    WHERE p.COLUMN_VALUE = 'Chleb'
);

SELECT z.id, p.*
FROM Zakupy z, TABLE(z.koszyk_produktow) p;

SELECT p.*
FROM Zakupy z, TABLE(z.koszyk_produktow) p;


-- zad12 - pdf
CREATE TYPE instrument AS OBJECT (
    nazwa VARCHAR2(20),
    dzwiek VARCHAR2(20),
    MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
/

CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/

CREATE TYPE instrument_dety UNDER instrument (
    material VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
/

CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: '||dzwiek;
    END;

    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc||':'||dzwiek;
    END;
END;
/

CREATE TYPE instrument_klawiszowy UNDER instrument (
    producent VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
/

CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: '||dzwiek;
    END;
END;
/

DECLARE
    tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
    trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','ping-ping','steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;
/


-- zad13 - pdf
CREATE TYPE istota AS OBJECT (
    nazwa VARCHAR2(20),
    NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
    NOT INSTANTIABLE NOT FINAL;
/

CREATE TYPE lew UNDER istota (
    liczba_nog NUMBER,
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
/

CREATE OR REPLACE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: '||ofiara;
    END;
END;
/

DECLARE
    KrolLew lew := lew('LEW',4);
    -- InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
    DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;
/


-- zad14 - pdf
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn','brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
    trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
    -- saksofon := instrument('saksofon','tra-taaaa');
    -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;
/


-- zad15 - pdf
CREATE TABLE instrumenty OF instrument;

INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','ping-ping','steinway') );

SELECT i.nazwa, i.graj() FROM instrumenty i;