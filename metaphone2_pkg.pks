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
 *  The package consists of two functions and a procedure:
 *
 *    generate - a procedure that creates a primary and alternate key from an input string.  Arguments are:
 *
 *           p_string  - input string (usually a last name)  [input]
 *           p_keylen  - key length to create (usually 4)    [input]
 *           p_primkey - variable to store the primary key   [output]
 *           p_altkey  - variable to store the alternate key [output]
 *
 *    genprimkey - a function to return the primary key.  This function is marked "deterministic" so it can be used
 *                 in an index.  It also caches the most recent input string and key length as well as the result
 *                 strings.  This avoids calling generate multiple times for the same input string. Arguments are:
 *
 *           p_string  - input string (usually a last name)  [input]
 *           p_keylen  - key length to create (usually 4)    [input]
 *
 *           returns a varchar2 with the primary key
 *
 *    genaltkey  - a function to return the alternate key.  This function is marked "deterministic" so it can be used
 *                 in an index.  It also caches the most recent input string and key length as well as the result
 *                 strings.  This avoids calling generate multiple times for the same input string.
 *
 *           p_string  - input string (usually a last name)  [input]
 *           p_keylen  - key length to create (usually 4)    [input]
 *
 *           returns a varchar2 with the primary key
 *
 */

CREATE OR REPLACE PACKAGE METAPHONE_pkg
as
  input_string    varchar2(255);
  keylen    integer;
  primkey    varchar2(50);
  altkey    varchar2(50);
  primmatch    varchar2(20);
  altmatch    varchar2(20);
  lname        varchar2(20);

  function genprimkey(p_string in varchar2, p_keylen in integer)
  return varchar2 deterministic;

  function genaltkey(p_string in varchar2, p_keylen in integer)
  return varchar2 deterministic;

  procedure generate (p_string in varchar2, p_keylen in integer, p_primkey out nocopy varchar2, p_altkey out nocopy varchar2);

end metaphone_pkg;
/ 

