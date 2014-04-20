


ALTER TABLE vms.manchu_dict_join
 ADD MPH21_CODE varchar2(200);
 
UPDATE vms.manchu_dict_join 
   SET MPH21_CODE = metaphone21(word); 
 
 
--

ALTER TABLE VMS.GONK2_interlin_manchu add MPH21_CODE varchar2(200);

UPDATE vms.GONK2_interlin_manchu
   SET MPH21_CODE = metaphone21(word); 


----
 
CREATE INDEX IX_MNCH_DICT_MPH21 ON VMS.manchu_dict_join (MPH21_CODE );

---


ALTER TABLE vms.GONK2_NWORD
 ADD MPH21_CODE varchar2(200);
 
UPDATE VMS.GONK2_NWORD 
   SET MPH21_CODE = metaphone21( NWORD ); 
 
CREATE INDEX IX_NWORD_MPH21 ON VMS.GONK2_NWORD (MPH21_CODE );

