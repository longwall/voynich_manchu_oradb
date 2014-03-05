CREATE OR REPLACE FUNCTION EUCLID_DIST_SIMILARITY ( x IN VARCHAR2, y IN VARCHAR2 )
return NUMBER
AS
 jws number ;
    FUNCTION euclidean_product (x IN NUMBER, y IN NUMBER)
    RETURN NUMBER
  IS
  BEGIN
    RETURN SQRT (x * x + y * y);
  END euclidean_product; 
begin
 jws := UTL_MATCH.JARO_WINKLER_SIMILARITY (x, y) ;
 RETURN euclidean_product(
         .2*UTL_MATCH.EDIT_DISTANCE (x, y),
         60/ CASE jws WHEN 0 THEN 0.001 ELSE jws END );
end EUCLID_DIST_SIMILARITY;
/
