DELIMITER $

DROP TRIGGER IF EXISTS trg_trip_return_vehicle $
CREATE TRIGGER trg_trip_return_vehicle 
AFTER UPDATE ON trip 
FOR EACH ROW 
BEGIN 

 IF NEW.tr_veh_id IS NOT NULL
       AND NEW.tr_status = 'COMPLETED'
       AND NEW.tr_veh_km_return IS NOT NULL
       AND (OLD.tr_status <> 'COMPLETED' OR OLD.tr_veh_km_return IS NULL) THEN

 IF NEW.tr_veh_km_assign IS NOT NULL AND NEW.tr_veh_km_return < NEW.tr_veh_km_assign THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Return km is less than assigned km. Update rejected.';
        END IF;



     IF NEW.tr_veh_km_return < (SELECT veh_total_km FROM vehicle WHERE veh_id = NEW.tr_veh_id) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Return km is less than vehicle total km. Update rejected.';
        END IF;


    UPDATE vehicle 
    SET veh_total_km = NEW.tr_veh_km_return,veh_status = 'AVAILABLE'
    WHERE veh_id = NEW.tr_veh_id;
    END IF;


    IF NEW.tr_veh_id IS NOT NULL 
        AND OLD.tr_status <> NEW.tr_status
        AND NEW.tr_status = 'CANCELLED' THEN 
        UPDATE vehicle 
        SET veh_status = 'AVAILABLE'
        WHERE veh_id = NEW.tr_veh_id;
        END IF;
        END $ 

        DELIMITER ; 