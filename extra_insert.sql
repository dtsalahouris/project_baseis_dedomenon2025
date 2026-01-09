USE travel_agency_2025;
SET FOREIGN_KEY_CHECKS = 0;


INSERT INTO language_ref(lang_code, lang_name) VALUES
('IT', 'Italian'),
('ES', 'Spanish'),
('RU', 'Russian');


INSERT INTO worker(wrk_AT, wrk_name, wrk_lname, wrk_email, wrk_salary, wrk_br_code) VALUES
('AT00000027', 'Giorgos', 'Katsaros', 'g.katsaros@agency.gr', 1520.00, 1),
('AT00000028', 'Eleni', 'Karagianni', 'e.karagianni@agency.gr', 1480.00, 2),
('AT00000029', 'Nikos', 'Samaras', 'n.samaras@agency.gr', 1410.00, 3),
('AT00000030', 'Maria', 'Kotsou', 'm.kotsou@agency.gr', 1390.00, 4),
('AT00000031', 'Dimitris', 'Papageorgiou', 'd.papageorgiou@agency.gr', 1600.00, 5),
('AT00000032', 'Katerina', 'Stavropoulou', 'k.stavropoulou@agency.gr', 920.00, 6),
('AT00000033', 'Panagiotis', 'Theodorou', 'p.theodorou@agency.gr', 880.00, 2),
('AT00000034', 'Ioanna', 'Mavridou', 'i.mavridou@agency.gr', 950.00, 1),
('AT00000035', 'Christos', 'Anagnostou', 'c.anagnostou@agency.gr', 910.00, 3),
('AT00000036', 'Sofia', 'Lazaridou', 's.lazaridou@agency.gr', 990.00, 4),
('AT00000037', 'Vasilis', 'Antonakis', 'v.antonakis@agency.gr', 1020.00, 5),
('AT00000038', 'Niki', 'Papantoniou', 'n.papantoniou@agency.gr', 980.00, 6),
('AT00000039', 'Alexandros', 'Kyriazis', 'a.kyriazis@agency.gr', 1100.00, 1);


INSERT INTO admin (adm_AT, adm_type, adm_diploma) VALUES
('AT00000027', 'ADMINISTRATIVE', 'Πτυχίο Διοίκησης Επιχειρήσεων'),
('AT00000028', 'LOGISTICS', 'Μεταπτυχιακό στη Διοίκηση Logistics'),
('AT00000029', 'ACCOUNTING', 'Πτυχίο Λογιστικής & Χρηματοοικονομικών'),
('AT00000030', 'ADMINISTRATIVE', 'Δίπλωμα Γραμματειακής Υποστήριξης'),
('AT00000031', 'LOGISTICS', 'Πιστοποίηση Supply Chain Management');


INSERT INTO branch (br_code, br_street, br_num, br_city, br_manager_AT) VALUES
(7, 'Stadiou', 12, 'Athens', 'AT00000027'),
(8, 'Egnatia', 80, 'Thessaloniki', 'AT00000028'),
(9, 'Agiou Andreou', 35, 'Patras', 'AT00000029');


INSERT INTO manages(mng_adm_AT, mng_br_code) VALUES
('AT00000027', 7),
('AT00000028', 8),
('AT00000029', 9);


INSERT INTO phones(ph_br_code, ph_number) VALUES
(7, '2103301122'),
(7, '2103301133'),
(8, '2310556677'),
(9, '2610223344'),
(9, '2610223355');


INSERT INTO driver(drv_AT, drv_license, drv_route, drv_experience) VALUES
('AT00000032', 'D', 'LOCAL', 14),
('AT00000033', 'C', 'ABROAD', 24),
('AT00000034', 'B', 'LOCAL', 10),
('AT00000035', 'C', 'ABROAD', 18);


