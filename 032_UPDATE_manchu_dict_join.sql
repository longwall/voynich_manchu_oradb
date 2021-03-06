
-- join lines
declare
l_id integer;
begin
 FOR I IN (select * 
            from VMS.MANCHU_DICT_JOIN
            where  regexp_like (word_row, '^[a-z]+')
   ) 
   LOOP
    UPDATE VMS.MANCHU_DICT_JOIN m
     SET m.word_row = m.word_row || ' '|| i.word_row 
     WHERE m.id = i.id - 1;
     dbms_output.put_line ('Updated ' || SQL % ROWCOUNT || ' row, i.id = ' || i.id || ' , i.word_row = ' || i.word_row);
   END LOOP;
 END;


/*
Updated 1 row, i.id = 541 , i.word_row = monk
Updated 1 row, i.id = 110 , i.word_row = harmonize 9. to wait on, to attend 10. to be obsequious, to flatter 11. to collate, to proofread 12. to graft (trees)
Updated 1 row, i.id = 167 , i.word_row = shake
Updated 1 row, i.id = 363 , i.word_row = cooked with the skin on
Updated 1 row, i.id = 463 , i.word_row = assistant director
Updated 1 row, i.id = 1218 , i.word_row = knife or sword
Updated 1 row, i.id = 696 , i.word_row = on an archery field
Updated 1 row, i.id = 983 , i.word_row = assiduous
Updated 1 row, i.id = 2184 , i.word_row = of mathematics
Updated 1 row, i.id = 1881 , i.word_row = swinging backwards
Updated 1 row, i.id = 2039 , i.word_row = rivet or tack found on knives, cruppers, bridles, etc.
Updated 1 row, i.id = 3091 , i.word_row = straight, straightforward 3. the south side 4. a small white heron 
Updated 1 row, i.id = 3171 , i.word_row = interest
Updated 1 row, i.id = 3466 , i.word_row = bring harm to (of ghosts)
Updated 1 row, i.id = 3536 , i.word_row = grade on the official examination
Updated 1 row, i.id = 2861 , i.word_row = tired, to tire
Updated 1 row, i.id = 3689 , i.word_row = to pay no attention (to other people)
Updated 1 row, i.id = 3840 , i.word_row = to attach oneself to someone for gain 
Updated 1 row, i.id = 3923 , i.word_row = deities or to the guest of honor 
Updated 1 row, i.id = 4892 , i.word_row = sister 2. wife's elder brother 3. the husband of wife's elder sister 4. the husband of an imperial princess
Updated 1 row, i.id = 5050 , i.word_row = river
Updated 1 row, i.id = 5287 , i.word_row = torious generals and officials 
Updated 1 row, i.id = 4558 , i.word_row = nary sheet
Updated 1 row, i.id = 4814 , i.word_row = the palace
Updated 1 row, i.id = 5534 , i.word_row = a device for recording the pronunciation of Chinese characters by using two other characters
Updated 1 row, i.id = 6124 , i.word_row = shape of a Chinese olive
Updated 1 row, i.id = 6344 , i.word_row = branch
Updated 1 row, i.id = 6429 , i.word_row = cf. indahūn cecike
Updated 1 row, i.id = 6038 , i.word_row = used for steaming various foods 
Updated 1 row, i.id = 6955 , i.word_row = forward
Updated 1 row, i.id = 7277 , i.word_row = the bullfinch; cf. ūn cecike
Updated 1 row, i.id = 6509 , i.word_row = to rip
Updated 1 row, i.id = 6585 , i.word_row = scarf used during the Han dynasty 
Updated 1 row, i.id = 6735 , i.word_row = of the Board of Punishments in Mukden 
Updated 1 row, i.id = 6808 , i.word_row = bathe with a warm medicated liquid 3. to come in (of the tide) 4. to be hot (of taste)
Updated 1 row, i.id = 7504 , i.word_row = a great distance in one day
Updated 1 row, i.id = 7972 , i.word_row = cherished, beloved
Updated 1 row, i.id = 8029 , i.word_row = large leaves, a purple stalk, and sacklike blossoms
Updated 1 row, i.id = 7731 , i.word_row = station
Updated 1 row, i.id = 7808 , i.word_row = hungry, borborygmus
Updated 1 row, i.id = 7956 , i.word_row = afar
Updated 1 row, i.id = 8936 , i.word_row = coko
Updated 1 row, i.id = 9305 , i.word_row = of burden
Updated 1 row, i.id = 8567 , i.word_row = lightened, possessing understanding 
Updated 1 row, i.id = 9454 , i.word_row = moo
Updated 1 row, i.id = 9897 , i.word_row = duck known as yargican niyehe
Updated 1 row, i.id = 10167 , i.word_row = the month 3. beginning, at the beginning, the first day of a lunar month 4. fresh
Updated 1 row, i.id = 10762 , i.word_row = beveled grip
Updated 1 row, i.id = 10899 , i.word_row = paternal side
Updated 1 row, i.id = 11046 , i.word_row = correspond
Updated 1 row, i.id = 10380 , i.word_row = veal, to expose
Updated 1 row, i.id = 10534 , i.word_row = time
Updated 1 row, i.id = 11698 , i.word_row = sacrificial pig's ear
Updated 1 row, i.id = 11763 , i.word_row = of Ursa Minor
Updated 1 row, i.id = 11952 , i.word_row = horse
Updated 1 row, i.id = 11846 , i.word_row = four solar divisions of the year falling on May 6 or 7
Updated 1 row, i.id = 11327 , i.word_row = second copy went to the archives) 
Updated 1 row, i.id = 11623 , i.word_row = emperor
Updated 1 row, i.id = 12541 , i.word_row = the sound of gagging
Updated 1 row, i.id = 12610 , i.word_row = the armpits
Updated 1 row, i.id = 12682 , i.word_row = soot
Updated 1 row, i.id = 12908 , i.word_row = bear; cf. mojihiyan.
Updated 1 row, i.id = 12321 , i.word_row = of the herd
Updated 1 row, i.id = 13849 , i.word_row = hung before a door
Updated 1 row, i.id = 13689 , i.word_row = exorcise, to break a spell
Updated 1 row, i.id = 13234 , i.word_row = of enemy troops in order to frighten them
Updated 1 row, i.id = 13317 , i.word_row = have difficulty, to be in difficult straits
Updated 1 row, i.id = 14232 , i.word_row = quince but somewhat larger
Updated 1 row, i.id = 14360 , i.word_row = ease, not to worry
Updated 1 row, i.id = 14504 , i.word_row = sacrifice was offered at the north wall of a house
Updated 1 row, i.id = 14704 , i.word_row = a style of calligraphy--the small seal
Updated 1 row, i.id = 14783 , i.word_row = unimportant, trifling 3. scanty, meager
Updated 1 row, i.id = 14631 , i.word_row = erous
Updated 1 row, i.id = 13922 , i.word_row = body so as to make the bells on the belt ring (of shamans)
Updated 1 row, i.id = 14092 , i.word_row = picting the constellation moko 
Updated 1 row, i.id = 21751 , i.word_row = classical Chinese phonology
Updated 1 row, i.id = 18005 , i.word_row = mountain, small town on a mountain 
Updated 1 row, i.id = 19957 , i.word_row = degree, BH 945
Updated 1 row, i.id = 20026 , i.word_row = in the statutes
Updated 1 row, i.id = 18233 , i.word_row = be coerced
Updated 1 row, i.id = 20156 , i.word_row = all the troops in chorus
Updated 1 row, i.id = 16389 , i.word_row = kilakci
Updated 1 row, i.id = 16467 , i.word_row = cal
Updated 1 row, i.id = 16470 , i.word_row = angry)
Updated 1 row, i.id = 16472 , i.word_row = mountain peaks) 2. straight, erect 
Updated 1 row, i.id = 16475 , i.word_row = many peaks)
Updated 1 row, i.id = 16477 , i.word_row = cipitous peaks
Updated 1 row, i.id = 18373 , i.word_row = and then burned
Updated 1 row, i.id = 20377 , i.word_row = catching fish, a weel
Updated 1 row, i.id = 20448 , i.word_row = leaves, and many branches
Updated 1 row, i.id = 20524 , i.word_row = mer hunt
Updated 1 row, i.id = 14854 , i.word_row = scroll, roll of cloth, etc.) 
Updated 1 row, i.id = 16825 , i.word_row = household who serve on court duty 
Updated 1 row, i.id = 16966 , i.word_row = moisten, to seep into 2. to favor
Updated 1 row, i.id = 20673 , i.word_row = trick riding, to do a somersault on the horse
Updated 1 row, i.id = 20750 , i.word_row = for storing grain 2. see urui
Updated 1 row, i.id = 15071 , i.word_row = bling the quince that blooms around the sixteenth of the first month 
Updated 1 row, i.id = 17030 , i.word_row = depicting the constellation sindubi 
Updated 1 row, i.id = 18809 , i.word_row = flower from Kwangtung
Updated 1 row, i.id = 20824 , i.word_row = be disappointed
Updated 1 row, i.id = 17168 , i.word_row = three holes in it--used for shooting wild game
Updated 1 row, i.id = 18942 , i.word_row = bow-shaped
Updated 1 row, i.id = 19019 , i.word_row = vow
Updated 1 row, i.id = 20963 , i.word_row = rings attached to it--a puzzle ring 
Updated 1 row, i.id = 15347 , i.word_row = light, flimsy (of clothing) 
Updated 1 row, i.id = 17241 , i.word_row = unrestrained
Updated 1 row, i.id = 19084 , i.word_row = informally 7. to pull apart, to rip 
Updated 1 row, i.id = 21170 , i.word_row = ficial Worship
Updated 1 row, i.id = 19349 , i.word_row = and smelting
Updated 1 row, i.id = 21306 , i.word_row = pursuits 3. notch (for the string on an arrow)
Updated 1 row, i.id = 15689 , i.word_row = march
Updated 1 row, i.id = 15771 , i.word_row = surface (gruel or other liquids) 
Updated 1 row, i.id = 17595 , i.word_row = cf. bongko sukiyara duka
Updated 1 row, i.id = 19420 , i.word_row = the protection of the rider's legs 
Updated 1 row, i.id = 21434 , i.word_row = blue cloth
Updated 1 row, i.id = 21512 , i.word_row = handles and four legs 
Updated 1 row, i.id = 16026 , i.word_row = cartilage in the knee, elbow, or shoulder joint
Updated 1 row, i.id = 19691 , i.word_row = drawbridge
Updated 1 row, i.id = 16102 , i.word_row = erect

*/





 UPDATE vms.manchu_dict_join m
  SET m.word_row = 'DAICING the Manchu dynasty'
  WHERE m.word_row =   'DAIC1NG the Manchu dynasty';
 
 UPDATE vms.manchu_dict_join m
  SET m.word_row = 'MOOI FAKSI carpenter'
  WHERE m.word_row =   'M00I FAKSI carpenter';
 
 -----------------
 UPDATE vms.manchu_dict_join m
  SET m.word = REGEXP_SUBSTR( m.word_row,  '^[A-ZŪŠŽ/,.'' ]+ ');
  
 UPDATE vms.manchu_dict_join m
  SET m.translation = substr( m.word_row, length( m.word  ) );
 ------------------
 
 /* select * from manchu_dict_join
   where word is NULL
   and regexp_like (word_row , '^[A-Z]')
   */
   
  begin
   FOR I IN ( select * from manchu_dict_join
               where word is NULL
               and regexp_like (word_row , '^[A-Z]')
            )
   LOOP
    UPDATE vms.manchu_dict_join m
     SET m.word_row = m.word_row || i.word_row
     WHERE m.id = i.id - 1;
     dbms_output.put_line ('Updated ' || SQL % ROWCOUNT || ' row, i.id = ' || i.id || ' , i.word_row = ' 
                               || i.word_row );
   END LOOP;   
  end; 
   
   /*
   
Updated 1 row, i.id = 767 , i.word_row = Commissioner of the Transmission Office, BH 928
Updated 1 row, i.id = 907 , i.word_row = Board of Works
Updated 1 row, i.id = 4366 , i.word_row = Physician, BH 238
Updated 1 row, i.id = 7655 , i.word_row = Junior Metropolitan Censor, BH 2I0 
Updated 1 row, i.id = 14159 , i.word_row = Board of Works
   
   */
  
  --- one more cycle of 2 updates
   -----------------
 UPDATE vms.manchu_dict_join m
  SET m.word = REGEXP_SUBSTR( m.word_row,  '^[A-ZŪŠŽ/,.'' ]+ ');
  
 UPDATE vms.manchu_dict_join m
  SET m.translation = substr( m.word_row, length( m.word  ) );
 ------------------
 
  DELETE FROM vms.manchu_dict_join 
  where word is null;
  
  UPDATE VMS.MANCHU_DICT_JOIN d
 SET WORD = trim (WORD);
  
  COMMIT;
  
  
  --- soundex
  UPDATE vms.manchu_dict_join 
   SET  SOUND_CODE = soundex(word);
   
  COMMIT; 
  --- metaphone() func
  UPDATE vms.manchu_dict_join 
   SET  MPH_CODE = metaphone(word);
   
  UPDATE vms.manchu_dict_join 
   SET  MPH2_CODE = metaphone2(word);   
   
   COMMIT;
   
    UPDATE VMS.MANCHU_DICT_JOIN d
    SET D.TRANSLATION = D.TRANSLATION|| ' :: ' || (select d2.translation 
                      from VMS.MANCHU_DICT_JOIN d2 
                      where D2.WORD =   upper(replace( regexp_substr (D.TRANSLATION  , ' see (.*)[ 0-9]*' ) ,' see ') )
                      and rownum <=1
                      ) 
    WHERE regexp_like( D.TRANSLATION , '[.;] see ' )
        or D.TRANSLATION   like ' see %';
		
  COMMIT;
  
  
  