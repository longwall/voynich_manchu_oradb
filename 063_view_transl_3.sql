
CREATE OR REPLACE FORCE VIEW vms.transl_3 (lpad1,
                                               lpad2,
                                               ID,
                                               id_type,
                                               n_type,
                                               idx,
                                               n,
                                               nword,
                                               sound_code,
                                               mph_code,
                                               word,
                                               translation,
                                               md_sound
                                              )
AS
   SELECT LPAD
               (TRIM (REGEXP_REPLACE (idx,
                                      '<([[:digit:]]+)([rv]).([[:digit:]]*)>',
                                      '\1'
                                     )
                     ),
                3,
                '0'
               ) lpad1,
            REGEXP_REPLACE (idx,
                            '<([[:digit:]]+)([rv]).([[:digit:]]*)>',
                            '\2'
                           ) lpad2,
            
            -- LPAD( trim( regexp_replace(idx, '(\.[:digit:]*)>', '\1') ) , 3, '0') lpad3,
            nw.ID, nw.id_type, nw.n_type, nw.idx, nw.n, nw.nword,
            nw.sound_code, nw.mph21_code, md.word, md.translation,
            md.sound_code
       FROM VMS.gonk2_nword nw LEFT JOIN VMS.manchu_dict_join md
            ON (nw.mph21_code = md.mph21_code)
      WHERE n_type = 1
   ORDER BY lpad1, nw.ID ;




