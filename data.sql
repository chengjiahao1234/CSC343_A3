INSERT INTO HostInfo VALUES
(101, 'luke@gmail.com'),
(102, 'leia@gmail.com'),
(103, 'han@gmail.com');

INSERT INTO PropertyInfo VALUES
(1, 101, 3, 1, 'Tatooine', 6, true, false, false, true, false, false), 
(2, 102, 1, 1, 'Alderaan', 2, true, true, false, true, false, false),
(3, 103, 2, 1, 'Corellia', 3, false, false, false, false, true, true), 
(4, 102, 2, 1, 'Verona', 2, false, false, true, false, false, false),
(5, 103, 2, 2, 'Florence', 4, true, false, false, false, false, false),
(6, 101, 1, 1, 'Toronto', 2, true, true, true, true, false, true); 

INSERT INTO WaterProperty VALUES
(2, 'lake', false);

INSERT INTO CityProperty VALUES
(3, 20, 'bus');

-- INSERT INTO PropertyHost VALUES
-- (101, 11),
-- (102, 11),
-- (103, 12),
-- (104, 12),
-- (105, 13);

INSERT INTO Price VALUES
(2, '2019-01-05', 580),
(3, '2019-01-12', 750),
(3, '2019-01-19', 750),
(2, '2019-01-12', 600),
(5, '2019-01-12', 1220),
(5, '2019-01-05', 1000);

INSERT INTO Guest VALUES
(1001, 'Darth Vader', '1985-12-06', 'Death Star'),
(1002, 'Leia, Princess', '2001-10-05', 'Alderaan'),
(1003, 'Romeo Montague', '1988-05-11', 'Verona'),
(1004, 'Juliet Capulet', '1997-01-01', 'Verona'),
(1005, 'Mercutio', '1988-03-03', 'Verona'),
(1006, 'Chewbacca', '1998-09-15', 'Kashyyyk');

INSERT INTO PropertyOrder VALUES
(10001, 1001, 2, '2019-01-05', 1, 1, '3466704824219330'),
(10002, 1002, 3, '2019-01-12', 2, 2, '6011253896008199'),
(10003, 1003, 2, '2019-01-12', 1, 1, '5446447451075463'),
(10004, 1005, 5, '2019-01-05', 1, 2, '4666153163329984'),
(10005, 1006, 5, '2019-01-12', 1, 1, '6011624297465933');

INSERT INTO RentInfo VALUES
(10001, 1001),
(10001, 1002),
(10002, 1002),
(10002, 1004),
(10002, 1003),
(10003, 1003),
(10003, 1004),
(10004, 1005),
(10004, 1003),
(10004, 1001),
(10005, 1006),
(10005, 1002);

INSERT INTO PropertyRating VALUES
(10001, 1001, 2),
(10001, 1002, 5),
(10002, 1003, 5),
(10002, 1004, 5),
(10002, 1002, 1),
(10003, 1004, 5),
(10004, 1005, 1),
(10004, 1003, 1),
(10005, 1006, 3);

INSERT INTO HostRating VALUES
(10001, 2),
(10002, 5),
(10003, 3),
(10004, 4),
(10005, 4);

INSERT INTO Comments VALUES
(10001, 1001, 'Looks like she hides rebel scum here.'),
(10002, 1002, 'A bit scruffy, could do with more 
regular housekeeping'),
(10005, 1006, 'Fantastic, arggg');


