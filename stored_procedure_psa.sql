DELIMITER $

CREATE PROCEDURE procedure_search_accomodations(
    IN p_DST_ID INT,
    IN p_DATE_IN DATETIME,
    IN p_DATE_OUT DATETIME,
    IN p_ROOMS INT,
    OUT p_FIRST_ACC_ID INT
)

BEGIN
    SET p_FIRST_ACC_ID = NULL;

    SELECT a.acc_ID INTO p_FIRST_ACC_ID
    FROM accommodation a WHERE a.acc_DEST_ID = p_DST_ID
    AND a.acc_STATUS = 'ACTIVE' 
    AND(a.acc_ROOMS - (
        SELECT COALESCE(SUM(ta.ta_ROOMS),0)
        FROM tripAccommodation ta WHERE ta.ta_ACC_ID = a.acc_ID
        AND(ta.ta_CHECKIN < p_DATE_OUT AND ta.ta_CHECKOUT > p_DATE_IN)
    )) >= p_ROOMS
    ORDER BY a.acc_ROOM_PRICE ASC, a.acc_STARS DESC, a.acc_RATING DESC 
    LIMIT 1;

    SELECT
        a.acc_NAME AS 'NAME',
        a.acc_TYPE AS 'TYPE',
        CONCAT(a.acc_STREET, ' ', a.acc_NUMBER, ' ',a.acc_CITY) AS 'ADDRESS',
        a.acc_PHONE AS 'PHONE', 
        a.acc_STARS AS 'STARS',
        a.acc_RATING AS 'RATING',
        a.acc_ROOM_PRICE AS 'PRICE',
        GROUP_CONCAT(am.am_NAME SEPARATOR ', ') AS 'AMENITIES',
        (a.acc_ROOMS -(
            SELECT COALESCE(SUM(ta.ta_ROOMS),0)
            FROM tripAccommodation ta WHERE ta.ta_ACC_ID = a.acc_ID
            AND (ta.ta_CHECKIN < p_DATE_OUT and ta.ta_CHECKOUT > p_DATE_IN)
        )) AS 'AVAILABLE_ROOMS' 
    FROM accommodation a 
    LEFT JOIN accommodationAmenities am ON a.acc_ID = am.am_ACC_ID WHERE a.acc_DEST_ID = p_DST_ID
    AND a.acc_STATUS = 'ACTIVE'
    GROUP BY a.acc_ID HAVING AVAILABLE_ROOMS >= p_ROOMS
    ORDER BY a.acc_ROOM_PRICE ASC, a.acc_STARS DESC, a.acc_RATING DESC;
END $
DELIMITER ;
