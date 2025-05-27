-- ======================================================
-- Converting a JSON collection into a relational table
-- using the JSON_TABLE operator
-- ======================================================
SELECT 
  j.*
FROM laureates, 
  JSON_TABLE(laureate, '$'
    COLUMNS (
      f_name          VARCHAR2 PATH '$.firstname'
      ,l_name         VARCHAR2 PATH '$.surname'
      ,gender         VARCHAR2 PATH  '$.gender'
      ,date_of_birth  DATE     PATH '$.born'
      ,date_of_death  DATE     PATH '$.died'
      ,born_in        VARCHAR2 PATH  '$.bornCountry'
      ,died_in        VARCHAR2 PATH  '$.diedCountry'
      ,NESTED PATH '$.prizes[*]'
            COLUMNS (
              category VARCHAR2 PATH '$.category'
              ,year    INTEGER  PATH  '$.year'
              ,NESTED PATH          '$.affiliations[*]'
                    COLUMNS (
                      affiliation         VARCHAR2 PATH '$.name'
                      ,affiliation_city   VARCHAR2 PATH '$.city'
                      ,affiliation_country VARCHAR2 PATH '$.city'
                    )
              ,motivation VARCHAR2 PATH '$.motivation'
            )
    )
) j
ORDER BY j.year, j.category
;