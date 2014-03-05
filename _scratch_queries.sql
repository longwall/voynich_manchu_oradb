select  SUBSTR( m.text, instr( m.text, ' ' )) "2nd" , -- SUBSTR( m.text, instr( m.text, ' ', 3 )) "3rd",
  m.*, md.*
from  vms.gonk2_interlin_manchu m
 LEFT JOIN vms.manchu_dict_join md ON ( soundex( SUBSTR( m.text, instr( m.text, ' ' )) ) = md.sound_code )
where m.id_type = 2
 and md.id is not null 
-- order by m.id


select  SUBSTR( m.text, instr( m.text, ' ' )) "2nd" , -- SUBSTR( m.text, instr( m.text, ' ', 3 )) "3rd",
  m.*, md.*
from  vms.gonk2_interlin_manchu m
 LEFT JOIN vms.manchu_dict_join md ON ( soundex( SUBSTR( m.text, instr( m.text, ' ' )) ) = md.sound_code )
where m.id_type = 2
 and md.id is not null 
-- order by m.id
