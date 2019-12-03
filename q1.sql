SET SEARCH_PATH TO vacationschema, PUBLIC;
--DROP TABLE IF EXISTS q1 CASCADE;

--CREATE TABLE q1(
--    num_hot_tub INTEGER,
--    num_sauna INTEGER,
--    num_concierge INTEGER,
--    num_breakfast INTEGER,
--    num_laundry INTEGER,
--    num_cleaning INTEGER
--);

DROP VIEW IF EXISTS NumHotTub CASCADE;
DROP VIEW IF EXISTS NumSauna CASCADE;
DROP VIEW IF EXISTS NumLaundry CASCADE;
DROP VIEW IF EXISTS NumCleaning CASCADE;
DROP VIEW IF EXISTS NumBreakfast CASCADE;
DROP VIEW IF EXISTS NumConcierge CASCADE;

--The number of properties with hot tub
CREATE VIEW NumHotTub AS 
	SELECT count(hot_tub) AS HotTub
	FROM PropertyInfo
	where hot_tub;

--The number of properties with sauna
CREATE VIEW NumSauna AS 
	SELECT count(sauna) AS Sauna
	FROM PropertyInfo
	WHERE sauna;

--The number of properties with laundry
CREATE VIEW NumLaundry AS 
	SELECT count(laundry) AS Laundry
	FROM PropertyInfo
	WHERE laundry;

--The number of properties with daily cleaning
CREATE VIEW NumCleaning AS 
	SELECT count(daily_cleaning) AS DailyCleaning
	FROM PropertyInfo
	WHERE daily_cleaning;

--The number of properties with daily breakfast delivery
CREATE VIEW NumBreakfast AS 
	SELECT count(daily_breakfast) AS DailyBreakfast
	FROM PropertyInfo
	WHERE daily_breakfast;

--The number of properties with concierge.
CREATE VIEW NumConcierge AS 
	SELECT count(concierge) AS Concierge
	FROM PropertyInfo
	WHERE concierge;


SELECT *
	FROM NumHotTub, NumSauna, NumConcierge, 
	NumBreakfast, NumLaundry, NumCleaning;
