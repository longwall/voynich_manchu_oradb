CREATE TABLE GONK2_NWORD (
 ID         NUMBER,
 ID_TYPE    NUMBER,
 N_TYPE     INTEGER,      -- 1..N
 IDX        varchar2(50),
 N          INTEGER,    -- 1..N
 IS_NEW_LINE INTEGER DEFAULT 0,  -- 0 - if inside one IDX line ELSE 1  
 NWORD      varchar2(50),
 SOUND_CODE varchar2(30),
 MPH_CODE   varchar2(30),
 MPH2_CODE   varchar2(30)
);

CREATE SEQUENCE seq_gonk2_nword;

CREATE OR REPLACE TRIGGER trg_i_gonk2_nword
BEFORE INSERT ON GONK2_NWORD
FOR EACH ROW
BEGIN
 SELECT seq_gonk2_nword.NEXTVAL INTO :NEW.id FROM dual;
END;

ALTER TABLE GONK2_NWORD ADD   IDX_NEW_LINE  varchar2(50);

ALTER TABLE GONK2_NWORD ADD PRIMARY KEY( ID);

-- single words - NN_type =1
declare
 l_N integer := 1;
 l_id_type integer := 2; -- manchu
 l_c       integer := 0;
 l_total  integer := 0;
 s         GONK2_NWORD.NWORD % TYPE;
begin
 FOR i in (SELECT * 
            FROM vms.gonk2_interlin_manchu m 
            WHERE m.id_type = l_id_type 
            order by m.ID
            )
  LOOP
   l_c := 0;
  -- dbms_output.put_line(i.idx || ' - ' || i.text);
   LOOP
     l_c := l_c + 1;
     s := regexp_substr(i.text, '[^ ]+', 1, l_c);
    --    dbms_output.put_line(s);
    EXIT WHEN s IS NULL;
    INSERT INTO  GONK2_NWORD (  ID_TYPE,   N_TYPE,  
                     IDX,   N          ,    -- 1..N
                   --  IS_NEW_LINE ,  -- 0 - if inside one IDX line ELSE 1  
                     NWORD, SOUND_CODE, MPH_CODE )
                  VALUES ( l_id_type, l_N, i.IDX, l_c,  s, soundex(s), metaphone(s)   ); 
     l_total := l_total + 1;    
   END LOOP;
  END LOOP;
  COMMIT;
   dbms_output.put_line(' Totally ' || l_total || ' words added');
end;




CREATE  INDEX IX_NWORD ON  GONK2_NWORD ( ID_TYPE, N_TYPE, IDX, N);


-- double word - NN_ytpe =2
declare
 l_N       integer := 2;
 l_id_type integer := 2; -- manchu
 l_c       integer := 0;
 l_total   integer := 0;
 s1         GONK2_NWORD.NWORD % TYPE := '';
 s2         GONK2_NWORD.NWORD % TYPE := '';
 s         GONK2_NWORD.NWORD % TYPE := '';
 l_IDX_prev    vms.gonk2_interlin_manchu.IDX %TYPE;
 l_word_prev   vms.GONK2_NWORD.NWORD %TYPE := '-'; 
 is_new_line integer := 0;
begin
 FOR i in (SELECT * 
            FROM vms.gonk2_interlin_manchu m 
            WHERE m.id_type = l_id_type 
            order by m.ID
            )
  LOOP
   l_c := 0;
--   dbms_output.put_line(i.idx || ' - ' || i.text);
   LOOP
     dbms_output.put_line(l_c);
     IF l_c = 0  THEN
   --   IF  l_word_prev <> '-' THEN
       s1 := nvl(l_word_prev,'-');
       s2 := regexp_substr(i.text, '[^ ]+', 1, 1);
       is_new_line := 1;
       dbms_output.put_line(s1 || '-' || i.text);
     -- ELSE 
    --   l_c := l_c +1;
     -- END IF;
     ELSE
       l_c := l_c + 1;
       l_word_prev := NULL;
       l_IDX_prev := NULL;
       is_new_line := 0;
       s1 := regexp_substr(i.text, '[^ ]+', 1, l_c );
       s2 := regexp_substr(i.text, '[^ ]+', 1, l_c+1);
      END IF;
   EXIT WHEN s2 IS NULL and s1 is NULL;
    IF (s1 is NOT NULL) and (s2 is NOT NULL) THEN
     s := s1 || ' ' || s2;
      dbms_output.put_line(s);
     INSERT INTO  GONK2_NWORD (  ID_TYPE, N_TYPE,  
                     IDX,   N          ,    -- 1..N
                     IS_NEW_LINE ,  -- 0 - if inside one IDX line ELSE 1  
                     NWORD, SOUND_CODE, MPH_CODE )
                  VALUES ( l_id_type, l_N, i.IDX, l_c, is_new_line,  s, soundex(s), metaphone(s)   );    
     l_total := l_total + 1;
    ELSE
     l_word_prev := s1;
     l_IDX_prev := i.IDX; 
    END IF; 
    IF l_c =0 then
     l_c := l_c + 1;
    END IF;    
   END LOOP;
  END LOOP;
--  COMMIT;
   dbms_output.put_line(' Totally ' || l_total || ' 2-words added');
end;



