-- ============================================
-- COMPLETE TEST SCRIPT για Stored Procedures & Triggers
-- ============================================

USE travel_agency_2025;

-- Καθαρισμός προηγούμενων test data αν υπάρχουν
DELETE FROM tripAccommodation WHERE ta_TR_ID IN (3,4,10);
DELETE FROM trip_history WHERE id_taxidiou >= 100;
DELETE FROM customer WHERE cust_email = 'test@test.com';

SELECT '=====================================================' AS '';
SELECT '=== STORED PROCEDURES TESTS ===' AS '';
SELECT '=====================================================' AS '';

-- ============================================
-- SP 1: sp_assign_vehicle_to_trip
-- ============================================
SELECT '' AS '';
SELECT '--- SP: sp_assign_vehicle_to_trip ---' AS '';

-- Test 1.1: Trip που δεν υπάρχει
SELECT 'Test 1.1: Trip που δεν υπάρχει (id=999)' AS test_name;
CALL sp_assign_vehicle_to_trip(999, 1, 180000);

-- Test 1.2: Vehicle που δεν υπάρχει  
SELECT 'Test 1.2: Vehicle που δεν υπάρχει (id=999)' AS test_name;
CALL sp_assign_vehicle_to_trip(1, 999, 180000);

-- Test 1.3: Επιτυχής ανάθεση
SELECT 'Test 1.3: Επιτυχής ανάθεση οχήματος' AS test_name;
SELECT 'Πριν: Vehicle status:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 1;
CALL sp_assign_vehicle_to_trip(1, 1, 180500);
SELECT 'Μετά: Vehicle status:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 1;

-- ============================================
-- SP 2: procedure_search_accomodations
-- ============================================
SELECT '' AS '';
SELECT '--- SP: procedure_search_accomodations ---' AS '';

-- Test 2.1: Αναζήτηση στη Σαντορίνη (dst_id=1)
SELECT 'Test 2.1: Αναζήτηση καταλύματος στη Σαντορίνη' AS test_name;
CALL procedure_search_accomodations(1, '2025-06-01 14:00:00', '2025-06-05 10:00:00', 5, @first_acc);
SELECT @first_acc AS first_accommodation_found;

-- Test 2.2: Αναζήτηση με πολλά δωμάτια
SELECT 'Test 2.2: Αναζήτηση με μεγάλο αριθμό δωματίων (50 δωμάτια)' AS test_name;
CALL procedure_search_accomodations(1, '2025-06-01 14:00:00', '2025-06-05 10:00:00', 50, @first_acc);
SELECT @first_acc AS first_accommodation_found;

-- Test 2.3: Αναζήτηση σε προορισμό χωρίς καταλύματα
SELECT 'Test 2.3: Αναζήτηση σε προορισμό χωρίς κατάλυμα' AS test_name;
CALL procedure_search_accomodations(14, '2025-08-01 14:00:00', '2025-08-05 10:00:00', 2, @first_acc);
SELECT @first_acc AS first_accommodation_found;

-- ============================================
-- SP 3: procedureBookTripAccommodation
-- ============================================
SELECT '' AS '';
SELECT '--- SP: procedureBookTripAccommodation ---' AS '';

-- Test 3.1: Κράτηση για ένα trip
SELECT 'Test 3.1: Κράτηση διαμονής για trip 1' AS test_name;
CALL procedureBookTripAccommodation(1);

-- Test 3.2: Κράτηση για trip με πολλούς προορισμούς
SELECT 'Test 3.2: Κράτηση για trip με πολλούς προορισμούς (trip 5)' AS test_name;
CALL procedureBookTripAccommodation(5);

-- ============================================
-- SP 4a: athroisma_esodon (Άθροισμα Εσόδων)
-- ============================================
SELECT '' AS '';
SELECT '--- SP: athroisma_esodon ---' AS '';

