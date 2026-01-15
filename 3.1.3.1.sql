DELIMITER $$
DROP PROCEDURE IF EXISTS sp_assign_vehicle_to_trip $$
CREATE PROCEDURE sp_assign_vehicle_to_trip(
    IN p_tr_id INT,
    IN p_veh_id INT,
    IN p_current_km INT
)
proc: BEGIN 
     DECLARE v_ok_vehicle_available TINYINT DEFAULT 0;
     DECLARE v_ok_seats TINYINT DEFAULT 0;
     DECLARE v_ok_license TINYINT DEFAULT 0;
     DECLARE v_ok_overlap TINYINT DEFAULT 0;
     DECLARE v_ok_km TINYINT DEFAULT 0;


     DECLARE v_tr_departure DATETIME;
     DECLARE v_tr_return DATETIME;
     DECLARE v_tr_drv CHAR(10);
     

     DECLARE v_veh_status VARCHAR(20);
     DECLARE v_veh_capacity INT;
     DECLARE v_veh_total_km INT;

     DECLARE v_res_cnt INT DEFAULT 0;
     DECLARE v_overlap_cnt INT DEFAULT 0;

     DECLARE v_drv_license CHAR(1);

     IF NOT EXISTS (SELECT 1 FROM trip WHERE tr_id = p_tr_id) THEN 
          SELECT
          'FAIL (trip does not exist)' AS chk_trip,
         NULL AS chk_vehicle,
         NULL AS chk_vehicle_available,
         NULL AS chk_seats_sufficient,
         NULL AS chk_driver_license,
         NULL AS chk_no_overlap,
         'NOT ASSIGNED' AS result_msg;
         LEAVE proc;
     END IF;

     IF NOT EXISTS (SELECT 1 FROM vehicle WHERE veh_id = p_veh_id) THEN 
          SELECT 'OK' AS chk_trip,
          'FAIL  (vehicle does not exist)' AS chk_vehicle,
         NULL AS chk_vehicle,
         NULL AS chk_vehicle_available,
         NULL AS chk_seats_sufficient,
         NULL AS chk_driver_license,
         NULL AS chk_no_overlap,
         'NOT ASSIGNED' AS result_msg;
         LEAVE proc;
     END IF;

    

     SELECT tr_departure,tr_return , tr_drv_AT
          INTO v_tr_departure,v_tr_return,v_tr_drv
          FROM trip 
          WHERE tr_id = p_tr_id;

    SELECT veh_status, veh_capacity 
    INTO v_veh_status , v_veh_capacity
    FROM vehicle
    WHERE veh_id = p_veh_id;

    IF v_veh_status = 'AVAILABLE' THEN 
    SET v_ok_vehicle_available = 1;
    END IF;

    SELECT COUNT(*) 
    INTO v_res_cnt FROM reservation WHERE res_tr_id = p_tr_id
    AND res_status <> 'CANCELLED';

    IF v_res_cnt <= v_veh_capacity THEN SET v_ok_seats = 1;
    END IF;

    SELECT drv_license INTO v_drv_license FROM driver WHERE drv_AT = v_tr_drv;

    IF v_veh_capacity > 9 THEN 
    IF v_drv_license IN ('C','D') THEN SET v_ok_license = 1;
    END IF;
    ELSE 
    IF v_drv_license IN ('B','C','D') THEN SET v_ok_license = 1;
    END IF;
    END IF;

    SELECT COUNT(*) 
    INTO v_overlap_cnt FROM trip t2 
    WHERE t2.tr_id <> p_tr_id 
    AND t2.tr_veh_id = p_veh_id 
    AND t2.tr_departure < v_tr_return 
    AND t2.tr_return > v_tr_departure;

    IF v_overlap_cnt = 0 THEN SET v_ok_overlap = 1;
    END IF;

    SELECT  
    'OK' AS chk_trip,
    'OK' AS chk_vehicle, 
    IF(v_ok_vehicle_available = 1,'OK','FAIL') AS chk_vehicle_available,
    CONCAT(IF(v_ok_seats = 1, 'OK','FAIL'),'(reservations=',v_res_cnt,'/ capacity=',v_veh_capacity,')')AS chk_seats_sufficient,
    CONCAT(IF(v_ok_license=1,'OK','FAIL'),' (driver_license=',IFNULL(v_drv_license,'NULL'),')') AS chk_driver_license,
      IF(v_ok_overlap=1,'OK','FAIL') AS chk_no_overlap;
    
    IF v_ok_vehicle_available = 1
    AND v_ok_seats = 1
    AND v_ok_license = 1
    AND v_ok_overlap = 1
    
    THEN 
       UPDATE trip 
       SET tr_veh_id = p_veh_id,
       tr_veh_km_assign = p_current_km
       WHERE tr_id = p_tr_id;

       UPDATE vehicle
       SET veh_total_km = p_current_km,
           veh_status = 'IN_USE'
       WHERE veh_id = p_veh_id;


     SELECT 'ASSIGNED' AS result_msg;
     ELSE 
     SELECT 'NOT ASSIGNED' AS result_msg;
     END IF;
     END $$

     DELIMITER ;  


    

