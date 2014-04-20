
CREATE OR REPLACE FUNCTION DoLogic (
   v_org_name   VARCHAR2
  ,v_meta_len   NUMBER
  ,v_this_idx   NUMBER
)
   RETURN VARCHAR2 IS
   this_idx    NUMBER        := v_this_idx;
   this_char   VARCHAR2 (1);
   hard        NUMBER;
   org_name    VARCHAR2 (300) := v_org_name;
   meta_len    NUMBER        := v_meta_len;
BEGIN
   this_char := substr (org_name, this_idx, 1);

   IF this_char = 'B' THEN
      IF this_idx = meta_len THEN
         IF substr (org_name, this_idx - 1, 1) != 'M' THEN
            RETURN this_char;
         END IF;
      ELSE
         RETURN this_char;
      END IF;
   ELSIF this_char = 'C' THEN
      IF this_idx + 1 <= meta_len THEN
         IF      substr (org_name, this_idx - 1, 1) = 'S'
             AND substr (org_name, this_idx + 1, 1) IN ('E', 'I', 'Y') THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx + 2 <= meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'I'
             AND substr (org_name, this_idx + 2, 1) = 'A' THEN
            RETURN 'X';
         END IF;
      END IF;

      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) IN ('E', 'I', 'Y') THEN
            RETURN 'S';
         END IF;

         IF      substr (org_name, this_idx + 1, 1) = 'H'
             AND substr (org_name, this_idx - 1, 1) = 'S' THEN
            RETURN 'K';
         END IF;

         IF substr (org_name, this_idx + 1, 1) = 'H' THEN
            IF this_idx + 2 <= meta_len THEN
               IF substr (org_name, this_idx + 2, 1) IN ('A', 'E', 'I', 'O', 'U') THEN
                  RETURN 'K';
               ELSE
                  RETURN 'X';
               END IF;
            ELSE
               RETURN 'X';
            END IF;
         END IF;
      END IF;

      RETURN 'K';
   ELSIF this_char = 'D' THEN
      IF this_idx + 2 <= meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'G'
             AND substr (org_name, this_idx + 2, 1) IN ('E', 'I', 'Y') THEN
            RETURN 'J';
         END IF;
      END IF;

      RETURN 'T';
   ELSIF this_char = 'G' THEN
      IF this_idx + 2 <= meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'H'
             AND substr (org_name, this_idx + 2, 1) IN
                                                     ('A', 'E', 'I', 'O', 'U', 'T') THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx + 1 = meta_len THEN
         IF substr (org_name, this_idx + 1, 1) = 'N' THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx + 3 = meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'N'
             AND substr (org_name, this_idx + 2, 1) = 'E'
             AND substr (org_name, this_idx + 3, 1) = 'D' THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx + 1 <= meta_len THEN
         IF      substr (org_name, this_idx - 1, 1) = 'D'
             AND substr (org_name, this_idx + 1, 1) IN ('E', 'I', 'Y') THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) IN ('E', 'I', 'Y') THEN
            RETURN 'J';
         END IF;
      END IF;

      RETURN 'K';
   ELSIF this_char = 'H' THEN
      IF this_idx = meta_len THEN
         RETURN '';
      END IF;

      IF substr (org_name, this_idx - 1, 1) IN ('C', 'S', 'P', 'T', 'G') THEN
         RETURN '';
      END IF;

      IF this_idx + 1 <= meta_len THEN
         IF substr (org_name, this_idx + 1, 1) IN ('A', 'E', 'I', 'O', 'U') THEN
            RETURN this_char;
         END IF;
      END IF;
   ELSIF this_char = 'K' THEN
      IF substr (org_name, this_idx - 1, 1) NOT BETWEEN '0' AND '9' THEN
         RETURN this_char;
      END IF;
   ELSIF this_char = 'P' THEN
      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) = 'H' THEN
            RETURN 'F';
         END IF;
      END IF;

      RETURN this_char;
   ELSIF this_char = 'Q' THEN
      RETURN 'K';
   ELSIF this_char = 'S' THEN
      IF this_idx + 2 <= meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'I'
             AND substr (org_name, this_idx + 2, 1) IN ('A', 'O') THEN
            RETURN 'X';
         END IF;
      END IF;

      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) = 'H' THEN
            RETURN 'X';
         END IF;
      END IF;

      RETURN this_char;
   ELSIF this_char = 'T' THEN
      IF this_idx + 2 <= meta_len THEN
         IF      substr (org_name, this_idx + 1, 1) = 'I'
             AND substr (org_name, this_idx + 2, 1) IN ('A', 'O') THEN
            RETURN 'X';
         END IF;

         IF      substr (org_name, this_idx + 1, 1) = 'C'
             AND substr (org_name, this_idx + 2, 1) = 'H' THEN
            RETURN '';
         END IF;
      END IF;

      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) = 'H' THEN
            IF substr (org_name, this_idx - 1, 1) = 'T' THEN
               RETURN '';
            ELSE
               RETURN 'O';
            END IF;
         END IF;
      END IF;

      RETURN this_char;
   ELSIF this_char IN ('W', 'Y') THEN
      IF this_idx < meta_len THEN
         IF substr (org_name, this_idx + 1, 1) IN ('A', 'E', 'I', 'O', 'U') THEN
            RETURN this_char;
         END IF;
      END IF;
   ELSIF      this_char BETWEEN 'A' AND 'Z'
          AND this_char NOT IN ('A', 'E', 'I', 'O', 'U') THEN
      RETURN this_char;
   END IF;

   RETURN '';
END;
/



CREATE OR REPLACE FUNCTION Metaphone (
   v_pass_name   VARCHAR2
)
   RETURN VARCHAR2 IS

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
BEGIN
   -- Initialization
   pass_name := upper (pass_name);
   org_name := '';

   -- Parse out unwanted's
   FOR idx IN 1 .. LENGTH (pass_name) LOOP
      IF    substr (pass_name, idx, 1) BETWEEN 'A' AND 'Z'
         OR substr (pass_name, idx, 1) BETWEEN '0' AND '9' THEN
         org_name := org_name || substr (pass_name, idx, 1);
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


--===========================================================================
-- MODIFICATION HISTORY
-- Person      Date       Comments
-- ---------   ---------- ------------------------------------------
-- joel        03/15/2002 Initial coversion into PLSQL
--===========================================================================
