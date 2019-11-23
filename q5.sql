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
DROP VIEW IF EXISTS HighestAndLowest CASCADE;
DROP VIEW IF EXISTS HighestRange CASCADE;
DROP VIEW IF EXISTS Answer CASCADE;


-- Define views for your intermediate steps here:

--CREATE VIEW AllWeek AS
--SELECT property_id, (start_day + (interval '7' day * 
--generate_series(0, num_of_weeks - 1))) AS weeks
--FROM PropertyOrder;

-- The highest price and lowest price ever charged of a week for properties 
-- which ever be rented.
CREATE VIEW HighestAndLowest AS
	SELECT Price.property_id, max(price) AS highest, min(price) AS lowest, 
	max(price) - min(price) AS range
	FROM Price 
		JOIN PropertyOrder ON PropertyOrder.property_id = Price.property_id
			AND PropertyOrder.start_day <= Price.week
			AND PropertyOrder.start_day + 7 * (PropertyOrder.num_of_weeks - 1) 
				>= Price.week
	GROUP BY Price.property_id;

-- The highest range of all properties from HighestAndLowest
CREATE VIEW HighestRange AS
SELECT max(range) as max_range
FROM HighestAndLowest;

-- The highest price, lowest price, the range, and a column 
-- indicating whether it's the highest range for properties
-- which ever be rented.
CREATE VIEW Answer AS
SELECT property_id, highest, lowest, range, 
CASE WHEN range = max_range
THEN '*'
ELSE ''
END AS is_highest_range
FROM HighestAndLowest, HighestRange;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5
(SELECT * FROM Answer);

