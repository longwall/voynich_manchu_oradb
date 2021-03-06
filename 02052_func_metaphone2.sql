CREATE OR REPLACE FUNCTION VMS.Metaphone2 (
   v_pass_name   VARCHAR2
)
   RETURN VARCHAR2 IS

--  2014 - Added  'Ū', 'Š', 'Ž  for manchu lanuage - Maxim Kulibaba
--===========================================================================
-- Copywright 2002, joel crainshaw and chet west
--===========================================================================
-- DESCRIPTION
--    PLSQL implementation of Lawrence Philips' Metaphone algorithm
--        METAPHONE function -- main function
--        DOLOGIC function -- called from METAPHONE    
--
--    The Metaphone Algorithm is an algorithm which returns the rough
--    approximation of how an English word sounds.
--    The author (Lawrence Philips) can be contacted at LFP at dolby.com
--    The original Metaphone algorithm appeared in the
--    December 1990 issue of Computer Language. 
--
--    This is an alternative to Oracle's built-in SOUNDEX.  Other advanced
--    versions of this algo. have been developed and metaphone is the basis
--    for some spell-checking programs
--===========================================================================
-- MODIFICATION HISTORY
-- Person      Date       Comments
-- ---------   ---------- ------------------------------------------
-- joel        03/15/2002 Initial coversion into PLSQL
--                  see attached read_this.txt for original 4GL source
--                  used as code basis
--===========================================================================

   meta_len    NUMBER;
   org_name    VARCHAR2 (300);
   pass_name   VARCHAR2 (300) := v_pass_name;
   new_char    NUMBER;
   ret_name    VARCHAR2 (300);
   tmp_char varchar2(2);
BEGIN
   -- Initialization
   pass_name := upper (pass_name);
  -- pass_name := REPLACE(pass_name, 'Š', 'SH');
  -- pass_name := REPLACE(pass_name, 'Ž', 'ZH');
   pass_name := REPLACE(pass_name, 'Ū', 'U');
   
   org_name := '';
   
   -- Parse out unwanted's
   FOR idx IN 1 .. LENGTH (pass_name) LOOP
     tmp_char := substr (pass_name, idx, 1);

      IF    tmp_char BETWEEN 'A' AND 'Z'
         OR tmp_char BETWEEN '0' AND '9'
         OR tmp_char IN ('Ū', 'Š', 'Ž') 
      THEN
         org_name := org_name || tmp_char  ;
      END IF;
   END LOOP;

   -- If no length, return
   IF org_name IS NULL THEN
      RETURN NULL;
   END IF;

   -- More initialization
   meta_len := LENGTH (org_name);
   ret_name := substr (org_name, 1, 1);

   -- Main loop to generate metaphone
   FOR idx IN 2 .. meta_len LOOP
      IF substr (org_name, idx, 1) NOT BETWEEN '0' AND '9' THEN
         ret_name := ret_name || DoLogic (org_name, meta_len, idx);
      END IF;
   END LOOP;

   RETURN ret_name;
END;
/
