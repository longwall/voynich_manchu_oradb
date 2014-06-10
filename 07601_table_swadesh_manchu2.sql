
CREATE TABLE VMS.SWADESH_MANCHU2
as
SELECT * FROM VMS.SWADESH_MANCHU;

ALTER TABLE VMS.SWADESH_MANCHU2 add source_word varchar2(100);

ALTER TABLE VMS.SWADESH_MANCHU2 add PRIMARY KEY (ID);


INSERT INTO VMS.SWADESH_MANCHU2 (ID, ENG_WORD, WORD, SOURCE_WORD)
select A.ID*100 +seq, A.ENG_WORD, trim( replace( regexp_replace(A.word, '\(.*\)')  , '.')) word, A.word SOURCE_WORD
FROM (
  select seqgen.seq, id, eng_word, trim(replace ( substr(
   word, 
    instr(','||word,',',1,seq),
    instr(','||word||',',',',1,seq+1) - instr(','||word,',',1,seq)-1), '"' ) ) word
  from VMS.SWADESH_MANCHU sw, 
      (select level seq from dual connect by level <= 100) seqgen
   where instr(','||word,',',1,seq) > 0
    and sw.word like '%"%'
  ) A
 order by id ;
