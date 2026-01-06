DELIMITER $

CREATE PROCEDURE procedureBookTripAccommodation(
    IN p_TR_ID INT
)
BEGIN
    DECLARE v_FINISHED INT DEFAULT 0;
    DECLARE v_DEST_ID INT;
    DECLARE v_ARRIVAL DATETIME;
    DECLARE v_DEPARTURE DATETIME;
    DECLARE v_NEEDED_ROOMS INT;
    DECLARE v_ACCID_FOUND INT;
    DECLARE v_ERROR INT DEFAULT 0;

    DECLARE DEST_CURSOR CURSOR FOR
    SELECT to_dst_id, to_arrival, to_departure FROM travel_to 
    WHERE to_tr_id = p_TR_ID
    ORDER BY to_sequence;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_FINISHED = 1;

    SELECT CEIL(tr_maxseats/2) INTO v_NEEDED_ROOMS
    FROM trip WHERE tr_id = p_TR_ID;

    OPEN DEST_CURSOR;

    trip_LOOP: LOOP    
        FETCH DEST_CURSOR INTO v_DEST_ID,v_ARRIVAL,v_DEPARTURE;
        IF v_FINISHED = 1 THEN 
            LEAVE trip_LOOP;
        END IF;

        CALL procedure_search_accomodations(v_DEST_ID,v_ARRIVAL,v_DEPARTURE,v_NEEDED_ROOMS,v_ACCID_FOUND);

        IF v_ACCID_FOUND IS NULL THEN
            SET v_ERROR = 1;
            LEAVE trip_LOOP;
        ELSE
            INSERT INTO tripAccommodation(ta_TR_ID,ta_ACC_ID,ta_CHECKIN,ta_CHECKOUT,ta_ROOMS)
            VALUES (p_TR_ID,v_ACCID_FOUND,v_ARRIVAL,v_DEPARTURE,v_NEEDED_ROOMS);
        END IF;
    END LOOP;

    CLOSE DEST_CURSOR;

    IF v_ERROR = 1 THEN
        DELETE FROM tripAccommodation WHERE ta_TR_ID = p_TR_ID;
        SELECT CONCAT('ERROR: the accommodation was not found for this destination id',v_DEST_ID,'all bookings are cancelled') AS Message;
    ELSE
        SELECT
            a.acc_NAME AS 'ACCOMODATION',
            ta.ta_CHECKIN AS 'CHECK IN',
            ta.ta_CHECKOUT AS 'CHECK OUT',
            ta.ta_NIGHTS AS 'NIGHTS',
            ta.ta_COST AS 'COST'
        FROM tripAccommodation ta 
        JOIN accommodation a ON ta.ta_ACC_ID = a.acc_ID
        WHERE ta.ta_TR_ID = p_TR_ID;

        SELECT SUM(ta_COST) AS 'TOTAL TRIP COST'
        FROM tripAccommodation
        WHERE ta_TR_ID = p_TR_ID;
    END IF;

END $
DELIMITER ;