INSERT INTO guide(gui_AT, gui_cv) VALUES
('AT00000036', 'Ξεναγός με ειδίκευση σε αρχαιολογικούς χώρους και ιστορικούς περιπάτους'),
('AT00000037', 'Πιστοποιημένος ξεναγός πόλεων – μουσεία, αρχιτεκτονική, πολιτισμός'),
('AT00000038', 'Οικοτουρισμός & πεζοπορία – ορεινές διαδρομές και φυσιολατρικές ξεναγήσεις'),
('AT00000039', 'Γαστρονομικές ξεναγήσεις και τοπική κουλτούρα – εμπειρία 8 ετών');


INSERT INTO languages(lng_gui_AT, lng_language_code) VALUES
('AT00000036', 'GR'),
('AT00000037', 'EN'),
('AT00000038', 'FR'),
('AT00000039', 'IT');


INSERT INTO destination(dst_id, dst_name, dst_descr, dst_rtype, dst_language_code, dst_location) VALUES
(11, 'Fira', 'Κεντρικός οικισμός στη Σαντορίνη με θέα στην καλντέρα', 'LOCAL', 'GR', 1),
(12, 'Nafplio', 'Ιστορική πόλη με παλιά πόλη, Παλαμήδι και Μπούρτζι', 'LOCAL', 'GR', NULL),
(13, 'Milan', 'Ιταλική μητρόπολη της μόδας και της αρχιτεκτονικής', 'ABROAD', 'IT', NULL),
(14, 'Madrid', 'Πρωτεύουσα της Ισπανίας με μουσεία και ζωντανή νυχτερινή ζωή', 'ABROAD', 'ES', NULL),
(15, 'Moscow', 'Πόλη με ιστορία και αξιοθέατα όπως το Κρεμλίνο', 'ABROAD', 'RU', NULL);


INSERT INTO trip(tr_id, tr_departure, tr_return, tr_maxseats, tr_cost_adult, tr_cost_child, tr_status, tr_min_participants, tr_br_code, tr_gui_AT, tr_drv_AT) VALUES
(15, '2025-10-10 08:00:00', '2025-10-12 20:00:00', 30, 410.00, 260.00, 'PLANNED', 8, 7, 'AT00000036', 'AT00000032'),
(16, '2025-10-25 07:30:00', '2025-10-29 21:30:00', 25, 920.00, 620.00, 'PLANNED', 10, 8, 'AT00000037', 'AT00000033'),
(17, '2025-11-08 09:00:00', '2025-11-10 19:00:00', 20, 300.00, 190.00, 'PLANNED', 6, 9, 'AT00000038', 'AT00000034'),
(18, '2025-11-20 06:45:00', '2025-11-24 22:00:00', 35, 780.00, 520.00, 'PLANNED', 12, 7, 'AT00000039', 'AT00000035'),
(19, '2025-12-05 08:15:00', '2025-12-07 18:45:00', 28, 360.00, 240.00, 'PLANNED', 7, 8, 'AT00000036', 'AT00000032'),
(20, '2025-12-18 07:00:00', '2025-12-22 21:00:00', 26, 860.00, 590.00, 'PLANNED', 10, 9, 'AT00000037', 'AT00000033'),
(21, '2026-01-08 09:30:00', '2026-01-11 20:30:00', 22, 520.00, 340.00, 'PLANNED', 8, 7, 'AT00000038', 'AT00000034');


INSERT INTO travel_to(to_tr_id, to_dst_id, to_arrival, to_departure, to_sequence) VALUES
(15, 12, '2025-10-10 12:30:00', '2025-10-12 10:00:00', 1),
(16, 13, '2025-10-25 16:30:00', '2025-10-29 09:00:00', 1),
(17, 11, '2025-11-08 14:00:00', '2025-11-10 09:30:00', 1),
(18, 14, '2025-11-20 17:30:00', '2025-11-24 10:00:00', 1),
(19, 12, '2025-12-05 12:00:00', '2025-12-07 09:00:00', 1),
(20, 15, '2025-12-18 18:30:00', '2025-12-22 10:00:00', 1),
(21, 11, '2026-01-08 15:00:00', '2026-01-11 10:30:00', 1);


