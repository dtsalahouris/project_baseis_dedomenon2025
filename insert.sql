USE travel_agency_2025;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO language_ref(lang_code, lang_name) VALUES
('EN', 'English'),
('GR', 'Greek'),
('FR', 'French'),
('DE', 'German'),
('JP', 'Japanese'),
('CN', 'Chinese');

INSERT INTO branch (br_code, br_street, br_num, br_city, br_manager_AT) VALUES
(1, 'Ermou', 15, 'Athens', 'AT00000001'),
(2, 'Tsimiski', 45, 'Thessaloniki', 'AT00000002'),
(3, 'Maizonos', 120, 'Patras', 'AT00000003'),
(4, 'Panepistimiou', 12, 'Athens', 'AT00000004'),
(5, 'Aristotelous', 58, 'Thessaloniki', 'AT00000005'),
(6, 'Karaiskaki', 24, 'Patras', 'AT00000006');

INSERT INTO worker(wrk_AT, wrk_name, wrk_lname, wrk_email, wrk_salary, wrk_br_code) VALUES
('AT00000001', 'Giorgos', 'Papadopoulos', 'g.pap@agency.gr', 1500.00, 1),
('AT00000002', 'Maria', 'Ioannou', 'm.ioan@agency.gr', 1450.00, 2),
('AT00000003', 'Nikos', 'Georgiou', 'n.geor@agency.gr', 1400.00, 3),
('AT00000004', 'Eleni', 'Dimitriou', 'el.dim@agency.gr', 1300.00, 1),
('AT00000005', 'Kostas', 'Nikolou', 'k.nikol@agency.gr', 1350.00, 4),
('AT00000006', 'Vasilis', 'Chalkias', 'v.chalk@agency.gr', 1700.00, 5),
('AT00000007', 'Thodoris', 'Lazarou', 'thod.laz@agency.gr', 1200.00, 6),
('AT00000008', 'Marinnos', 'Triantafyllou', 'mar.triant@agency.gr', 1430.00, 4),
('AT00000009', 'Elena', 'Papageorgiou', 'el.pap@agency.gr', 1550.00, 6),
('AT00000010', 'Niki', 'Paliou', 'niki.pal@agency.gr', 1670.00, 5),
('AT00000011', 'Kostas', 'Oikonomou', 'k.oik@agency.gr', 800.00, 3),
('AT00000012', 'Maria', 'Aggelou', 'm.aggelou@agency.gr', 1100.00, 6),
('AT00000013', 'Aris', 'Roubos', 'ar.roub@agency.gr', 690.00, 2),
('AT00000014', 'Ioannis', 'Mitropoulos', 'i.mitr@agency.gr', 900.00, 1),
('AT00000015', 'Kostas', 'Varouxas', 'k.var@agency.gr', 1000.00, 5),
('AT00000016', 'Vasiliki', 'Augeri', 'v.aug@agency.gr', 730.00, 4),
('AT00000017', 'Theodora', 'Perikou', 'theod.perik@agency.gr', 600.00, 2),
('AT00000018', 'Dimitris', 'Tsarouxis', 'd.tsar@agency.gr', 730.00, 4),
('AT00000019', 'Sofia', 'Tremouli', 'sof.trem@agency.gr', 890.00, 2),
('AT00000020', 'Lydia', 'Riga', 'lyd.rig@agency.gr', 1000.00, 6),
('AT00000021', 'Ermis', 'Krtikos', 'er.kritik@agency.gr', 785.00, 3),
('AT00000022', 'Spyros', 'Papakonstantinou', 'sp.pap@agency.gr', 930.00, 6),
('AT00000023', 'Konstantina', 'Diamantidi', 'kon.diam@agency.gr', 1050.00, 3),
('AT00000024', 'Marilida', 'Dimitriou', 'mar.dim@agency.gr', 980.00, 5),
('AT00000025', 'Markella', 'Loudari', 'mark.loud.perik@agency.gr', 1100.00, 1),
('AT00000026', 'Dimitra', 'Theotokatou', 'd.theot@agency.gr', 840.00, 2);

