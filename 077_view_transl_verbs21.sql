
CREATE OR REPLACE FORCE VIEW VMS.TRANSL_VERBS21
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
   TRANSLATION
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
            -- LPAD( trim( regexp_replace(idx, '(\.[:digit:]*)>', '\1') ) , 3, '0') lpad3,
            nw.ID,
            nw.id_type,
            nw.n_type,
            nw.idx,
            nw.n,
            nw.nword,
            nw.sound_code,
            nw.mph21_code,
            v.word,
            v.translation
       --md.sound_code
       FROM VMS.gonk2_nword nw
            LEFT JOIN
            (SELECT VS.STEM || suff.suffix WORD,
                    suff.description || ' : ' || VS.TRANSLATION translation,
                    metaphone21 (VS.STEM || suff.suffix) mph21
               FROM VMS.MANCHU_VERB_STEM vs
                    CROSS JOIN VMS.MANCHU_VERB_SUFFIX suff
              WHERE suff.suffix <> 'mbi'
             UNION ALL
             SELECT D.WORD, D.TRANSLATION, D.MPH21_CODE
               FROM VMS.MANCHU_DICT_JOIN d) v
               ON NW.MPH21_CODE = v.mph21
      --VMS.manchu_dict_join md
      --ON (nw.mph21_code = md.mph21_code)
      WHERE nw.n_type IN (1, 2)
   ORDER BY lpad1,
         --   idx,
          --  nw.N,
            nw.ID;