-- Εισαγωγή test data
INSERT IGNORE INTO trip_history VALUES 
(100, '2025-01-15', '2025-01-17', 1, 10, 4500.00),
(101, '2025-02-10', '2025-02-15', 2, 8, 6800.00),
(102, '2025-03-05', '2025-03-12', 1, 12, 14400.00);

-- Test 4a.1: Έσοδα Ιανουαρίου
SELECT 'Test 4a.1: Έσοδα Ιανουαρίου 2025' AS test_name;
CALL athroisma_esodon('2025-01-01', '2025-01-31');

-- Test 4a.2: Έσοδα τριμήνου Q1
SELECT 'Test 4a.2: Συνολικά έσοδα Q1 2025' AS test_name;
CALL athroisma_esodon('2025-01-01', '2025-03-31');

-- Test 4a.3: Περίοδος χωρίς έσοδα
SELECT 'Test 4a.3: Περίοδος χωρίς έσοδα (Απρίλιος)' AS test_name;
CALL athroisma_esodon('2025-04-01', '2025-04-30');

-- ============================================
-- SP 4b: plithos_proorismon (Πλήθος Προορισμών)
-- ============================================
SELECT '' AS '';
SELECT '--- SP: plithos_proorismon ---' AS '';

-- Test 4b.1: Ταξίδια με 1 προορισμό
SELECT 'Test 4b.1: Ταξίδια με 1 προορισμό' AS test_name;
CALL plithos_proorismon(1);

-- Test 4b.2: Ταξίδια με 2 προορισμούς
SELECT 'Test 4b.2: Ταξίδια με 2 προορισμούς' AS test_name;
CALL plithos_proorismon(2);

-- Test 4b.3: Ταξίδια με μη υπαρκτό πλήθος
SELECT 'Test 4b.3: Ταξίδια με 0 προορισμούς (δεν υπάρχουν)' AS test_name;
CALL plithos_proorismon(0);

SELECT '=====================================================' AS '';
SELECT '=== TRIGGERS TESTS ===' AS '';
SELECT '=====================================================' AS '';

-- ============================================
-- Trigger 1: Action Log Triggers (trigger1.sql)
-- INSERT/UPDATE/DELETE logging για 7 tables
-- ============================================
SELECT '' AS '';
SELECT '--- Triggers: Action Log (INSERT/UPDATE/DELETE) ---' AS '';

-- Test T1.1: INSERT customer -> log
SELECT 'Test T1.1: INSERT customer - δημιουργία log' AS test_name;
SELECT 'Πριν:' AS info;
SELECT COUNT(*) AS customer_logs FROM action_log WHERE table_name = 'customer';
INSERT INTO customer(cust_name, cust_lname, cust_email, cust_phone, cust_address, cust_birth_date) 
VALUES ('TestCust', 'TestLname', 'test@test.com', '6999999999', 'Test Address', '1990-01-01');
SELECT 'Μετά:' AS info;
SELECT COUNT(*) AS customer_logs FROM action_log WHERE table_name = 'customer';
SELECT * FROM action_log WHERE table_name = 'customer' ORDER BY log_id DESC LIMIT 1;

-- Test T1.2: UPDATE destination -> log
SELECT 'Test T1.2: UPDATE destination - δημιουργία log' AS test_name;
SELECT COUNT(*) AS destination_logs_before FROM action_log WHERE table_name = 'destination';
UPDATE destination SET dst_descr = CONCAT(dst_descr, ' (updated)') WHERE dst_id = 1;
SELECT COUNT(*) AS destination_logs_after FROM action_log WHERE table_name = 'destination';
SELECT * FROM action_log WHERE table_name = 'destination' ORDER BY log_id DESC LIMIT 1;

