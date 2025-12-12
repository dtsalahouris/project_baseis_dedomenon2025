DELIMITER $
CREATE PROCEDURE proc_calculate_branch_stats(
    IN p_br_code INT,
    OUT p_income DECIMAL(10,2),
    OUT p_expenses DECIMAL(10,2),
    OUT p_profit_margin DECIMAL(10,2)
)
BEGIN 
    DECLARE v_cnt INT;
    SELECT COUNT(*) INTO v_cnt FROM branch WHERE br_code = p_br_code;
    
    IF v_cnt = 0 THEN
        SET p_income = NULL;
        SET p_expenses = NULL;
        SET p_profit_margin = NULL;
    ELSE
        SELECT SUM(r.res_total_cost) INTO p_income FROM reservation r 
        JOIN trip t ON r.res_tr_id = t.tr_id 
        WHERE t.tr_br_code = p_br_code;
        SELECT SUM(w.wrk_salary) INTO p_expenses FROM worker w
        WHERE w.wrk_br_code = p_br_code;

        IF p_expenses > 0 AND p_income IS NOT NULL THEN
            SET p_profit_margin = (p_income - p_expenses) / p_expenses;
        ELSE
            SET p_profit_margin = NULL;
        END IF;
    END IF;
END$
DELIMITER ;