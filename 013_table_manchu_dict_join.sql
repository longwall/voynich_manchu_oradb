create table vms.manchu_dict_join ( ID integer,
                                    word_row  varchar2(2000),
                                    word varchar2(100),
                                    translation varchar2(1500)
                                   );
                                   
create sequence vms.seq_manchu_dict_join;



CREATE OR REPLACE TRIGGER trg_seq_id_manchu_dict_j
BEFORE INSERT ON vms.manchu_dict_join
FOR EACH ROW
BEGIN
 SELECT vms.seq_manchu_dict_join.NEXTVAL INTO :NEW.id FROM dual;
END;

ALTER TABLE vms.manchu_dict_join add primary key (ID); 


--ALTER TABLE vms.manchu_dict_join add word_row  varchar2(2000); 
-- alter table vms.manchu_dict_join
--   drop column row_word;


ALTER TABLE vms.manchu_dict_join add  SOUND_CODE varchar2(100);

ALTER TABLE vms.manchu_dict_join add  MPH_CODE varchar2(100);

ALTER TABLE vms.manchu_dict_join add  MPH2_CODE varchar2(100);
