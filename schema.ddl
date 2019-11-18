DROP SCHEMA IF EXISTS vacationschema CASCADE;
CREATE SCHEMA vacationschema;
SET search_path TO vacationschema;

-- The info of a property. numBed is the number of
-- bedrooms it has. numBath is the number of bathrooms
-- it has. address indicates the location of the property.
-- capacity is the maximum number of guests the property
-- can include.
CREATE TABLE PropertyInfo (
    property_id INTEGER PRIMARY KEY,
    num_bed INTEGER NOT NULL,
    num_bath INTEGER NOT NULL,
    address VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL,
    CHECK (capacity <= num_bed)
);

-- The information of all water properties. propertyType
-- indicates what this property is. For example, this
-- property can be a pool, lake or beach. lifeguarding
-- indicates whether lifeguards has ever been offered.
CREATE TABLE WaterProperty (
    property_id INTEGER PRIMARY KEY REFERENCES PropertyInfo,
    property_type VARCHAR(10) NOT NULL,
    lifeguarding BOOLEAN NOT NULL
);

-- The information of all city properties. walkability
-- is the integer representation of the traffic.
-- closesTransit is the name of closest transit point.
CREATE TABLE CityProperty (
    property_id INTEGER PRIMARY KEY REFERENCES PropertyInfo,
    walkability INTEGER NOT NULL,
    closest_transit VARCHAR(10) NOT NULL
    CHECK (walkability >= 0 and walkability <= 100)
);

-- The personal information of a certain host.
CREATE TABLE HostInfo (
    host_id INTEGER PRIMARY KEY,
    email VARCHAR(30) NOT NULL
);

-- A row in this table indicates who is the owner of certain
-- property.
CREATE TABLE PropertyHost (
  property_id INTEGER PRIMARY KEY REFERENCES PropertyInfo,
  host_id INTEGER REFERENCES HostInfo NOT NULL  
);

-- The price of a property of a certain week.
CREATE TABLE Price (
    property_id INTEGER REFERENCES PropertyInfo,
    week DATE NOT NULL,
    price INTEGER NOT NULL,
    PRIMARY KEY (property_id, week)
);

-- A row in this table indicates whether or not a luxury
-- services is provided by a certain property.
CREATE TABLE Services (
    property_id INTEGER PRIMARY KEY REFERENCES PropertyInfo,
    hot_tub BOOLEAN NOT NULL,
    sauna BOOLEAN NOT NULL,
    laundry BOOLEAN NOT NULL,
    daily_cleaning BOOLEAN NOT NULL,
    daily_breakfast BOOLEAN NOT NULL,
    concierge BOOLEAN NOT NULL
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
    guest_id INTEGER NOT NULL REFERENCES PaymentInfo,
    property_id INTEGER NOT NULL REFERENCES PropertyInfo,
    start_day DATE NOT NULL,
    num_of_renters INTEGER NOT NULL,
    cardNum INTEGER NOT NULL REFERENCES PaymentInfo,
    check (guest_id IN
    (select guest_id
    from Guest
    where date_part('year' age(start_day, birthday)) >= 18),
    check (guest_id NOT IN
    (select RentInfo.guest_id
    from PropertyOrder join RentInfo
    where PropertyOrder.order_id = RentInfo.order_id
        and PropertyOrder.start_day = start_day
        and PropertyOrder.order_id != order_id)),
    check (property_id IN
    (select property_id
    from PropertyInfo
    where capacity >= num_of_renters))
) ;

-- A row in this table indicates the time period of a
-- PropertyOrder counted week by week.
CREATE TABLE OrderInfo (
    order_id INTEGER NOT NULL REFERENCES PropertyOrder,
    week DATE NOT NULL,
    PRIMARY KEY (order_id, week)
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
CREATE TABLE score AS SMALLINT
    DEFAULT NULL
    CHECK (VALUE >= 0 AND VALUE <= 5);

-- The guest who rent the property associated with this PropertyOrder
-- gave the rating to the property.
CREATE TABLE PropertyRating (
    order_id INTEGER NOT NULL REFERENCES PropertyOrder,
    guest_id INTEGER NOT NULL REFERENCES RentInfo,
    property_id INTEGER NOT NULL REFERENCES PropertyInfo,
    rating score NOT NULL,
    PRIMARY KEY (order_id, guest_id)
) ;

-- The renter who rent the property associated with this PropertyOrder
-- gave the rating to the property's host.
CREATE TABLE HostRating (
    order_id INTEGER NOT NULL REFERENCES PropertyOrder,
    guest_id INTEGER NOT NULL REFERENCES PropertyOrder,
    rating score NOT NULL,
    PRIMARY KEY (order_id, guest_id)
) ;

-- The guest who gave the rating to the property associated 
-- with this PropertyOrder gave the comment to the property.
CREATE TABLE Comments (
    order_id INTEGER NOT NULL REFERENCES PropertyRating,
    guest_id INTEGER NOT NULL REFERENCES PropertyRating,
    comments VARCHAR(200) NOT NULL,
    PRIMARY KEY (order_id, guest_id)
) ;
