USE travel_agency_2025;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM tripAccommodation WHERE ta_TR_ID IN (3,4,10);
DELETE FROM trip_history WHERE id_taxidiou >= 100;
DELETE FROM customer WHERE cust_email = 'test@test.com';
DELETE FROM vehicle WHERE veh_plate = 'TEST-999';
UPDATE trip SET tr_veh_id = NULL, tr_status = 'PLANNED', tr_veh_km_assign = NULL, tr_veh_km_return = NULL WHERE tr_id IN (1, 2, 6, 7);
UPDATE vehicle SET veh_status = 'AVAILABLE' WHERE veh_id IN (1, 2, 3, 4, 5);
UPDATE vehicle SET veh_total_km = 120000 WHERE veh_id = 4;
SET FOREIGN_KEY_CHECKS = 1;

-- 3.1.3.1
CALL sp_assign_vehicle_to_trip(999, 1, 180000);
CALL sp_assign_vehicle_to_trip(1, 999, 180000);
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 1;
CALL sp_assign_vehicle_to_trip(1, 1, 180500);
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 1;

-- 3.1.3.2
CALL procedure_search_accomodations(1, '2025-06-01 14:00:00', '2025-06-05 10:00:00', 5, @first_acc);
SELECT @first_acc AS first_accommodation_found;
CALL procedure_search_accomodations(1, '2025-06-01 14:00:00', '2025-06-05 10:00:00', 50, @first_acc);
SELECT @first_acc AS first_accommodation_found;
CALL procedure_search_accomodations(14, '2025-08-01 14:00:00', '2025-08-05 10:00:00', 2, @first_acc);
SELECT @first_acc AS first_accommodation_found;

-- 3.1.3.3
CALL procedureBookTripAccommodation(1);
CALL procedureBookTripAccommodation(5);

-- 3.1.3.4a
INSERT IGNORE INTO trip_history VALUES 
(100, '2025-01-15', '2025-01-17', 1, 10, 4500.00),
(101, '2025-02-10', '2025-02-15', 2, 8, 6800.00),
(102, '2025-03-05', '2025-03-12', 1, 12, 14400.00);
CALL athroisma_esodon('2025-01-01', '2025-01-31');
CALL athroisma_esodon('2025-01-01', '2025-03-31');
CALL athroisma_esodon('2025-04-01', '2025-04-30');

-- 3.1.3.4b
CALL plithos_proorismon(1);
CALL plithos_proorismon(2);
CALL plithos_proorismon(0);

-- 3.1.4.1
SELECT COUNT(*) AS customer_logs FROM action_log WHERE table_name = 'customer';
INSERT INTO customer(cust_name, cust_lname, cust_email, cust_phone, cust_address, cust_birth_date) 
VALUES ('TestCust', 'TestLname', 'test@test.com', '6999999999', 'Test Address', '1990-01-01');
SELECT COUNT(*) AS customer_logs FROM action_log WHERE table_name = 'customer';
SELECT * FROM action_log WHERE table_name = 'customer' ORDER BY log_id DESC LIMIT 1;

SELECT COUNT(*) AS destination_logs_before FROM action_log WHERE table_name = 'destination';
UPDATE destination SET dst_descr = CONCAT(dst_descr, ' (updated)') WHERE dst_id = 1;
SELECT COUNT(*) AS destination_logs_after FROM action_log WHERE table_name = 'destination';
SELECT * FROM action_log WHERE table_name = 'destination' ORDER BY log_id DESC LIMIT 1;

SELECT COUNT(*) AS vehicle_logs_before FROM action_log WHERE table_name = 'vehicle';
INSERT INTO vehicle(veh_brand, veh_model, veh_plate, veh_capacity, veh_status, veh_total_km, veh_br_code)
VALUES ('TestBrand', 'TestModel', 'TEST-999', 20, 'AVAILABLE', 0, 1);
SELECT COUNT(*) AS vehicle_logs_after FROM action_log WHERE table_name = 'vehicle';
SELECT * FROM action_log WHERE table_name = 'vehicle' ORDER BY log_id DESC LIMIT 1;

SELECT COUNT(*) AS trip_logs_before FROM action_log WHERE table_name = 'trip';
SELECT COUNT(*) AS accommodation_logs_before FROM action_log WHERE table_name = 'accommodation';
SELECT COUNT(*) AS reservation_logs FROM action_log WHERE table_name = 'reservation';
SELECT COUNT(*) AS tripAcc_logs FROM action_log WHERE table_name = 'tripAccommodation';

-- 3.1.4.2
INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (3, 5, '2025-03-06 14:00:00', '2025-03-11 10:00:00', 5);
SELECT ta_NIGHTS, ta_COST FROM tripAccommodation WHERE ta_TR_ID = 3 AND ta_ACC_ID = 5;

INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (4, 7, '2025-04-21 14:00:00', '2025-04-23 10:00:00', 10);
SELECT ta_NIGHTS, ta_COST FROM tripAccommodation WHERE ta_TR_ID = 4 AND ta_ACC_ID = 7;

INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (10, 14, '2025-07-21 14:00:00', '2025-07-22 10:00:00', 8);
SELECT ta_NIGHTS, ta_COST FROM tripAccommodation WHERE ta_TR_ID = 10 AND ta_ACC_ID = 14;

-- 3.1.4.3a
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;
UPDATE trip SET tr_veh_id = 2, tr_veh_km_assign = 95500 WHERE tr_id = 2;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;

SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;
UPDATE trip SET tr_veh_id = 3, tr_veh_km_assign = 85000 WHERE tr_id = 2;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;

UPDATE trip SET tr_veh_id = NULL WHERE tr_id = 2;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;

-- 3.1.4.3b
UPDATE trip SET tr_veh_id = NULL, tr_status = 'PLANNED', tr_veh_km_assign = NULL, tr_veh_km_return = NULL WHERE tr_id = 6;
UPDATE vehicle SET veh_status = 'AVAILABLE', veh_total_km = 120000 WHERE veh_id = 4;

UPDATE trip SET tr_veh_id = 4, tr_veh_km_assign = 120500 WHERE tr_id = 6;
SELECT veh_id, veh_status, veh_total_km FROM vehicle WHERE veh_id = 4;
UPDATE trip SET tr_status = 'COMPLETED', tr_veh_km_return = 121000 WHERE tr_id = 6;
SELECT veh_id, veh_status, veh_total_km FROM vehicle WHERE veh_id = 4;

UPDATE trip SET tr_status = 'PLANNED', tr_veh_km_return = NULL WHERE tr_id = 7;
UPDATE vehicle SET veh_status = 'AVAILABLE' WHERE veh_id = 5;
UPDATE trip SET tr_veh_id = 5, tr_veh_km_assign = 75000 WHERE tr_id = 7;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 5;
UPDATE trip SET tr_status = 'CANCELLED' WHERE tr_id = 7;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 5;

SELECT table_name, action_type, COUNT(*) as count 
FROM action_log 
GROUP BY table_name, action_type 
ORDER BY table_name, action_type;
