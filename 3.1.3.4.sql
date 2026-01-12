-- sp 3.1.3.4a

DROP PROCEDURE IF EXISTS athroisma_esodon;

DELIMITER $

CREATE PROCEDURE athroisma_esodon(
    IN imerominia_1 DATE,
    IN imerominia_2   DATE
)
BEGIN
    SELECT SUM(sinolo_esodon) AS sinolo_esodon_
    FROM trip_history
    WHERE tr_departure BETWEEN imerominia_1 AND imerominia_2;
END $

DELIMITER ;

-- sp 3.1.3.4b

DROP PROCEDURE IF EXISTS plithos_proorismon;

DELIMITER $$

CREATE PROCEDURE plithos_proorismon(
    IN p_plithos_dest INT
)
BEGIN
    SELECT tr_departure, tr_return
    FROM trip_history
    WHERE plithos_dest = p_plithos_dest;
END $$

DELIMITER ;
