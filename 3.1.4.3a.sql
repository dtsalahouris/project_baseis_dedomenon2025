DELIMITER $

DROP TRIGGER IF EXISTS trg_trip_assign_vehicle $
CREATE TRIGGER trg_trip_assign_vehicle
BEFORE UPDATE ON trip 
FOR EACH ROW
BEGIN 

     IF NEW.tr_veh_id IS NOT NULL
       AND (OLD.tr_veh_id IS NULL OR OLD.tr_veh_id <> NEW.tr_veh_id) THEN


    
    IF OLD.tr_veh_id IS NOT NULL AND OLD.tr_veh_id <> NEW.tr_veh_id THEN
            UPDATE vehicle
            SET veh_status = 'AVAILABLE'
            WHERE veh_id = OLD.tr_veh_id;
        END IF;

    
    IF (SELECT veh_status FROM vehicle WHERE veh_id = NEW.tr_veh_id) <> 'AVAILABLE' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Vehicle is not AVAILABLE for assignment.';
        END IF;

    UPDATE vehicle
        SET veh_status = 'IN_USE'
        WHERE veh_id = NEW.tr_veh_id;
    END IF;


 IF OLD.tr_veh_id IS NOT NULL AND NEW.tr_veh_id IS NULL THEN
        UPDATE vehicle
        SET veh_status = 'AVAILABLE'
        WHERE veh_id = OLD.tr_veh_id;
    END IF;

END $

DELIMITER ;



    