INSERT INTO admin (adm_AT, adm_type, adm_diploma) VALUES
('AT00000001', 'ADMINISTRATIVE', 'MBA in Management'),
('AT00000002', 'LOGISTICS', 'MSc Logistics'),
('AT00000003', 'ACCOUNTING', 'BSc Economics'),
('AT00000004', 'ADMINISTRATIVE', 'BSc Economics'),
('AT00000005', 'LOGISTICS', 'Diploma in Supply Chain'),
('AT00000006', 'ACCOUNTING', 'MSc Financial Analysis'),
('AT00000007', 'ADMINISTRATIVE', 'Diploma in Office Administration'),
('AT00000008', 'LOGISTICS', 'BSc Transport & Shipping'),
('AT00000009', 'ACCOUNTING', 'Certified Public Accountant'),
('AT00000010', 'LOGISTICS', 'MBA in Supply Chain Management');

INSERT INTO manages(mng_adm_AT, mng_br_code) VALUES
('AT00000001', 1),
('AT00000002', 2),
('AT00000003', 3),
('AT00000004', 4),
('AT00000005', 5),
('AT00000006', 6);

INSERT INTO driver(drv_AT, drv_license, drv_route, drv_experience) VALUES
('AT00000011', 'D', 'LOCAL', 3),
('AT00000012', 'C', 'ABROAD', 6),
('AT00000013', 'A', 'ABROAD', 8),
('AT00000014', 'B', 'ABROAD', 7),
('AT00000015', 'A', 'LOCAL', 5),
('AT00000016', 'C', 'ABROAD', 12),
('AT00000017', 'B', 'ABROAD', 9),
('AT00000018', 'D', 'LOCAL', 11);

INSERT INTO guide(gui_AT, gui_cv) VALUES
('AT00000019', 'History expert with 5 years experience in ancient Greek sites'),
('AT00000020', 'Art history specialist, fluent in French and Japanese'),
('AT00000021', 'Local culture expert with 18 years experience in rural Greece'),
('AT00000022', 'Nature guide with 9 years experience in eco-tourism'),
('AT00000023', 'Archaeology specialist with 6 years experience in excavations'),
('AT00000024', 'Mountain guide, certified in alpine routes and hiking'),
('AT00000025', 'Museum tour professional, multilingual speaker'),
('AT00000026', 'Cultural heritage expert, specializes in Byzantine sites');

INSERT INTO languages(lng_gui_AT, lng_language_code) VALUES
('AT00000019', 'EN'),
('AT00000020', 'JP'),
('AT00000021', 'CN'),
('AT00000022', 'FR'),
('AT00000023', 'DE'),
('AT00000024', 'GR'),
('AT00000025', 'EN'),
('AT00000026', 'JP'),
('AT00000026', 'DE');

INSERT INTO phones(ph_br_code, ph_number) VALUES
(1, '2101234567'),
(1, '2101432768'),
(2, '2310674213'),
(2, '2310987655'),
(3, '2610555555'),
(4, '2101234569'),
(3, '2610468921'),
(2, '2310947134'),
(2, '2310187256'),
(3, '2610354555');

INSERT INTO destination(dst_id, dst_name, dst_descr, dst_rtype, dst_language_code, dst_location) VALUES
(1, 'Santorini', 'Beautiful volcanic island with stunning sunsets and white houses', 'LOCAL', 'GR', NULL),
(2, 'Paris', 'City of lights with iconic Eiffel Tower and world-class museums', 'ABROAD', 'FR', NULL),
(3, 'Tokyo', 'Modern metropolis blending ancient tradition and cutting-edge technology', 'ABROAD', 'JP', NULL),
(4, 'Rome', 'Eternal city with Colosseum, Vatican and ancient Roman ruins', 'ABROAD', 'EN', NULL),
(5, 'Meteora', 'Impressive rock formations with historic monasteries', 'LOCAL', 'GR', NULL),
(6, 'Delphi', 'Ancient sanctuary of Apollo and center of the ancient world', 'LOCAL', 'GR', 5),
(7, 'Berlin', 'Historic German capital with rich culture and vibrant nightlife', 'ABROAD', 'DE', NULL),
(8, 'Barcelona', 'Vibrant Spanish city with Gaudi architecture and beaches', 'ABROAD', 'EN', NULL),
(9, 'Mykonos', 'Famous Cycladic island with windmills and beautiful beaches', 'LOCAL', 'GR', NULL),
(10, 'Amsterdam', 'Dutch capital with canals, Van Gogh Museum and historic center', 'ABROAD', 'EN', NULL);

