USE travel_agency_2025;

INSERT INTO reservation(res_tr_id, res_seatnum, res_cust_id, res_status, res_total_cost) VALUES
(1, 4, 4, 'PAID', 1000.00),
(1, 5, 5, 'PAID', 1000.00),
(1, 6, 6, 'PAID', 1000.00),
(4, 3, 10, 'PAID', 1000.00),
(4, 4, 11, 'PAID', 1000.00);

SELECT '--- Κατάσταση Υποκαταστημάτων ---' AS Info;
SELECT b.br_code AS Υποκατάστημα,
       COALESCE((SELECT SUM(r.res_total_cost) FROM reservation r JOIN trip t ON r.res_tr_id = t.tr_id WHERE t.tr_br_code = b.br_code), 0) AS Έσοδα,
       (SELECT SUM(w.wrk_salary) FROM worker w WHERE w.wrk_br_code = b.br_code) AS Έξοδα,
       CASE 
           WHEN COALESCE((SELECT SUM(r.res_total_cost) FROM reservation r JOIN trip t ON r.res_tr_id = t.tr_id WHERE t.tr_br_code = b.br_code), 0) > 
                (SELECT SUM(w.wrk_salary) FROM worker w WHERE w.wrk_br_code = b.br_code)
           THEN 'ΚΕΡΔΟΦΟΡΟ'
           ELSE 'ΖΗΜΙΟΓΟΝΟ'
       END AS Κατάσταση
FROM branch b;

SELECT '3.1 Περίπτωση: Υποκατάστημα δεν υπάρχει' AS Δοκιμή;

SET @income = 0;
SET @expenses = 0;
SET @profit_margin = 0;

CALL proc_calculate_branch_stats(999, @income, @expenses, @profit_margin);

SELECT 'Κωδικός υποκαταστήματος: 999 (δεν υπάρχει)' AS Είσοδος;
SELECT @income AS Έσοδα, @expenses AS Έξοδα, @profit_margin AS Ποσοστό_Κέρδους;
SELECT 'Αναμενόμενο: Όλες οι τιμές NULL' AS Αποτέλεσμα;

SELECT '3.2 Περίπτωση: Αύξηση μισθού σε ζημιογόνο υποκατάστημα' AS Δοκιμή;

SELECT 'Εργαζόμενος AT00000007 στο υποκατάστημα 6 (ζημιογόνο)' AS Πληροφορία;
SELECT wrk_AT, wrk_name, wrk_lname, wrk_salary, wrk_br_code FROM worker WHERE wrk_AT = 'AT00000007';
SELECT 'Προσπάθεια αύξησης μισθού από 1200.00 σε 1210.00...' AS Ενέργεια;

SELECT '3.3 Περίπτωση: Αύξηση ≤2% σε κερδοφόρο υποκατάστημα' AS Δοκιμή;

SELECT 'Εργαζόμενος AT00000001 στο υποκατάστημα 1 (κερδοφόρο)' AS Πληροφορία;
SELECT wrk_AT, wrk_name, wrk_lname, wrk_salary, wrk_br_code FROM worker WHERE wrk_AT = 'AT00000001';
SELECT 'Τρέχων μισθός: 1500.00, 2% = 30.00, Μέγιστη επιτρεπτή αύξηση: 1530.00' AS Υπολογισμός;

SELECT '3.4 Περίπτωση: Αύξηση >2% σε κερδοφόρο υποκατάστημα' AS Δοκιμή;

SELECT 'Εργαζόμενος AT00000001 στο υποκατάστημα 1 (κερδοφόρο)' AS Πληροφορία;
SELECT 'Προσπάθεια αύξησης μισθού από 1500.00 σε 1600.00 (6.67% αύξηση)...' AS Ενέργεια;
