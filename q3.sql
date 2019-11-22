SET SEARCH_PATH TO vacationschema, public;
DROP TABLE IF EXISTS q3 cascade;

CREATE TABLE q3(
    host_id INTEGER,
    email VARCHAR(30),
    average_rating SCORE,
    most_expensive_price FLOAT
);

DROP VIEW IF EXISTS HostToRatings CASCADE;
DROP VIEW IF EXISTS HighestRatingHost CASCADE;
DROP VIEW IF EXISTS ExpensiveBookingWeek CASCADE;
DROP VIEW IF EXISTS FinalResult CASCADE;

--This table associates the information of a host to his average rating.
CREATE VIEW HostToRatings AS 
	SELECT PropertyInfo.host_id, email, avg(rating) AS AverageRating
	FROM HostRating 
		JOIN PropertyOrder ON HostRating.order_id = PropertyOrder.order_id
		JOIN PropertyInfo ON PropertyOrder.property_id = PropertyInfo.property_id
		JOIN HostInfo ON PropertyInfo.host_id = HostInfo.host_id
	GROUP BY PropertyInfo.host_id, email;

--This table finds the host with highest average rating.
CREATE VIEW HighestRatingHost AS
	SELECT *
	FROM HostToRatings
	WHERE AverageRating = (SELECT max(AverageRating) FROM HostToRatings);

--A row in this table indicates the price of the most expensive booking week ever
--recorded of a every host.
CREATE VIEW ExpensiveBookingWeek AS
	SELECT host_id, max(price) as price
	FROM Price 
		JOIN PropertyOrder ON PropertyOrder.property_id = Price.property_id
			AND PropertyOrder.start_day <= Price.week
			AND PropertyOrder.start_day + 7 * (PropertyOrder.num_of_weeks - 1) >= Price.week
		JOIN PropertyInfo ON PropertyOrder.property_id = PropertyInfo.property_id
	GROUP BY host_id;

--This table associates information of the host with highest average rating to his most 
--expensive booking week as a final result.
CREATE VIEW FinalResult AS
	SELECT HighestRatingHost.host_id, HighestRatingHost.email, HighestRatingHost.AverageRating,
		ExpensiveBookingWeek.price
	FROM HighestRatingHost join ExpensiveBookingWeek 
		ON HighestRatingHost.host_id = ExpensiveBookingWeek.host_id;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3
	(SELECT * FROM FinalResult);