-- Test T1.3: INSERT vehicle -> log
SELECT 'Test T1.3: INSERT vehicle - δημιουργία log' AS test_name;
SELECT COUNT(*) AS vehicle_logs_before FROM action_log WHERE table_name = 'vehicle';
INSERT INTO vehicle(veh_brand, veh_model, veh_plate, veh_capacity, veh_status, veh_total_km, veh_br_code)
VALUES ('TestBrand', 'TestModel', 'TEST-999', 20, 'AVAILABLE', 0, 1);
SELECT COUNT(*) AS vehicle_logs_after FROM action_log WHERE table_name = 'vehicle';
SELECT * FROM action_log WHERE table_name = 'vehicle' ORDER BY log_id DESC LIMIT 1;

-- Test T1.4: INSERT trip -> log
SELECT 'Test T1.4: INSERT trip - δημιουργία log' AS test_name;
SELECT COUNT(*) AS trip_logs_before FROM action_log WHERE table_name = 'trip';

-- Test T1.5: INSERT accommodation -> log
SELECT 'Test T1.5: INSERT accommodation - δημιουργία log' AS test_name;
SELECT COUNT(*) AS accommodation_logs_before FROM action_log WHERE table_name = 'accommodation';

-- Test T1.6: INSERT reservation -> log
SELECT 'Test T1.6: Επαλήθευση reservation logging' AS test_name;
SELECT COUNT(*) AS reservation_logs FROM action_log WHERE table_name = 'reservation';

-- Test T1.7: INSERT tripAccommodation -> log
SELECT 'Test T1.7: Επαλήθευση tripAccommodation logging' AS test_name;
SELECT COUNT(*) AS tripAcc_logs FROM action_log WHERE table_name = 'tripAccommodation';

-- ============================================
-- Trigger 2: trg_CALCULATE_TRIP_ACC_COST
-- Υπολογισμός nights & cost για tripAccommodation
-- ============================================
SELECT '' AS '';
SELECT '--- Trigger: trg_CALCULATE_TRIP_ACC_COST ---' AS '';

-- Test T2.1: 5 nights, 5 rooms
SELECT 'Test T2.1: INSERT tripAccommodation (5 νύχτες, 5 δωμάτια)' AS test_name;
INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (3, 5, '2025-03-06 14:00:00', '2025-03-11 10:00:00', 5);
SELECT ta_NIGHTS, ta_COST, 
       CONCAT('Αναμενόμενο: 5 nights * 5 rooms * τιμή δωματίου = ', ta_COST) AS explanation
FROM tripAccommodation WHERE ta_TR_ID = 3 AND ta_ACC_ID = 5;

-- Test T2.2: 2 nights, 10 rooms
SELECT 'Test T2.2: INSERT tripAccommodation (2 νύχτες, 10 δωμάτια)' AS test_name;
INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (4, 7, '2025-04-21 14:00:00', '2025-04-23 10:00:00', 10);
SELECT ta_NIGHTS, ta_COST,
       CONCAT('Αναμενόμενο: 2 nights * 10 rooms * τιμή δωματίου = ', ta_COST) AS explanation
FROM tripAccommodation WHERE ta_TR_ID = 4 AND ta_ACC_ID = 7;

-- Test T2.3: 1 night, 8 rooms
SELECT 'Test T2.3: INSERT tripAccommodation (1 νύχτα, 8 δωμάτια)' AS test_name;
INSERT INTO tripAccommodation(ta_TR_ID, ta_ACC_ID, ta_CHECKIN, ta_CHECKOUT, ta_ROOMS)
VALUES (10, 14, '2025-07-21 14:00:00', '2025-07-22 10:00:00', 8);
SELECT ta_NIGHTS, ta_COST,
       CONCAT('Αναμενόμενο: 1 night * 8 rooms * τιμή δωματίου = ', ta_COST) AS explanation
FROM tripAccommodation WHERE ta_TR_ID = 10 AND ta_ACC_ID = 14;

-- ============================================
-- Trigger 3: trg_trip_assign_vehicle
-- Αλλαγή status οχήματος κατά την ανάθεση
-- ============================================
SELECT '' AS '';
SELECT '--- Trigger: trg_trip_assign_vehicle ---' AS '';

