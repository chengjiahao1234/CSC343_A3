-- Highest and Lowest

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO vacationschema, PUBLIC;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5(
    property_id INTEGER,
    highest_price FLOAT,
    lowest_price FlOAT,
    range FLOAT,
    is_highest_range VARCHAR(1)
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS AllWeek CASCADE;

DROP VIEW IF EXISTS Answer CASCADE;


-- Define views for your intermediate steps here:

CREATE VIEW AllWeek AS
SELECT property_id, (start_day + (interval '7' day * generate_series(0, num_of_weeks - 1))) AS weeks
FROM PropertyOrder;

--CREATE VIEW AllPrices AS
--SELECT
--FROM 

-- Your query that answers the question goes below the "insert into" line:
--INSERT INTO q5
--(SELECT * FROM Answer);

