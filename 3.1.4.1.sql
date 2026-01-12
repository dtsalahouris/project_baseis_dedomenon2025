-- TRIP

DROP TRIGGER IF EXISTS trip_insert;
DELIMITER $
CREATE TRIGGER trip_insert
AFTER INSERT ON trip
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('trip', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS trip_update;
DELIMITER $
CREATE TRIGGER trip_update
AFTER UPDATE ON trip
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('trip', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS trip_delete;
DELIMITER $
CREATE TRIGGER trip_delete
AFTER DELETE ON trip
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('trip', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

-- RESERVATION

DROP TRIGGER IF EXISTS reservation_insert;
DELIMITER $
CREATE TRIGGER reservation_insert
AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('reservation', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS reservation_update;
DELIMITER $$
CREATE TRIGGER reservation_update
AFTER UPDATE ON reservation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('reservation', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS reservation_delete;
DELIMITER $$
CREATE TRIGGER reservation_delete
AFTER DELETE ON reservation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('reservation', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;


-- CUSTOMER

DROP TRIGGER IF EXISTS customer_insert;
DELIMITER $
CREATE TRIGGER customer_insert
AFTER INSERT ON customer
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('customer', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS customer_update;
DELIMITER $
CREATE TRIGGER customer_update
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('customer', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS customer_delete;
DELIMITER $
CREATE TRIGGER customer_delete
AFTER DELETE ON customer
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('customer', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;


-- DESTINATION


DROP TRIGGER IF EXISTS destination_insert;
DELIMITER $
CREATE TRIGGER destination_insert
AFTER INSERT ON destination
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('destination', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS destination_update;
DELIMITER $
CREATE TRIGGER destination_update
AFTER UPDATE ON destination
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('destination', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

DROP TRIGGER IF EXISTS destination_delete;
DELIMITER $
CREATE TRIGGER destination_delete
AFTER DELETE ON destination
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('destination', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$
DELIMITER ;

-- VEHICLE

DROP TRIGGER IF EXISTS vehicle_insert;
DELIMITER $$
CREATE TRIGGER vehicle_insert
AFTER INSERT ON vehicle
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('vehicle', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS vehicle_update;
DELIMITER $$
CREATE TRIGGER vehicle_update
AFTER UPDATE ON vehicle
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('vehicle', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS vehicle_delete;
DELIMITER $$
CREATE TRIGGER vehicle_delete
AFTER DELETE ON vehicle
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('vehicle', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

-- ACCOMMODATION

DROP TRIGGER IF EXISTS accommodation_insert;
DELIMITER $$
CREATE TRIGGER accommodation_insert
AFTER INSERT ON accommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('accommodation', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS accommodation_update;
DELIMITER $$
CREATE TRIGGER accommodation_update
AFTER UPDATE ON accommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('accommodation', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS accommodation_delete;
DELIMITER $$
CREATE TRIGGER accommodation_delete
AFTER DELETE ON accommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('accommodation', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

-- TRIP ACCOMMODATION (tripAccommodation)

DROP TRIGGER IF EXISTS tripAccommodation_insert;
DELIMITER $$
CREATE TRIGGER tripAccommodation_insert
AFTER INSERT ON tripAccommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('tripAccommodation', 'INSERT', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS tripAccommodation_update;
DELIMITER $$
CREATE TRIGGER tripAccommodation_update
AFTER UPDATE ON tripAccommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('tripAccommodation', 'UPDATE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS tripAccommodation_delete;
DELIMITER $$
CREATE TRIGGER tripAccommodation_delete
AFTER DELETE ON tripAccommodation
FOR EACH ROW
BEGIN
  INSERT INTO action_log (table_name, action_type, date_time, dba_user)
  VALUES ('tripAccommodation', 'DELETE', NOW(), SUBSTRING_INDEX(CURRENT_USER(),'@',1));
END$$
DELIMITER ;

