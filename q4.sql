-- Stat by type

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO vacationschema, PUBLIC;
DROP TABLE if EXISTS q4 CASCADE;

CREATE TABLE q4(
    type VARCHAR(10),
    avg_of_guests INTEGER
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS BothCityWater CASCADE;
DROP VIEW IF EXISTS CityP CASCADE;
DROP VIEW IF EXISTS WaterP CASCADE;
DROP VIEW IF EXISTS NoneType CASCADE;
DROP VIEW IF EXISTS BothAnswer CASCADE;
DROP VIEW IF EXISTS CityAnswer CASCADE;
DROP VIEW IF EXISTS WaterAnswer CASCADE;
DROP VIEW IF EXISTS NoneAnswer CASCADE;
DROP VIEW IF EXISTS Answer CASCADE;


-- Define views for your intermediate steps here:

-- The property_id of every property which is both city and water.
CREATE VIEW BothCityWater AS
SELECT DISTINCT P.property_id
FROM PropertyInfo P JOIN CityProperty C ON P.property_id = C.property_id
JOIN WaterProperty W ON P.property_id = W.property_id;

-- The property_id of every property which is city rather than water.
CREATE VIEW CityP AS
SELECT DISTINCT P.property_id
FROM PropertyInfo P JOIN CityProperty C ON P.property_id = C.property_id
WHERE P.property_id NOT IN
(SELECT property_id
FROM BothCityWater);

-- The property_id of every property which is water rather than city.
CREATE VIEW WaterP AS
SELECT DISTINCT P.property_id
FROM PropertyInfo P JOIN WaterProperty W ON P.property_id = W.property_id
WHERE P.property_id NOT IN
(SELECT property_id
FROM BothCityWater);

-- The property_id of every property which is neither city nor water.
CREATE VIEW NoneType AS
(SELECT P.property_id
FROM PropertyInfo P)
EXCEPT
(SELECT property_id
FROM BothCityWater)
EXCEPT
(SELECT property_id
FROM CityP)
EXCEPT
(SELECT property_id
FROM WaterP);

-- The average number of extra guests for properties of city & water type.
CREATE VIEW BothAnswer AS
SELECT 'Both' AS type, 
CASE WHEN count(B.property_id) = 0
THEN 0
ELSE sum(num_of_renters)/count(B.property_id) 
END AS avg_of_guests
FROM BothCityWater B LEFT JOIN PropertyOrder O ON B.property_id = O.property_id;

-- The average number of extra guests for properties of city type.
CREATE VIEW CityAnswer AS
SELECT 'City' AS type, 
CASE WHEN count(C.property_id) = 0
THEN 0
ELSE sum(num_of_renters)/count(C.property_id) 
END AS avg_of_guests
FROM CityP C LEFT JOIN PropertyOrder O ON C.property_id = O.property_id;

-- The average number of extra guests for properties of water type.
CREATE VIEW WaterAnswer AS
SELECT 'Water' AS type, 
CASE WHEN count(W.property_id) = 0
THEN 0
ELSE sum(num_of_renters)/count(W.property_id) 
END AS avg_of_guests
FROM WaterP W LEFT JOIN PropertyOrder O ON W.property_id = O.property_id;

-- The average number of extra guests for properties of none type.
CREATE VIEW NoneAnswer AS
SELECT 'Neither' AS type, 
CASE WHEN count(N.property_id) = 0
THEN 0
ELSE sum(num_of_renters)/count(N.property_id) 
END AS avg_of_guests
FROM NoneType N LEFT JOIN PropertyOrder O ON N.property_id = O.property_id;

-- The average number of extra guests for each type.
CREATE VIEW Answer AS
(SELECT * FROM BothAnswer)
UNION
(SELECT * FROM CityAnswer)
UNION
(SELECT * FROM WaterAnswer)
UNION
(SELECT * FROM NoneAnswer);


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q4
(SELECT * FROM Answer);


