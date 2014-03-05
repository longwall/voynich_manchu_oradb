/* Double Metaphone Package Specs
 *
 *  Author:    Eric Raskin
 *             Professional Advertising Systems Inc.
 *
 *  Date:      Oct 8, 2008
 *
 *  Version:   1.0
 *
 *  This software was translated from the .NET (C#) implementation
 *  originally done by Adam J. Nelson
 *
 *  See the package spec for documentation
 */

CREATE OR REPLACE PACKAGE BODY metaphone
as

function genprimkey(p_string in varchar2, p_keylen in integer)
return varchar2 deterministic
is
begin
  if p_string <> metaphone.input_string 
  or metaphone.input_string is null
  or p_keylen <> metaphone.keylen then
    begin
      metaphone.input_string := p_string;
      metaphone.keylen := p_keylen;
      generate(p_string, p_keylen, metaphone.primkey, metaphone.altkey);
    end;
  end if;
  return metaphone.primkey;
end genprimkey;

function genaltkey(p_string in varchar2, p_keylen in integer)
return varchar2 deterministic
is
begin
  if p_string <> metaphone.input_string
  or metaphone.input_string is null
  or p_keylen <> metaphone.keylen then
    begin
      metaphone.input_string := p_string;
      metaphone.keylen := p_keylen;
      generate(p_string, p_keylen, metaphone.primkey, metaphone.altkey);
    end;
  end if;
  return metaphone.altkey;
end genaltkey;

procedure generate (p_string in varchar2, p_keylen in integer, p_primkey out nocopy varchar2, p_altkey out nocopy varchar2)
is
   l_prim_key	 	  varchar2(20);
   l_alt_key		  varchar2(20);
   l_word		  varchar2(255);
   l_len		  integer;
   l_pos		  integer;

   function charAt(p_value varchar2, p_index integer)
   return char is
   begin

     if p_index < 1 or p_index > length(p_value) then
       return null;
     else
       return substr(p_value, p_index, 1);
     end if;

   end;

   function stringAt(p_value in varchar2, p_index in integer, p_length in integer)
   return varchar2 is
   begin
     case when p_index < 1 then
       	    return null;
          when p_index + p_length > length(p_value) then
	          return substr(p_value, p_index);
	        else
	          return substr(p_value, p_index, p_length);
     end case;
   end;

   procedure addMetaphoneCharacter(pchar in varchar2, achar in varchar2 default null)
   is
     l_pchar varchar2(5) := pchar;
     l_achar varchar2(5) := achar;
   begin

     if l_pchar = ' ' then
       l_pchar := null;
     end if;

     if l_achar = ' ' then
       l_achar := null;
     end if;

     l_prim_key := l_prim_key || l_pchar;

     if length(l_achar) > 0 then
       l_alt_key := l_alt_key || l_achar;
     else
       l_alt_key := l_alt_key || l_pchar;
     end if;

   end;

   function isVowel(pchar in char)
   return boolean
   is
   begin
     return pchar in ('A','E','I','O','U','Y');
   end;

   function isWordSlavoGermanic(pword in varchar2)
   return boolean
   is
   begin
     if instr(pword, 'W') <> 0
     or instr(pword, 'K') <> 0
     or instr(pword, 'CZ') <> 0
     or instr(pword, 'WITZ') <> 0
     then
       return true;
     else
       return false;
     end if;
   end;

begin

   l_len := length(p_string);

   l_word := upper(ltrim(rtrim(p_string))) || '   ';

   if l_len < 1 then
     begin
       p_primkey := '';
       p_altkey := '';
       return;
     end;
   end if;

   l_pos := 1;
   if substr(l_word,1,2) in ('GN','KN','PN','WR','PS') then
     l_pos := 2;
   end if;

   if substr(l_word,1,1) = 'X' then
     addMetaphoneCharacter('S');
     l_pos := l_pos + 1;
   end if;

