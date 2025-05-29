-- ==========================================
-- Examples of quering JSON documents in SQL
-- ==========================================

-- All nobel prize winner who born in Germany
SELECT 
    JSON_VALUE(laureate,  '$.firstname') AS firstname
    ,JSON_VALUE(laureate, '$.surname')   AS surname
    ,JSON_VALUE(laureate, '$.born')      AS birth_date
FROM laureates
WHERE JSON_EXISTS(laureate, '$?(@.bornCountryCode == "DE")')
ORDER BY TO_DATE(JSON_VALUE(laureate, '$.born'), 'YYYY-MM-DD')
;

-- ALL nobel prize winner who born in Germany, but died else where
SELECT 
    JSON_VALUE(laureate, '$.firstname')     AS firstname
    ,JSON_VALUE(laureate, '$.surname')      AS surname
    ,JSON_VALUE(laureate, '$.diedCountry')  AS died_in
FROM laureates
WHERE JSON_EXISTS(laureate, '$?(@.bornCountryCode == "DE" && @.diedCountryCode != "DE")')
ORDER BY JSON_VALUE(laureate, '$.diedCountryCode')
;

-- Who has won the nobel prize more than one time and in which categories and in which years?
SELECT
    l.laureate.firstname
    ,l.laureate.surname
    ,JSON_VALUE(laureate, '$.prizes.size()' returning number)        AS num_of_wins
    ,JSON_QUERY(laureate, '$.prizes[*].category' WITH ARRAY WRAPPER) AS categories
    ,JSON_QUERY(laureate, '$.prizes[*].year' WITH ARRAY WRAPPER)     AS  years
FROM laureates l
WHERE l.laureate.prizes.size() > 1
ORDER BY l.laureate.prizes.size() DESC;

-- ALL female nobel prize winer
SELECT 
    JSON_VALUE(laureate, '$.firstname')     AS firstname
    ,JSON_VALUE(laureate, '$.surname')      AS surname
    ,JSON_VALUE(laureate, '$.prizes.size()' returning number)        AS num_of_wins
    ,JSON_QUERY(laureate, '$.prizes[*].category' WITH ARRAY WRAPPER) AS categories
FROM laureates l
WHERE JSON_EXISTS(laureate, '$?(@.gender == "female")')
ORDER BY l.laureate.prizes.size() DESC;



