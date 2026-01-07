DELIMITER $

DROP TRIGGER IF EXISTS trg_trip_assign_vehicle $
CREATE TRIGGER trg_trip_assign_vehicle 
BEFORE UPDATE ON trip 
FOR EACH ROW
BEGIN 
   IF OLD.tr_veh_id IS NULL AND NEW.tr_veh_id IS NOT NULL THEN 

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

DROP TRIGGER IF EXISTS trg_trip_return_vehicle $
CREATE TRIGGER trg_trip_return_vehicle
AFTER UPDATE ON trip 
FOR EACH ROW

BEGIN 
     IF NEW.tr_veh_id IS NOT NULL 
        AND OLD.tr_status <> NEW.tr_status 
        AND NEW.tr_status IN ('COMPLETED','CANCELLED') THEN 

        UPDATE vehicle
        SET veh_status = 'AVAILABLE'
        WHERE veh_id = NEW.tr_veh_id; 
        END IF;

END $

DELIMITER ; 