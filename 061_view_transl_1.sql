CREATE OR REPLACE FORCE VIEW VMS.TRANSL_1
(
   LPAD1,
   LPAD2,
   ID,
   ID_TYPE,
   N_TYPE,
   IDX,
   N,
   NWORD,
   SOUND_CODE,
   MPH_CODE,
   WORD,
   TRANSLATION,
   MD_SOUND
)
AS
     SELECT LPAD (
               TRIM (
                  REGEXP_REPLACE (idx,
                                  '<([[:digit:]]+)([rv]).([[:digit:]]*)>',
                                  '\1')),
               3,
               '0')
               lpad1,
            REGEXP_REPLACE (idx, '<([[:digit:]]+)([rv]).([[:digit:]]*)>', '\2')
               lpad2,
            --   LPAD( trim( regexp_replace(idx, '(\.[:digit:]*)>', '\1') ) , 3, '0') lpad3,
            NW.ID,
            NW.ID_TYPE,
            NW.N_TYPE,
            NW.IDX,
            NW.N,
            NW.NWORD,
            NW.SOUND_CODE,
            NW.MPH_CODE,
            md.word,
            MD.TRANSLATION,
            MD.SOUND_CODE
       FROM VMS.GONK2_NWORD nw
            LEFT JOIN VMS.MANCHU_DICT_JOIN md ON (nw.mph_code = MD.MPH_CODE)
      WHERE n_type = 1
   ORDER BY lpad1, nw.id                              --lpad2, id  --lpad3, n
;