<<MAIN_LOOP>>

   while (nvl(length(l_prim_key),0) < p_keylen or nvl(length(l_alt_key),0) < p_keylen) and l_pos <= l_len
   loop
     case

       when charAt(l_word,l_pos) in ('A','E','I','O','U','Y') then
         begin
           if l_pos = 1 then
	           addMetaphoneCharacter('A');
	         end if;
	         l_pos := l_pos + 1;
 	       end;

       when charAt(l_word, l_pos) = 'B' then
         begin
	         addMetaphoneCharacter('P');
	         if charAt(l_word, l_pos + 1) = 'B' then
	           l_pos := l_pos + 2;
	         else
	           l_pos := l_pos + 1;
	         end if;
	       end;

	     when charAt(l_word, l_pos) = 'C' then
	       begin
           if  l_pos > 1
           and not isVowel(charAt(l_word, l_pos - 2))
           and stringAt(l_word, l_pos - 1, 3) = 'ACH'
           and charAt(l_word, l_pos + 2) not in ('I','E')
   			   and stringAt(l_word, l_pos - 2, 6) not in ('BACHER','MACHER')
	         then
	           begin
               addMetaphoneCharacter('K');
	             l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
	           end;
           end if;

	         if  l_pos = 1
           and stringAt(l_word, l_pos, 6) = 'CAESER'
           then
	           begin
	             addMetaphoneCharacter('S');
		           l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
 	           end;
           end if;

	         if stringAt(l_word, l_pos, 4) = 'CHIA'
           then
	           begin
	             addMetaphoneCharacter('K');
		           l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
  	         end;
           end if;

           if stringAt(l_word, l_pos, 2) = 'CH'
           then
	           begin
	             if l_pos = 1 and stringAt(l_word, l_pos, 4) = 'CHAE' then
                 begin
		               addMetaphoneCharacter('K','X');
		               l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
		           if  l_pos = 1
               and (stringAt(l_word, l_pos + 1, 5) in ('HARAC','HARIS')
                    or stringAt(l_word, l_pos + 1, 3) in ('HOR','HYM','HIA','HEM'))
			         and stringAt(l_word, 1, 5) != 'CHORE'
		           then
		             begin
		               addMetaphoneCharacter('K');
		               l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
  		           end;
               end if;

	             if (stringAt(l_word, 1, 4) in ('VAN ','VON ') or stringAt(l_word, 1, 3) = 'SCH')
	             or stringAt(l_word, l_pos - 2, 6) in ('ORCHES','ARCHIT','ORCHID')
	             or charAt(l_word, l_pos + 2) in ('T','S')
 	             or ((charAt(l_word, l_pos - 1) in ('A','O','U','E') or l_pos = 1)
	                  and charAt(l_word, l_pos + 2) in ('L','R','N','M','B','H','F','V','W',' '))
	             then
	               addMetaphoneCharacter('K');
	             else
                 begin
                   if l_pos > 1 then
                     if stringAt(l_word, 1, 2) = 'MC' then
                       addMetaphoneCharacter('K');
                     else
                       addMetaphoneCharacter('X','K');
                     end if;
                   else
                     addMetaphoneCharacter('X');
                   end if;
                   l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
             end;
           end if;

	         if  stringAt(l_word, l_pos, 2) = 'CZ'
	         and stringAt(l_word, l_pos -2, 4) <> 'WICZ'
	         then
	           begin
	             addMetaphoneCharacter('S','X');
		           l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
   	         end;
           end if;

	         if stringAt(l_word, l_pos + 1, 3) = 'CIA'
	         then
	           begin
	             addMetaphoneCharacter('X');
		           l_pos := l_pos + 3;
               goto MAIN_LOOP; -- continue
  	         end;
	         end if;

	         if  stringAt(l_word, l_pos, 2) = 'CC'
	         and not (l_pos = 2 and charAt(l_word, 1) = 'M')
	         then
	           begin
	             if  charAt(l_word, l_pos + 2) in ('I','E','H')
		           and stringAt(l_word, l_pos + 2, 2) <> 'HU'
		           then
		             begin
		               if (l_pos = 2 and charAt(l_word, 1) = 'A')
		               or stringAt(l_word, l_pos - 1, 5) in ('UCCEE','UCCES')
		               then
		                 addMetaphoneCharacter('KS');
		               else
		                 addMetaphoneCharacter('X');
		               end if;
		               l_pos := l_pos + 3;
                   goto MAIN_LOOP; -- continue
		             end;
		           else
		             begin
		               addMetaphoneCharacter('K');
		               l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
		             end;
		           end if;
	           end;
           end if;

	         if stringAt(l_word, l_pos, 2) in ('CK','CG','CQ')
	         then
	           begin
	         	   addMetaphoneCharacter('K');
		           l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
	           end;
           end if;

	         if stringAt(l_word, l_pos, 2) in ('CI','CE','CY')
	         then
	           begin
		           if stringAt(l_word, l_pos, 3) in ('CIO','CIE','CIA')
		           then
		             addMetaphoneCharacter('S','X');
		           else
		             addMetaphoneCharacter('S');
	             end if;
		           l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           addMetaphoneCharacter('K');

	         if stringAt(l_word, l_pos + 1, 2) in (' C',' Q',' G')
	         then
		         l_pos := l_pos + 3;
		       else
		         if  charAt(l_word, l_pos + 1) in ('C','K','Q')
		         and stringAt(l_word, l_pos + 1, 2) not in ('CE','CI')
		         then
		           l_pos := l_pos + 2;
	       	   else
		           l_pos := l_pos + 1;
		         end if;
             goto MAIN_LOOP; -- continue
	         end if;
         end;

       when charAt(l_word, l_pos) = 'D' then
         begin
           if stringAt(l_word, l_pos, 2) = 'DG'
           then
             if charAt(l_word, l_pos + 2) in ('I','E','Y')
             then
               begin
                 addMetaphoneCharacter('J');
                 l_pos := l_pos + 3;
                 goto MAIN_LOOP; -- continue
               end;
             else
               begin
                 addMetaphoneCharacter('TK');
                 l_pos := l_pos + 2;
                 goto MAIN_LOOP; -- continue
               end;
             end if;
           end if;

           if stringAt(l_word, l_pos, 2) in ('DT','DD')
           then
             begin
               addMetaphoneCharacter('T');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           addMetaphoneCharacter('T');
           l_pos := l_pos + 1;

         end;

       when charAt(l_word, l_pos) = 'F' then
         begin
           if charAt(l_word, l_pos + 1) = 'F' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('F');
         end;

       when charAt(l_word, l_pos) = 'G' then
         begin
           if charAt(l_word, l_pos + 1) = 'H' then
             begin
               if l_pos > 1 and not isVowel(charAt(l_word, l_pos - 1)) then
                 begin
                   addMetaphoneCharacter('K');
                   l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
               if l_pos < 3 then
                 if l_pos = 1 then
                   begin
                     if charAt(l_word, l_pos + 2) = 'I' then
                       addMetaphoneCharacter('J');
                     else
                       addMetaphoneCharacter('K');
                     end if;
                     l_pos := l_pos + 2;
                     goto MAIN_LOOP; -- continue
                   end;
                 end if;
               end if;
               if (l_pos > 2 and charAt(l_word, l_pos - 2) in ('B','H','D'))
               or (l_pos > 3 and charAt(l_word, l_pos - 3) in ('B','H','D'))
               or (l_pos > 4 and charAt(l_word, l_pos - 4) in ('B','H'))
               then
                 l_pos := l_pos + 2;
                 goto MAIN_LOOP;
               else
                 begin
                   if  l_pos > 3
                   and charAt(l_word, l_pos - 1) = 'U'
                   and charAt(l_word, l_pos - 3) in ('C','G','L','R','T')
                   then
                     addMetaphoneCharacter('F');
                   else
                     if l_pos > 1 and charAt(l_word, l_pos - 1) <> 'I' then
                       addMetaphoneCharacter('K');
                     end if;
                   end if;
                   l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
             end;
           end if;

           if charAt(l_word, l_pos + 1) = 'N'
           then
             begin
               if l_pos = 2 and isVowel(charAt(l_word, 1)) and not isWordSlavoGermanic(l_word) then
                 addMetaphoneCharacter('KN','N');
