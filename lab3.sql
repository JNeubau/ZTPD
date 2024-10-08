-- Joanna Neubauer
-- 2024-10-18
-- Duze Obiekty Tekstowe (CLOB)

-- zad1
CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

-- zad2
DECLARE
    tmp_text CLOB;
    
BEGIN
    FOR i IN 1..10000
    LOOP
        tmp_text := CONCAT(tmp_text, 'Oto tekst. ');
    END LOOP;
    
    INSERT INTO DOKUMENTY VALUES(
        1, tmp_text);
END;
/

-- zad3
SELECT * FROM DOKUMENTY;
SELECT ID, UPPER(DOKUMENT) FROM DOKUMENTY;
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;

-- zad4
INSERT INTO DOKUMENTY VALUES(
    2, EMPTY_CLOB());

-- zad5
INSERT INTO DOKUMENTY VALUES(
    3, NULL);
COMMIT;

-- zad6
SELECT * FROM DOKUMENTY;
SELECT ID, UPPER(DOKUMENT) FROM DOKUMENTY;
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;

-- zad7
DECLARE 
    fil BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    tmp_clob CLOB;
    doffset INTEGER := 1;
    soffset INTEGER := 1;
    langctx INTEGER := 0;
    warn INTEGER := null;
BEGIN
    SELECT DOKUMENT INTO tmp_clob
    FROM DOKUMENTY WHERE ID=2
    FOR UPDATE;
    
    DBMS_LOB.FILEOPEN(fil, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADCLOBFROMFILE(tmp_clob, fil, DBMS_LOB.LOBMAXSIZE,
        doffset, soffset, 873, langctx, warn);
    DBMS_LOB.FILECLOSE(fil);
    
    COMMIT;
    dbms_output.put_line('Status: ' || warn);
END;
/

-- zad8
UPDATE DOKUMENTY
    SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
    WHERE ID=3;

-- zad9
SELECT * FROM DOKUMENTY;

-- zad10
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

-- zad11
DROP TABLE DOKUMENTY;

-- zad12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    tmp_clob IN OUT CLOB,
    pattern VARCHAR2
)
IS
    position INTEGER;
    replace_with VARCHAR2(20);
    counter INTEGER;
BEGIN
    FOR counter IN 1..LENGTH(pattern) LOOP
        replace_with := replace_with || '.';
    END LOOP;

    LOOP
        position := DBMS_LOB.INSTR(tmp_clob, pattern, 1, 1);
        EXIT WHEN position = 0;
        DBMS_LOB.WRITE(tmp_clob, LENGTH(pattern), position, replace_with);
    END LOOP;
END CLOB_CENSOR;

-- zad13
CREATE TABLE BIOGRAPHIES
    AS SELECT * FROM ZTPD.BIOGRAPHIES;

DECLARE
    biography clob;
BEGIN
    SELECT BIO INTO biography FROM BIOGRAPHIES FOR UPDATE;
    CLOB_CENSOR(biography, 'Cimrman');
    COMMIT;
END;
/

SELECT * FROM BIOGRAPHIES;

-- zad14
DROP TABLE BIOGRAPHIES;