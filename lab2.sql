-- Joanna Neubauer
-- 2024-10-11
-- Duze Obiekty Binarne (BLOB)

-- zad1
CREATE TABLE MOVIES AS (SELECT * FROM ZTPD.MOVIES);

-- zad2
DESC MOVIES;

-- zad3
SELECT ID, TITLE FROM MOVIES
WHERE COVER IS NULL;

-- zad4
SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) AS FILESIZE 
FROM MOVIES
WHERE COVER IS NOT NULL;

-- zad5
SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) AS FILESIZE FROM MOVIES
WHERE COVER IS NULL;
-- FILESIZE - JEST NULLEM

-- zad6
SELECT DIRECTORY_NAME, DIRECTORY_PATH 
FROM ALL_DIRECTORIES;
-- /u01/app/oracle/oradata/DBLAB03/directories/tpd_dir

-- zad7
UPDATE movies
SET COVER = EMPTY_BLOB(),
    mime_type = 'image/jpeg'
WHERE id = 66;
COMMIT;

SELECT * FROM MOVIES;

-- zad8
SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) AS FILESIZE 
FROM MOVIES
WHERE ID = 65 OR ID = 66;

-- zad9
DECLARE
    file_cover BFILE := BFILENAME('TPD_DIR','escape.jpg');
    temp_blob BLOB;
BEGIN
    SELECT COVER INTO temp_blob
    FROM MOVIES WHERE ID=66 FOR UPDATE;
    
    DBMS_LOB.FILEOPEN(file_cover);
    DBMS_LOB.LOADFROMFILE(temp_blob, file_cover, DBMS_LOB.GETLENGTH(file_cover));
    DBMS_LOB.FILECLOSE(file_cover);
    
    COMMIT;
END;
/

-- zad10
CREATE TABLE TEMP_COVERS(
    movie_id NUMBER(2),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- zad11
INSERT INTO TEMP_COVERS (movie_id, image, mime_type)
    VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

-- zad12
SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE
    FROM TEMP_COVERS;

-- zad13
DECLARE
    tmp_cover BFILE;
    tmp_blob BLOB;
    tmp_mime VARCHAR2(50);
BEGIN        
    SELECT image, mime_type INTO tmp_cover, tmp_mime
    FROM TEMP_COVERS
    WHERE movie_id=65;
    
    DBMS_LOB.FILEOPEN(tmp_cover, DBMS_LOB.file_readonly);
    DBMS_LOB.CREATETEMPORARY(tmp_blob, TRUE);
    DBMS_LOB.LOADFROMFILE(tmp_blob, tmp_cover, DBMS_LOB.GETLENGTH(tmp_cover));
    DBMS_LOB.FILECLOSE(tmp_cover);
    
    UPDATE MOVIES SET
        cover = tmp_blob,
        mime_type = tmp_mime
        WHERE ID=65;
        
    DBMS_LOB.FREETEMPORARY(tmp_blob);
    COMMIT;
END;
/

-- zad14
SELECT id, DBMS_LOB.GETLENGTH(cover) 
    FROM MOVIES
    WHERE ID=65 OR ID=66;

-- zad15
DROP TABLE MOVIES;
DROP TABLE TEMP_COVERS;