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
CREATE OR REPLACE procedure VMS.fill_2word_preview
as
 n_type INTEGER := 2;
 l_c integer := 0;
 l_nword VARCHAR2(100); 
 l_nword_prev VARCHAR2(100);
begin
 FOR I IN (SELECT nw.id, nw.idx, nw.N, 
            TRIM( regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\1') ) PAGE,
            TRIM( regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\2') ) "ROW",
             nword,
            LAG ( nword, 1, 0 ) OVER ( PARTITION BY regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\1') 
                                         ORDER BY regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\2'), NW.ID NULLS LAST ) PREV,
            LEAD ( nword, 1, 0 ) OVER ( PARTITION BY regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\1') 
                                         ORDER BY regexp_replace ( nw.idx, '<(.*)\.(.*)>' , '\2'), NW.ID NULLS LAST ) LEAD,
          IM.TEXT
         FROM VMS.GONK2_NWORD nw JOIN VMS.GONK2_INTERLIN_MANCHU im ON ( nw.idx = im.IDX and IM.ID_TYPE = 2 )
            WHERE NW.ID_TYPE = 2
              and NW.N_TYPE = 1 -- 1-words
          ORDER BY 1
        )
  LOOP
   if not(i.prev = '0' OR i.LEAD = '0' ) THEN
        l_nword := i.prev || ' ' || i.nword;
     --  dbms_output.put_line( i.idx ||' - ' || i.PAGE || ' : ' || i."ROW" || ' : ' || l_nword );
        INSERT INTO  VMS.GONK2_NWORD (
                                    IDX,
                                    IDX_NEW_LINE,
                                    ID_TYPE,
                                    IS_NEW_LINE ,   
                                    MPH2_CODE,    
                                    MPH_CODE,   
                                    N,   
                                    NWORD ,  
                                    N_TYPE, 
                                    SOUND_CODE )
         VALUES (  
                i.IDX,
                NULL,
                2,
                0,
                NULL,        --MPH2
                metaphone(l_nword),
                i.N,
                l_nword,
                2 ,              -- N_TYPE= 2  - 2-words , 2-gram
                soundex( l_nword)
               );
      l_c := l_c + 1;
     --  IF l_c > 100 then 
      --  exit;
     --  end if;
      --l_nword_prev := i.nword;
   end if; 
  END LOOP;
  dbms_output.put_line( 'Processed : ' || l_c || ' words' );
end;
/


begin
 VMS.FILL_2WORD_PREVIEW;
end;

-- remove duplicates
    delete from VMS.GONK2_NWORD nw
     WHERE  exists ( SELECT 1
                      from   VMS.GONK2_NWORD   nw2  
                      where  ) ;
COMMIT;


