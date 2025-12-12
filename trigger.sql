DELIMITER $
CREATE TRIGGER trg_check_salary_increase
BEFORE UPDATE ON worker
FOR EACH ROW
BEGIN
    DECLARE v_income DECIMAL(10,2);
    DECLARE v_expenses DECIMAL(10,2);
    DECLARE v_profit_margin DECIMAL(10,2);

    IF NEW.wrk_salary > OLD.wrk_salary THEN 
        CALL proc_calculate_branch_stats(OLD.wrk_br_code, v_income,v_expenses,v_profit_margin);
        IF v_profit_margin IS NULL OR v_profit_margin < 0 THEN 
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, salary increase denied. the branch is not operating profitably';
        ELSE
            IF (NEW.wrk_salary - OLD.wrk_salary) > (OLD.wrk_salary * 0.02) THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Error, salary increase is denied because it exceeds the 2 percent cap';
            END IF;
        END IF;

    END IF;
END $
DELIMITER ;