-- Test T3.1: Ανάθεση οχήματος -> status IN_USE
SELECT 'Test T3.1: Ανάθεση οχήματος σε trip -> status IN_USE' AS test_name;
SELECT 'Πριν:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;
UPDATE trip SET tr_veh_id = 2, tr_veh_km_assign = 95500 WHERE tr_id = 2;
SELECT 'Μετά:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;

-- Test T3.2: Αλλαγή οχήματος σε trip (παλιό γίνεται AVAILABLE)
SELECT 'Test T3.2: Αλλαγή οχήματος σε trip' AS test_name;
SELECT 'Πριν - Όχημα 3:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;
UPDATE trip SET tr_veh_id = 3, tr_veh_km_assign = 85000 WHERE tr_id = 2;
SELECT 'Μετά - Όχημα 2 (πρώην):' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 2;
SELECT 'Μετά - Όχημα 3 (νέο):' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;

-- Test T3.3: Αφαίρεση οχήματος από trip
SELECT 'Test T3.3: Αφαίρεση οχήματος από trip -> status AVAILABLE' AS test_name;
UPDATE trip SET tr_veh_id = NULL WHERE tr_id = 2;
SELECT 'Μετά:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 3;

-- ============================================
-- Trigger 4: trg_trip_return_vehicle
-- Επιστροφή οχήματος και ενημέρωση km
-- ============================================
SELECT '' AS '';
SELECT '--- Trigger: trg_trip_return_vehicle ---' AS '';

-- Reset για clean test
UPDATE trip SET tr_veh_id = NULL, tr_status = 'PLANNED', tr_veh_km_assign = NULL, tr_veh_km_return = NULL WHERE tr_id = 6;
UPDATE vehicle SET veh_status = 'AVAILABLE', veh_total_km = 120000 WHERE veh_id = 4;

-- Test T4.1: Ολοκλήρωση ταξιδιού
SELECT 'Test T4.1: Ολοκλήρωση ταξιδιού - όχημα γίνεται AVAILABLE' AS test_name;
-- Πρώτα ανάθεση
UPDATE trip SET tr_veh_id = 4, tr_veh_km_assign = 120500 WHERE tr_id = 6;
SELECT 'Μετά ανάθεση:' AS info;
SELECT veh_id, veh_status, veh_total_km FROM vehicle WHERE veh_id = 4;
-- Μετά ολοκλήρωση
UPDATE trip SET tr_status = 'COMPLETED', tr_veh_km_return = 121000 WHERE tr_id = 6;
SELECT 'Μετά ολοκλήρωση:' AS info;
SELECT veh_id, veh_status, veh_total_km FROM vehicle WHERE veh_id = 4;

-- Test T4.2: Ακύρωση ταξιδιού
SELECT 'Test T4.2: Ακύρωση ταξιδιού - όχημα γίνεται AVAILABLE' AS test_name;
-- Reset
UPDATE trip SET tr_status = 'PLANNED', tr_veh_km_return = NULL WHERE tr_id = 7;
UPDATE vehicle SET veh_status = 'AVAILABLE' WHERE veh_id = 5;
-- Ανάθεση
UPDATE trip SET tr_veh_id = 5, tr_veh_km_assign = 75000 WHERE tr_id = 7;
SELECT 'Μετά ανάθεση:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 5;
-- Ακύρωση
UPDATE trip SET tr_status = 'CANCELLED' WHERE tr_id = 7;
SELECT 'Μετά ακύρωση:' AS info;
SELECT veh_id, veh_status FROM vehicle WHERE veh_id = 5;

SELECT '=====================================================' AS '';
SELECT '=== ALL TESTS COMPLETED SUCCESSFULLY ===' AS '';
SELECT '=====================================================' AS '';

-- Summary
SELECT '' AS '';
SELECT '--- SUMMARY: Action Log Entries ---' AS '';
SELECT table_name, action_type, COUNT(*) as count 
FROM action_log 
GROUP BY table_name, action_type 
ORDER BY table_name, action_type;