--                  !!! WHY NO INCREMENT HERE???  L_POS := L_POS + 2;
               else
                 begin
                   if  stringAt(l_word, l_pos + 2, 2) <> 'EY'
                   and charAt(l_word, l_pos + 1) <> 'Y'
                   and not isWordSlavoGermanic(l_word)
                   then
                     addMetaphoneCharacter('N','KN');
                   else
                     addMetaphoneCharacter('KN');
                   end if;
                   l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
             end;
           end if;

           if  stringAt(l_word, l_pos + 1, 2) = 'LI'
           and not isWordSlavoGermanic(l_word)
           then
             begin
               addMetaphoneCharacter('KL','L');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           if l_pos = 1
           and (charAt(l_word, l_pos + 1) = 'Y'
                or stringAt(l_word, l_pos + 1, 2) in ('ES','EP','EB','EL','EY','IB','IL','IN','IE','EI','ER'))
           then
             begin
               addMetaphoneCharacter('K','J');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           if  (stringAt(l_word, l_pos + 1, 2) = 'ER' or charAt(l_word, l_pos + 1) = 'Y')
           and stringAt(l_word, 0, 6) not in ('DANGER','RANGER','MANGER')
           and charAt(l_word, l_pos - 1) not in ('E','I')
           and stringAt(l_word, l_pos - 1, 3) not in ('RGY','OGY')
           then
             begin
               addMetaphoneCharacter('K','J');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           if charAt(l_word, l_pos + 1) in ('E','I','Y')
           or stringAt(l_word, l_pos - 1, 4) in ('AGGI','OGGI')
           then
             begin
               if stringAt(l_word, 1, 4) in ('VAN ','VON ')
               or stringAt(l_word, 1, 3) = 'SCH'
               or stringAt(l_word, l_pos + 1, 2) = 'ET'
               then
                 addMetaphoneCharacter('K');
               else
                 if stringAt(l_word, l_pos + 1, 4) = 'IER ' then
                   addMetaphoneCharacter('J');
                 else
                   addMetaphoneCharacter('J','K');
                 end if;
               end if;
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;

           if charAt(l_word, l_pos + 1) = 'G' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('K');
         end;

       when charAt(l_word, l_pos) = 'H' then
         begin
           if (l_pos = 1 or isVowel(charAt(l_word, l_pos - 1)))
           and isVowel(charAt(l_word, l_pos + 1))
           then
             begin
               addMetaphoneCharacter('H');
               l_pos := l_pos + 2;
             end;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       when charAt(l_word, l_pos) = 'J' then
         begin
           if stringAt(l_word, 1, 4) in ('JOSE','SAN ')
           then
             begin
               if ((l_pos = 1 and charAt(l_word, l_pos + 4) = ' ') or stringAt(l_word,1,4) = 'SAN ')
               then
                 addMetaphoneCharacter('H');
               else
                 addMetaphoneCharacter('J','H');
               end if;
               l_pos := l_pos + 1;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if l_pos = 1 and stringAt(l_word, l_pos, 4) <> 'JOSE' then
             addMetaphoneCharacter('J','A');
           elsif isVowel(charAt(l_word, l_pos - 1))
             and not isWordSlavoGermanic(l_word)
             and (charAt(l_word, l_pos + 1) in ('A','O'))
             then
               addMetaphoneCharacter('J','H');
           elsif l_pos = l_len then
             addMetaphoneCharacter('K', ' ');
           elsif charAt(l_word, l_pos + 1) not in ('L','T','K','S','N','M','B','Z')
             and charAt(l_word, l_pos - 1) not in ('S','K','L') then
               addMetaphoneCharacter('J');
           end if;
           if charAt(l_word, l_pos + 1) = 'J' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       when charAt(l_word, l_pos) = 'K' then
         begin
           if charAt(l_word, l_pos + 1) = 'K' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('K');
         end;

       when charAt(l_word, l_pos) = 'L' then
         begin
           if charAt(l_word, l_pos + 1) = 'L' then
             begin
               if (l_pos = l_len - 3 and stringAt(l_word, l_pos - 1, 4) in ('ILLO','ILLA','ALLE'))
               or ((stringAt(l_word, l_pos - 1, 2) in ('AS','OS')
                    or charAt(l_word, l_len) in ('A','O'))
                    and stringAt(l_word, l_pos - 1, 4) = 'ALLE')
               then
                 begin
                   addMetaphoneCharacter('L',' ');
                   l_pos := l_pos + 2;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
               l_pos := l_pos + 2;
             end;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('L');
         end;

       when charAt(l_word, l_pos) = 'M' then
         begin
           if (stringAt(l_word, l_pos + 1, 3) = 'UMB'
               and (l_pos + 1 = l_len or stringAt(l_word, l_pos + 2, 2) = 'ER'))
           or charAt(l_word, l_pos + 1) = 'M'
           then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('M');
         end;

      when charAt(l_word, l_pos) = 'N' then
        begin
          if charAt(l_word, l_pos + 1) = 'N' then
            l_pos := l_pos + 2;
          else
            l_pos := l_pos + 1;
          end if;
          addMetaphoneCharacter('N');
        end;

       when charAt(l_word, l_pos) = 'P' then
         begin
           if charAt(l_word, l_pos + 1) = 'H' then
             begin
               addMetaphoneCharacter('F');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if charAt(l_word, l_pos + 1) in ('P','B') then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('P');
         end;

       when charAt(l_word, l_pos) = 'Q' then
         begin
           if charAt(l_word, l_pos + 1) = 'Q' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('K');
         end;

       when charAt(l_word, l_pos) = 'R' then
         begin
           if  l_pos = l_len
           and not isWordSlavoGermanic(l_word)
           and stringAt(l_word, l_pos - 2, 2) = 'IE'
           and stringAt(l_word, l_pos - 4, 2) not in ('ME','MA')
           then
             addMetaphoneCharacter('','R');
           else
             addMetaphoneCharacter('R');
           end if;
           if charAt(l_word, l_pos + 1) = 'R' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       when charAt(l_word, l_pos) = 'S' then
         begin
           if stringAt(l_word, l_pos - 1, 3) in ('ISL','YSL') then
             begin
               l_pos := l_pos + 1;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if l_pos = 1 and stringAt(l_word, l_pos, 5) = 'SUGAR' then
             begin
               addMetaphoneCharacter('X','S');
               l_pos := l_pos + 1;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if stringAt(l_word, l_pos, 2) = 'SH' then
             begin
               if stringAt(l_word, l_pos + 1, 4) in ('HEIM','HOEK','HOLM','HOLZ') then
                 addMetaphoneCharacter('S');
               else
                 addMetaphoneCharacter('X');
               end if;
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if stringAt(l_word, l_pos, 3) in ('SIO','SIA') or stringAt(l_word, l_pos, 4) = 'SIAN' then
             begin
               if not isWordSlavoGermanic(l_word) then
                 addMetaphoneCharacter('S','X');
               else
                 addMetaphoneCharacter('S');
               end if;
               l_pos := l_pos + 3;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if (l_pos = 1 and charAt(l_word, l_pos + 1) in ('M','N','L','W')) or charAt(l_word, l_pos + 1) = 'Z' then
             begin
               addMetaphoneCharacter('S','X');
               if charAt(l_word, l_pos + 1) = 'Z' then
                 l_pos := l_pos + 2;
               else
                 l_pos := l_pos + 1;
               end if;
             end;
           end if;
           if stringAt(l_word, l_pos, 2) = 'SC' then
             begin
               if charAt(l_word, l_pos + 2) = 'H' then
                 if stringAt(l_word, l_pos+3, 2) in ('OO','ER','EN','UY','ED','EM') then
                   begin
                     if stringAt(l_word, l_pos+3, 2) in ('ER','EN') then
                       addMetaphoneCharacter('X','SK');
                     else
                       addMetaphoneCharacter('SK');
                     end if;
                     l_pos := l_pos + 3;
                     goto MAIN_LOOP; -- continue
                   end;
                 else
                   begin
                     if l_pos = 1 and not isVowel(charAt(l_word, 3)) and charat(l_word,3) <> 'W' then
                       addMetaphoneCharacter('X','S');
                     else
                       addMetaphoneCharacter('X');
                     end if;
                     l_pos := l_pos + 3;
                     goto MAIN_LOOP; -- continue
                   end;
                 end if;
               end if;
               if charAt(l_word, l_pos + 2) in ('I','E','Y') then
                 begin
                   addMetaphoneCharacter('S');
                   l_pos := l_pos + 3;
                   goto MAIN_LOOP; -- continue
                 end;
               end if;
               addMetaphoneCharacter('SK');
               l_pos := l_pos + 3;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if l_pos = l_len and stringAt(l_word, l_pos - 2, 2) in ('AI','OI') then
             addMetaphoneCharacter('','S');
           else
             addMetaphoneCharacter('S');
           end if;
           if charAt(l_word, l_pos + 1) in ('S','Z') then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       when charAt(l_word, l_pos) = 'T' then
         begin
           if stringAt(l_word, l_pos, 4) = 'TION' then
             begin
               addMetaphoneCharacter('X');
               l_pos := l_pos + 3; -- !!! SHOULD THIS BE 4???
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if stringAt(l_word, l_pos, 3) in ('TIA','TCH') then
             begin
               addMetaphoneCharacter('X');
               l_pos := l_pos + 3;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if stringAt(l_word, l_pos, 2) = 'TH' or stringAt(l_word, l_pos, 3) = 'TTH' then
             begin
               if stringAt(l_word, l_pos + 2, 2) in ('OM','AM')
               or stringAt(l_word, 1, 4) in ('VAN ','VON ')
               or stringAt(l_word, 1, 3) = 'SCH'
               then
                 addMetaphoneCharacter('T');
               else
                 addMetaphoneCharacter('0','T');
               end if;
               l_pos := l_pos + 2;  -- !!! SHOULD THIS BE 3 IF 'TTH'???
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if charAt(l_word, l_pos + 1) in ('T','D') then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('T');
         end;

       when charAt(l_word, l_pos) = 'V' then
         begin
           if charAt(l_word, l_pos + 1) = 'V' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
           addMetaphoneCharacter('F');
         end;

       when charAt(l_word, l_pos) = 'W' then
         begin
           if stringAt(l_word, l_pos, 2) = 'WR' then
             begin
               addMetaphoneCharacter('R');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if l_pos = 1 and (isVowel(charAt(l_word, l_pos + 1)) or stringAt(l_word, l_pos, 2) = 'WH') then
             if isVowel(charAt(l_word, l_pos + 1)) then
               addMetaphoneCharacter('A','F');
             else
               addMetaphoneCharacter('A');
             end if;
           end if;
           if ((l_pos = l_len and isVowel(charAt(l_word, l_pos - 1)))
            or stringAt(l_word, l_pos - 1, 5) in ('EWSKI','EWSKY','OWSKI','OWSKY')
            or stringAt(l_word, 1, 3) = 'SCH')
           then
             begin
               addMetaphoneCharacter('F');
               l_pos := l_pos + 1;
               goto MAIN_LOOP; -- continue
             end;
           end if;
           if stringAt(l_word, l_pos, 4) in ('WICZ','WITZ') then
             begin
               addMetaphoneCharacter('TS','FX');
               l_pos := l_pos + 4;
             end;
           end if;
           l_pos := l_pos + 1;
         end;

       when charAt(l_word, l_pos) = 'X' then
         begin
           if not (l_pos = l_len and
                    (stringAt(l_word, l_pos - 3, 3) in ('IAU','EAU') or
                     stringAt(l_word, l_pos - 2, 2) in ('AU','OU')))
           then
             addMetaphoneCharacter('KS');
           end if;
           if charAt(l_word, l_pos + 1) in ('C','X') then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       when charAt(l_word, l_pos) = 'Z' then
         begin
           if charAt(l_word, l_pos + 1) = 'H' then
             begin
               addMetaphoneCharacter('J');
               l_pos := l_pos + 2;
               goto MAIN_LOOP; -- continue
             end;
           else
             if stringAt(l_word, l_pos + 1, 2) in ('ZO','ZI','ZA')
             or (isWordSlavoGermanic(l_word) and (l_pos > 1 and charAt(l_word, l_pos - 1) <> 'T'))
             THEN
               addMetaphoneCharacter('S','TS');
             else
               addMetaphoneCharacter('S');
             end if;
           end if;
           if charAt(l_word, l_pos + 1) = 'Z' then
             l_pos := l_pos + 2;
           else
             l_pos := l_pos + 1;
           end if;
         end;

       else

	       l_pos := l_pos + 1;

     end case;

   end loop MAIN_LOOP;

   p_primkey := substr(l_prim_key, 1, p_keylen);
   if substr(l_prim_key, 1, p_keylen) <> substr(l_alt_key, 1, p_keylen) then
     p_altkey := substr(l_alt_key, 1, p_keylen);
   else
     p_altkey := null;
   end if;

end generate;
end metaphone;
/
 
