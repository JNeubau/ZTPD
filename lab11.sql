-- Joanna Neubauer
-- 2024-01-10
-- Oracle Text

-- Operator CONTAINS
------------------------------------------------------------
-- zad1
CREATE TABLE CYTATY AS (
    SELECT *
    FROM ZTPD.CYTATY);

-- zad2
SELECT AUTOR, TEKST
FROM CYTATY
WHERE UPPER(TEKST) LIKE '%PESYMISTA%' AND
    UPPER(TEKST) LIKE '%OPTYMISTA%';

-- zad3
CREATE INDEX CYTATY_TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad4
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA')>0
    AND CONTAINS(TEKST, 'OPTYMISTA')>0;

-- zad5
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA')>0
    AND CONTAINS(TEKST, 'OPTYMISTA')=0;

-- zad6
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 3 )')>0;

-- zad7
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 10 )')>0;

-- zad8
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%')>0;

-- zad9
SELECT AUTOR, TEKST, SCORE(1)
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1)>0;

-- zad10
SELECT AUTOR, TEKST, SCORE(1)
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1)>0 AND
    ROWNUM=1
ORDER BY SCORE(1) ;

-- zad11
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'FUZZY(probelm)', 1)>0 ;

-- zad12
--SELECT COUNT(*) FROM CYTATY;
INSERT INTO CYTATY VALUES(
    50,
    'Bertrana Russell',
    'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.'
);

-- zad13
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1)>0 ;
-- Nie jest wpisane w indeksie

-- zad14
SELECT TOKEN_TEXT
FROM DR$CYTATY_TEKST_IDX$I;

-- zad15
DROP INDEX CYTATY_TEKST_IDX;

CREATE INDEX CYTATY_TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad16
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1)>0 ;
-- TAK

-- zad17
DROP INDEX CYTATY_TEKST_IDX;
DROP TABLE CYTATY;



-- Zaawansowane indeksowanie i wyszukiwanie
------------------------------------------------------------
-- zad1
CREATE TABLE QUOTES AS (
    SELECT *
    FROM ZTPD.QUOTES);

-- zad2
CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT;

-- zad3
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, '$working', 1)>0;
-- for work, $work, $working <- ten sam wynik
-- dla working <- brak wyniku

-- zad4
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1)>0;
-- dunno

-- zad5
select * from CTX_STOPLISTS;
-- EMPTY_STOPLIST
-- DEFAULT_STOPLIST
-- EXTENDED_STOPLIST

-- zad6
SELECT * FROM CTX_STOPWORDS;

-- zad7
DROP INDEX QUOTES_TEXT_IDX;

CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- zad8
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1)>0;
-- 4 wyniki

-- zad9
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND humans', 1)>0;

-- zad10
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND computer', 1)>0;

-- zad11
SELECT AUTHOR, TEXT, SCORE(1)
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1)>0;
-- ORA-29902: błąd podczas wykonywania podprogramu ODCIIndexStart()
-- ORA-20000: Oracle Text error:
-- DRG-10837: sekcja SENTENCE nie istnieje
-- 29902. 00000 -  "error in executing ODCIIndexStart() routine"
-- *Cause:    The execution of ODCIIndexStart routine caused an error.
-- *Action:   Examine the error messages produced by the indextype code and
--            take appropriate action.

-- zad12
DROP INDEX QUOTES_TEXT_IDX;

-- zad13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup',  'SENTENCE');
    ctx_ddl.add_special_section('nullgroup',  'PARAGRAPH');
END;

-- zad14
CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

-- zad15
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND humans', 1)>0;
---- 1 wynik

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND computers', 1)>0;
---- 0 wyników

-- zad16
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1)>0;
-- tak cytat pewnego Marka Wojciechowskiego
-- teraz szuka po prostu humans

-- zad17
DROP INDEX QUOTES_TEXT_IDX;

BEGIN
    ctx_ddl.create_preference('lex','BASIC_LEXER');
    ctx_ddl.set_attribute('lex', 'printjoins', '-');
    ctx_ddl.set_attribute('lex', 'index_text', 'YES');
END;
/
CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST
    section group nullgroup
    LEXER lex');

-- zad18
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1)>0;
---- jest bez non-humans

-- zad19
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'non\-humans', 1)>0;

-- zad20
DROP INDEX QUOTES_TEXT_IDX;
DROP TABLE QUOTES;