INSERT INTO trip(tr_id, tr_departure, tr_return, tr_maxseats, tr_cost_adult, tr_cost_child, tr_status, tr_min_participants, tr_br_code, tr_gui_AT, tr_drv_AT) VALUES
(1, '2025-01-15 08:00:00', '2025-01-17 20:00:00', 30, 450.00, 300.00, 'CONFIRMED', 10, 1, 'AT00000019', 'AT00000011'),
(2, '2025-02-10 07:00:00', '2025-02-15 22:00:00', 25, 850.00, 550.00, 'PLANNED', 8, 2, 'AT00000020', 'AT00000012'),
(3, '2025-03-05 09:00:00', '2025-03-12 18:00:00', 20, 1200.00, 800.00, 'PLANNED', 12, 3, 'AT00000021', 'AT00000013'),
(4, '2025-04-20 06:00:00', '2025-04-25 21:00:00', 35, 680.00, 420.00, 'CONFIRMED', 15, 1, 'AT00000022', 'AT00000014'),
(5, '2025-05-01 08:30:00', '2025-05-03 19:00:00', 40, 320.00, 200.00, 'ACTIVE', 5, 4, 'AT00000023', 'AT00000015'),
(6, '2024-11-10 07:00:00', '2024-11-12 20:00:00', 28, 280.00, 180.00, 'COMPLETED', 8, 5, 'AT00000024', 'AT00000016'),
(7, '2024-10-05 06:30:00', '2024-10-08 22:00:00', 22, 520.00, 350.00, 'COMPLETED', 10, 6, 'AT00000025', 'AT00000017'),
(8, '2025-06-15 08:00:00', '2025-06-20 19:00:00', 30, 750.00, 500.00, 'PLANNED', 12, 2, 'AT00000026', 'AT00000018'),
(9, '2025-07-01 07:00:00', '2025-07-05 21:00:00', 25, 620.00, 400.00, 'PLANNED', 10, 3, 'AT00000019', 'AT00000012'),
(10, '2025-07-20 06:00:00', '2025-07-23 20:00:00', 35, 480.00, 320.00, 'PLANNED', 8, 4, 'AT00000020', 'AT00000013'),
(11, '2025-08-05 08:00:00', '2025-08-08 19:00:00', 28, 390.00, 250.00, 'PLANNED', 6, 5, 'AT00000021', 'AT00000014'),
(12, '2025-08-20 07:00:00', '2025-08-25 22:00:00', 22, 890.00, 580.00, 'PLANNED', 12, 6, 'AT00000022', 'AT00000015'),
(13, '2025-09-10 06:30:00', '2025-09-14 20:00:00', 30, 720.00, 480.00, 'PLANNED', 10, 1, 'AT00000023', 'AT00000016'),
(14, '2025-09-25 08:00:00', '2025-09-28 21:00:00', 26, 550.00, 360.00, 'PLANNED', 8, 2, 'AT00000024', 'AT00000017');

INSERT INTO travel_to(to_tr_id, to_dst_id, to_arrival, to_departure, to_sequence) VALUES
(1, 1, '2025-01-15 14:00:00', '2025-01-17 10:00:00', 1),
(2, 2, '2025-02-10 18:00:00', '2025-02-14 08:00:00', 1),
(3, 3, '2025-03-06 06:00:00', '2025-03-11 20:00:00', 1),
(4, 4, '2025-04-20 16:00:00', '2025-04-24 10:00:00', 1),
(5, 5, '2025-05-01 12:00:00', '2025-05-02 17:00:00', 1),
(5, 6, '2025-05-02 18:00:00', '2025-05-03 14:00:00', 2),
(6, 5, '2024-11-10 11:00:00', '2024-11-11 18:00:00', 1),
(6, 6, '2024-11-11 19:00:00', '2024-11-12 15:00:00', 2),
(7, 7, '2024-10-05 16:00:00', '2024-10-08 10:00:00', 1),
(8, 2, '2025-06-15 18:00:00', '2025-06-19 10:00:00', 1),
(9, 8, '2025-07-01 17:00:00', '2025-07-04 10:00:00', 1),
(10, 9, '2025-07-20 14:00:00', '2025-07-22 18:00:00', 1),
(11, 10, '2025-08-05 16:00:00', '2025-08-07 12:00:00', 1),
(12, 4, '2025-08-20 18:00:00', '2025-08-24 10:00:00', 1),
(13, 1, '2025-09-10 14:00:00', '2025-09-13 10:00:00', 1),
(14, 7, '2025-09-25 17:00:00', '2025-09-27 12:00:00', 1);

