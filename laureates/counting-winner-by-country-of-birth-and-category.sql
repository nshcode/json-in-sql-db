-- Counting winner by country of birth and category
WITH
cat_bcc(cat, bcc) AS (
  SELECT
    JSON_VALUE(laureate, '$.prizes[0].category') AS cat
    ,CASE 
      WHEN JSON_VALUE(laureate, '$.gender') = 'org' THEN 'Org'
      ELSE JSON_VALUE(laureate, '$.bornCountryCode')
     END AS bcc
  FROM laureates
  WHERE JSON_VALUE(laureate, '$.prizes[0].category') IS NOT NULL
  UNION ALL
  SELECT
    JSON_VALUE(laureate, '$.prizes[1].category') AS cat
    ,CASE 
      WHEN JSON_VALUE(laureate, '$.gender') = 'org' THEN 'Org'
      ELSE JSON_VALUE(laureate, '$.bornCountryCode')
     END AS bcc
  FROM laureates
  WHERE JSON_VALUE(laureate, '$.prizes[1].category') IS NOT NULL
  UNION ALL
  SELECT
    JSON_VALUE(laureate, '$.prizes[2].category') AS cat
    ,CASE 
      WHEN JSON_VALUE(laureate, '$.gender') = 'org' THEN 'Org'
      ELSE JSON_VALUE(laureate, '$.bornCountryCode')
     END AS bcc
  FROM laureates
  WHERE JSON_VALUE(laureate, '$.prizes[2].category') IS NOT NULL
)
 SELECT 
    COALESCE(bcc, 'NA')                   AS Bcc
    ,SUM(DECODE(cat, 'physics', 1, 0))    AS Physics
    ,SUM(DECODE(cat, 'chemistry', 1, 0))  AS Chemistry
    ,SUM(DECODE(cat, 'medicine', 1, 0))   AS Medicine
    ,SUM(DECODE(cat, 'economics', 1, 0))  AS Economics
    ,SUM(DECODE(cat, 'literature', 1, 0)) AS Literature
    ,SUM(DECODE(cat, 'peace', 1, 0))      AS Peace
    ,SUM(1)                               AS Total_BY_Country_Of_Birth
    ,CASE 
      WHEN bcc = 'Org'  THEN 'Organization'
      WHEN bcc IS NULL  THEN 'Country of birth is not available'
      ELSE 'No comment'
    END                                  AS "Comment"
FROM cat_bcc
GROUP BY bcc
ORDER BY 
  CASE 
    WHEN bcc = 'Org' THEN 0 
    WHEN bcc = 'NA'  THEN -1 
    ELSE Total_BY_Country_Of_Birth
  END DESC
;