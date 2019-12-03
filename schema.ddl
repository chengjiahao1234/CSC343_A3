-- Q: What constraints from the domain could not be enforced,
-- if any?
-- A: The following three constraints from the domain could not 
-- be enforced: 
-- 1. The renter has to be at least 18 years old on the first day 
-- of the rental. 
-- 2. The person cannot be registered for only parts of it. 
-- 3. The number of guests must not exceed the sleeping capacity 
-- of the property. 
-- Since we can't use subquery inside the check block, we 
-- couldn't enforce this constraints without using assertions 
-- or triggers.
--
-- Q: What constraints that could have been enforced were not
-- enforced, if any? Why not?
-- A: No, we don't have any constraint that we don't decide to
-- be enforced.
DROP SCHEMA IF EXISTS vacationschema CASCADE;
CREATE SCHEMA vacationschema;
SET search_path TO vacationschema;

-- The personal information of a certain host.
CREATE TABLE HostInfo (
    host_id INTEGER PRIMARY KEY,
    email VARCHAR(30) NOT NULL
);

-- The info of a property. numBed is the number of
-- bedrooms it has. numBath is the number of bathrooms
-- it has. address indicates the location of the property.
-- capacity is the maximum number of guests the property
-- can include.
CREATE TABLE PropertyInfo (
    property_id INTEGER PRIMARY KEY,
    host_id INTEGER NOT NULL REFERENCES HostInfo,
    num_bed INTEGER NOT NULL,
    num_bath INTEGER NOT NULL,
    address VARCHAR(50) NOT NULL UNIQUE,
    capacity INTEGER NOT NULL,
    hot_tub BOOLEAN NOT NULL,
    sauna BOOLEAN NOT NULL,
    laundry BOOLEAN NOT NULL,
    daily_cleaning BOOLEAN NOT NULL,
    daily_breakfast BOOLEAN NOT NULL,
    concierge BOOLEAN NOT NULL,
    CHECK (capacity >= num_bed),
    CHECK (hot_tub OR sauna OR laundry OR daily_cleaning 
	OR daily_breakfast OR concierge)
);

-- The information of all water properties. propertyType
-- indicates what this property is. For example, this
-- property can be a pool, lake or beach. lifeguarding
-- indicates whether lifeguards has ever been offered.
CREATE TABLE WaterProperty (
    property_id INTEGER REFERENCES PropertyInfo,
    property_type VARCHAR(10) NOT NULL,
    lifeguarding BOOLEAN NOT NULL,
    PRIMARY KEY (property_id, property_type),
    CHECK (property_type IN ('beach', 'lake', 'pool'))
);

-- The information of all city properties. walkability
-- is the integer representation of the traffic.
-- closesTransit is the name of closest transit point.
CREATE TABLE CityProperty (
    property_id INTEGER PRIMARY KEY REFERENCES PropertyInfo,
    walkability INTEGER NOT NULL,
    closest_transit VARCHAR(10) NOT NULL,
    CHECK (walkability >= 0 and walkability <= 100),
    CHECK (closest_transit IN ('bus', 'LRT', 'subway', 'none'))
);

-- The price of a property of a certain week.
CREATE TABLE Price (
    property_id INTEGER REFERENCES PropertyInfo,
    week DATE NOT NULL,
    price FLOAT NOT NULL,
    PRIMARY KEY (property_id, week),
    CHECK (EXTRACT(DOW FROM week) = 6)
);

-- A person who is registered as a guest of the this 
-- vacation rental application.
CREATE TABLE Guest (
    guest_id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    address VARCHAR(50) NOT NULL
) ;

-- A row in this table indicates that a valid renter ordered
-- a property. num_of_renters is the total number of guests who
-- lived in the property, which should not exceed the sleeping
-- capacity of the property. The renter must be at least 18 years
-- old on the first day of the rental. start_day is the first day
-- of the rental.
CREATE TABLE PropertyOrder (
    order_id INTEGER PRIMARY KEY,
    guest_id INTEGER NOT NULL REFERENCES Guest,
    property_id INTEGER NOT NULL REFERENCES PropertyInfo,
    start_day DATE NOT NULL,
    num_of_weeks INTEGER NOT NULL,
    num_of_guests INTEGER NOT NULL,
    cardNum VARCHAR(16) NOT NULL,
    CHECK (num_of_weeks >= 1),
    CHECK (num_of_guests >= 0),
    CHECK (EXTRACT(DOW FROM start_day) = 6)
) ;

-- A row in this table indicates the guest who rent the 
-- property in this PropertyOrder.
CREATE TABLE RentInfo (
    order_id INTEGER NOT NULL REFERENCES PropertyOrder,
    guest_id INTEGER NOT NULL REFERENCES Guest,
    PRIMARY KEY (order_id, guest_id)
) ;

-- To do with Ratings

-- The possible values of a rating.
CREATE DOMAIN score AS SMALLINT
    DEFAULT NULL
    CHECK (VALUE >= 0 AND VALUE <= 5);

-- The guest who rent the property associated with this PropertyOrder
-- gave the rating to the property.
CREATE TABLE PropertyRating (
    order_id INTEGER NOT NULL,
    guest_id INTEGER NOT NULL,
    rating score NOT NULL,
    PRIMARY KEY (order_id, guest_id),
    Foreign KEY (order_id, guest_id) REFERENCES RentInfo
) ;

-- The renter who rent the property associated with this PropertyOrder
-- gave the rating to the property's host.
CREATE TABLE HostRating (
    order_id INTEGER NOT NULL PRIMARY KEY REFERENCES PropertyOrder,
    rating score NOT NULL
) ;

-- The guest who gave the rating to the property associated 
-- with this PropertyOrder gave the comment to the property.
CREATE TABLE Comments (
    order_id INTEGER NOT NULL,
    guest_id INTEGER NOT NULL,
    comments VARCHAR(200) NOT NULL,
    PRIMARY KEY (order_id, guest_id),
    Foreign KEY (order_id, guest_id) REFERENCES PropertyRating
) ;