INSERT INTO event(ev_tr_id, ev_start, ev_end, ev_descr) VALUES
(1, '2025-01-15 16:00:00', '2025-01-15 18:00:00', 'Sunset viewing at Oia village'),
(1, '2025-01-16 10:00:00', '2025-01-16 13:00:00', 'Wine tasting tour at local vineyard'),
(2, '2025-02-11 09:00:00', '2025-02-11 12:00:00', 'Eiffel Tower visit and photo session'),
(2, '2025-02-12 14:00:00', '2025-02-12 17:00:00', 'Louvre Museum guided tour'),
(3, '2025-03-07 10:00:00', '2025-03-07 14:00:00', 'Tokyo Imperial Palace and gardens tour'),
(3, '2025-03-08 09:00:00', '2025-03-08 18:00:00', 'Mount Fuji day trip with lunch'),
(4, '2025-04-21 09:00:00', '2025-04-21 13:00:00', 'Colosseum and Roman Forum guided tour'),
(4, '2025-04-22 10:00:00', '2025-04-22 15:00:00', 'Vatican Museums and Sistine Chapel visit'),
(5, '2025-05-01 14:00:00', '2025-05-01 17:00:00', 'Meteora monasteries hiking tour'),
(6, '2024-11-10 13:00:00', '2024-11-10 16:00:00', 'Great Meteoron Monastery guided visit'),
(7, '2024-10-06 10:00:00', '2024-10-06 14:00:00', 'Berlin Wall Memorial and history tour'),
(8, '2025-06-16 10:00:00', '2025-06-16 13:00:00', 'Seine River cruise with lunch'),
(8, '2025-06-17 09:00:00', '2025-06-17 17:00:00', 'Versailles Palace full day tour'),
(9, '2025-07-02 10:00:00', '2025-07-02 14:00:00', 'Sagrada Familia guided tour'),
(9, '2025-07-03 09:00:00', '2025-07-03 13:00:00', 'Park Guell and Gaudi architecture walk'),
(10, '2025-07-21 10:00:00', '2025-07-21 16:00:00', 'Mykonos beach day and town exploration'),
(11, '2025-08-06 09:00:00', '2025-08-06 15:00:00', 'Van Gogh Museum and canal cruise'),
(12, '2025-08-21 10:00:00', '2025-08-21 14:00:00', 'Roman Forum and Palatine Hill exploration'),
(13, '2025-09-11 15:00:00', '2025-09-11 18:00:00', 'Caldera sunset cruise with dinner'),
(14, '2025-09-26 09:00:00', '2025-09-26 13:00:00', 'Brandenburg Gate and Reichstag tour');

