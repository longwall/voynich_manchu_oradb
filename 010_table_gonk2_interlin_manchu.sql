create table VMS.GONK2_interlin_manchu (id integer,
                              id_type integer,  
                              text varchar2(400)
                               );
                               
CREATE SEQUENCE seq_gonk2_interlin;

CREATE OR REPLACE TRIGGER my_trigger
BEFORE INSERT ON VMS.GONK2_interlin_manchu
FOR EACH ROW
BEGIN
 SELECT seq_gonk2_interlin.NEXTVAL INTO :NEW.id FROM dual;
END;

ALTER TABLE VMS.GONK2_interlin_manchu add primary key (ID);

ALTER TABLE VMS.GONK2_interlin_manchu add IDX varchar2(50);

ALTER TABLE VMS.GONK2_interlin_manchu add SOUND_CODE varchar2(50);


ALTER TABLE VMS.GONK2_interlin_manchu add MPH_CODE varchar2(200);
