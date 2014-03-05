-- select * from vms.gonk2_interlin_manchu


UPDATE vms.gonk2_interlin_manchu
SET ID_TYPE = 2
where mod(id, 2) = 0 ;
UPDATE vms.gonk2_interlin_manchu
SET ID_TYPE = 1
where mod(id, 2) != 0 ;

COMMIT;



update VMS.GONK2_interlin_manchu m
set mph_code = vms.metaphone( m.text );

commit;


--delete duplicates
DELETE FROM gonk2_interlin_manchu m1
 WHERE EXISTS ( Select 1 
               from gonk2_interlin_manchu m2
               WHERE m1.idx = m2.idx
                and m1.id_type = m2.id_type
                and m2.text = m1.text
                and m1.id > m2.id
             );
			 
commit;
			 