INSERT INTO event(ev_tr_id, ev_start, ev_end, ev_descr) VALUES
(15, '2025-10-10 17:00:00', '2025-10-10 19:00:00', 'Περίπατος στην παλιά πόλη & ελεύθερος χρόνος'),
(15, '2025-10-11 11:00:00', '2025-10-11 13:00:00', 'Ξενάγηση σε κάστρο & ιστορικά σημεία'),

(16, '2025-10-26 10:00:00', '2025-10-26 12:00:00', 'Ξενάγηση σε κέντρο πόλης & αξιοθέατα'),
(16, '2025-10-27 16:00:00', '2025-10-27 18:00:00', 'Μουσείο/πινακοθήκη – οργανωμένη επίσκεψη'),

(17, '2025-11-08 18:00:00', '2025-11-08 20:00:00', 'Τοπική γαστρονομική εμπειρία & δοκιμές'),
(17, '2025-11-09 10:30:00', '2025-11-09 12:30:00', 'Οδηγούμενη πεζοπορία σε φυσική διαδρομή'),

(18, '2025-11-21 10:00:00', '2025-11-21 12:00:00', 'City tour με ιστορικά σημεία'),
(18, '2025-11-22 17:00:00', '2025-11-22 19:00:00', 'Επίσκεψη σε μουσείο & ελεύθερος χρόνος'),

(20, '2025-12-19 11:00:00', '2025-12-19 13:00:00', 'Ξενάγηση σε κεντρικά αξιοθέατα'),
(21, '2026-01-09 16:30:00', '2026-01-09 18:30:00', 'Δραστηριότητα πολιτιστικού χαρακτήρα');


INSERT INTO customer(cust_id, cust_name, cust_lname, cust_email, cust_phone, cust_address, cust_birth_date) VALUES
(21, 'Giorgos', 'Pappas', 'g.pappas@email.com', '6901112233', 'Stadiou 25, Athens', '1990-05-14'),
(22, 'Eleni', 'Kontou', 'e.kontou@email.com', '6902223344', 'Patission 120, Athens', '1995-09-02'),
(23, 'Nikos', 'Makris', 'n.makris@email.com', '6903334455', 'Egnatia 140, Thessaloniki', '1987-01-20'),
(24, 'Maria', 'Vlachou', 'm.vlachou@email.com', '6904445566', 'Tsimiski 88, Thessaloniki', '1998-11-11'),
(25, 'Dimitris', 'Kotronis', 'd.kotronis@email.com', '6905556677', 'Maizonos 90, Patras', '1982-07-30'),
(26, 'Sofia', 'Karali', 's.karali@email.com', '6906667788', 'Agiou Andreou 60, Patras', '1993-03-08'),
(27, 'Panagiotis', 'Delis', 'p.delis@email.com', '6907778899', 'Panepistimiou 35, Athens', '1989-12-22'),
(28, 'Niki', 'Sideri', 'n.sideri@email.com', '6908889900', 'Aristotelous 12, Thessaloniki', '2000-06-05'),
(29, 'Vasilis', 'Koutsis', 'v.koutsis@email.com', '6909990011', 'Riga Fereou 20, Patras', '1991-10-19'),
(30, 'Christina', 'Galanou', 'c.galanou@email.com', '6910001122', 'Akadimias 55, Athens', '1996-02-16');


INSERT INTO reservation(res_tr_id, res_seatnum, res_cust_id, res_status, res_total_cost) VALUES
(15, 1, 21, 'PENDING', 410.00),
(15, 2, 22, 'PENDING', 410.00),
(15, 3, 23, 'CONFIRMED', 410.00),

(16, 1, 24, 'PENDING', 920.00),
(16, 2, 25, 'CONFIRMED', 920.00),

(17, 1, 26, 'PAID', 300.00),
(17, 2, 27, 'PAID', 300.00),

(18, 1, 28, 'PENDING', 780.00),
(18, 2, 29, 'PENDING', 780.00),

(19, 1, 30, 'CONFIRMED', 360.00),
(20, 1, 21, 'PENDING', 860.00),
(21, 1, 22, 'PENDING', 520.00);

SET FOREIGN_KEY_CHECKS = 1;