INSERT INTO customer(cust_id, cust_name, cust_lname, cust_email, cust_phone, cust_address, cust_birth_date) VALUES
(1, 'Alexandros', 'Papadakis', 'alex.pad@email.com', '6971234567', 'Kifisias 45, Athens', '1985-03-15'),
(2, 'Christina', 'Vlachou', 'chr.vlach@email.com', '6942345678', 'Egnatias 120, Thessaloniki', '1990-07-22'),
(3, 'Panagiotis', 'Konstantinou', 'pan.konst@email.com', '6983456789', 'Korinthou 89, Patras', '1978-11-08'),
(4, 'Dimitra', 'Andreou', 'dim.andr@email.com', '6954567890', 'Vouliagmenis 200, Athens', '1992-02-14'),
(5, 'Stavros', 'Makris', 'stav.mak@email.com', '6915678901', 'Mitropoleos 55, Athens', '1988-09-30'),
(6, 'Anna', 'Papanikolaou', 'anna.papan@email.com', '6926789012', 'Tsimiski 78, Thessaloniki', '1995-05-18'),
(7, 'Michalis', 'Georgopoulos', 'mich.georg@email.com', '6937890123', 'Kolokotroni 33, Patras', '1982-12-25'),
(8, 'Katerina', 'Alexiou', 'kat.alex@email.com', '6948901234', 'Stadiou 15, Athens', '1993-04-07'),
(9, 'Nikos', 'Stefanou', 'nik.stef@email.com', '6959012345', 'Aristotelous 90, Thessaloniki', '1987-08-19'),
(10, 'Eleftheria', 'Diamantopoulou', 'elef.diam@email.com', '6960123456', 'Panepistimiou 25, Athens', '1991-01-03'),
(11, 'Georgios', 'Karamanlis', 'g.karam@email.com', '6971112233', 'Ermou 100, Athens', '1980-06-11'),
(12, 'Sofia', 'Nikolaou', 'sof.nikol@email.com', '6982223344', 'Vas. Olgas 150, Thessaloniki', '1994-10-28'),
(13, 'Petros', 'Mavridis', 'pet.mavr@email.com', '6993334455', 'Solonos 75, Athens', '1983-04-20'),
(14, 'Ioanna', 'Katsarou', 'io.kats@email.com', '6974445566', 'Egnatias 200, Thessaloniki', '1996-08-12'),
(15, 'Andreas', 'Lamprou', 'andr.lamp@email.com', '6955556677', 'Agiou Andreou 45, Patras', '1979-12-05'),
(16, 'Maria', 'Oikonomidou', 'mar.oikon@email.com', '6936667788', 'Voukourestiou 30, Athens', '1989-06-28'),
(17, 'Vasilis', 'Papadimitriou', 'vas.papad@email.com', '6917778899', 'Politechniou 80, Thessaloniki', '1984-02-17'),
(18, 'Elena', 'Christodoulou', 'el.christ@email.com', '6998889900', 'Riga Fereou 55, Patras', '1997-10-09'),
(19, 'Christos', 'Antonopoulos', 'chr.anton@email.com', '6979990011', 'Akadimias 100, Athens', '1981-07-14'),
(20, 'Despina', 'Vasileiou', 'desp.vasil@email.com', '6950001122', 'Tsimiski 150, Thessaloniki', '1992-03-25');

INSERT INTO reservation(res_tr_id, res_seatnum, res_cust_id, res_status, res_total_cost) VALUES
(1, 1, 1, 'PAID', 450.00),
(1, 2, 2, 'PAID', 450.00),
(1, 3, 3, 'CONFIRMED', 450.00),
(2, 1, 4, 'PAID', 850.00),
(2, 2, 5, 'CONFIRMED', 850.00),
(3, 1, 6, 'PENDING', 1200.00),
(3, 2, 7, 'PENDING', 1200.00),
(4, 1, 8, 'PAID', 680.00),
(4, 2, 9, 'CONFIRMED', 680.00),
(5, 1, 10, 'PAID', 320.00),
(6, 1, 11, 'PAID', 280.00),
(6, 2, 12, 'PAID', 280.00),
(7, 1, 13, 'PAID', 520.00),
(7, 2, 14, 'PAID', 520.00),
(8, 1, 15, 'PENDING', 750.00),
(8, 2, 16, 'PENDING', 750.00),
(9, 1, 17, 'PENDING', 620.00),
(9, 2, 18, 'PENDING', 620.00),
(10, 1, 19, 'PENDING', 480.00),
(10, 2, 20, 'PENDING', 480.00),
(11, 1, 1, 'PENDING', 390.00),
(12, 1, 2, 'PENDING', 890.00),
(13, 1, 3, 'PENDING', 720.00),
(14, 1, 4, 'PENDING', 550.00);

SET FOREIGN_KEY_CHECKS = 1;
