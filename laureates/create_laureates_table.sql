-- DROP TABLE laureates;
-- TRUNCATE TABLE laureates;

CREATE TABLE laureates(
  laureate CLOB CHECK (laureate IS JSON)
);
