SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE language_ref(
    lang_code VARCHAR(5) NOT NULL,
    lang_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(lang_code)
) engine=InnoDB;

CREATE TABLE branch(
    br_code INT(11) NOT NULL,
    br_street VARCHAR(50) NOT NULL,
    br_num INT(4) NOT NULL,
    br_city VARCHAR(30) NOT NULL,
    br_manager_AT CHAR(10) NOT NULL,
    PRIMARY KEY(br_code),
    CONSTRAINT BR_MNG FOREIGN KEY (br_manager_AT) REFERENCES admin(adm_AT)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE worker(
    wrk_AT CHAR(10) NOT NULL,
    wrk_name VARCHAR(30) DEFAULT 'unknown' NOT NULL,
    wrk_lname VARCHAR(30) DEFAULT 'unknown' NOT NULL,
    wrk_email VARCHAR(100) NOT NULL,
    wrk_salary DECIMAL(10,2) NOT NULL,
    wrk_br_code INT(11) NOT NULL,
    PRIMARY KEY(wrk_AT),
    CONSTRAINT WRK_BRANCH FOREIGN KEY (wrk_br_code) REFERENCES branch(br_code)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;


CREATE TABLE admin(
    adm_AT CHAR(10) NOT NULL,
    adm_type ENUM('LOGISTICS','ADMINISTRATIVE','ACCOUNTING') NOT NULL,
    adm_diploma VARCHAR(200) NOT NULL,
    PRIMARY KEY(adm_AT),
    CONSTRAINT ADM_IS_WRK FOREIGN KEY (adm_AT) REFERENCES worker(wrk_AT)
    ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE driver(
    drv_AT CHAR(10) NOT NULL,
    drv_license ENUM('A','B','C','D') NOT NULL,
    drv_route ENUM('LOCAL','ABROAD') NOT NULL,
    drv_experience TINYINT(4) NOT NULL,
    PRIMARY KEY(drv_AT),
    CONSTRAINT DRV_IS_WRK FOREIGN KEY (drv_AT) REFERENCES worker(wrk_AT)
    ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE guide(
    gui_AT CHAR(10) NOT NULL,
    gui_cv TEXT NOT NULL,
    PRIMARY KEY(gui_AT),
    CONSTRAINT GUI_IS_WRK FOREIGN KEY (gui_AT) REFERENCES worker(wrk_AT)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE languages(
    lng_gui_AT CHAR(10) NOT NULL,
    lng_language_code VARCHAR(5) NOT NULL,
    PRIMARY KEY(lng_gui_AT, lng_language_code),
    CONSTRAINT LNG_GUI FOREIGN KEY (lng_gui_AT) REFERENCES guide(gui_AT)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT LNG_CODE FOREIGN KEY (lng_language_code) REFERENCES language_ref(lang_code)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE manages(
    mng_adm_AT CHAR(10) NOT NULL,
    mng_br_code INT(11) NOT NULL,
    PRIMARY KEY(mng_adm_AT,mng_br_code),
    CONSTRAINT MNG_ADMIN FOREIGN KEY (mng_adm_AT) REFERENCES admin(adm_AT)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT MNG_BRANCH FOREIGN KEY (mng_br_code) REFERENCES branch(br_code)
    ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE phones(
    ph_br_code INT(11) NOT NULL,
    ph_number VARCHAR(15) NOT NULL,
    PRIMARY KEY(ph_br_code, ph_number),
    CONSTRAINT PH_BRANCH FOREIGN KEY (ph_br_code) REFERENCES branch(br_code)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE trip(
    tr_id INT(11) NOT NULL AUTO_INCREMENT,
    tr_departure DATETIME NOT NULL,
    tr_return DATETIME NOT NULL,
    tr_maxseats TINYINT(4) NOT NULL,
    tr_cost_adult DECIMAL(10,2) NOT NULL,
    tr_cost_child DECIMAL(10,2) NOT NULL,
    tr_status ENUM('PLANNED', 'CONFIRMED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL, 
    tr_min_participants TINYINT(4) NOT NULL,
    tr_br_code INT(11) NOT NULL,
    tr_gui_AT CHAR(10) NOT NULL,
    tr_drv_AT CHAR(10) NOT NULL,
    PRIMARY KEY(tr_id),
    CONSTRAINT TRIP_BRANCH FOREIGN KEY (tr_br_code) REFERENCES branch(br_code)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT TRIP_GUIDE FOREIGN KEY (tr_gui_AT) REFERENCES guide(gui_AT)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT TRIP_DRIVER FOREIGN KEY (tr_drv_AT) REFERENCES driver(drv_AT)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE destination(
    dst_id INT(11) NOT NULL AUTO_INCREMENT,
    dst_name VARCHAR(100) NOT NULL,
    dst_descr TEXT,
    dst_rtype ENUM('LOCAL','ABROAD') NOT NULL,
    dst_language_code VARCHAR(5) NOT NULL,
    dst_location INT(11),
    PRIMARY KEY(dst_id),
    CONSTRAINT DST_LANG FOREIGN KEY (dst_language_code) REFERENCES language_ref(lang_code)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT DST_PARENT FOREIGN KEY (dst_location) REFERENCES destination(dst_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) engine=InnoDB;

CREATE TABLE travel_to(
    to_tr_id INT(11) NOT NULL,
    to_dst_id INT(11) NOT NULL,
    to_arrival DATETIME NOT NULL,
    to_departure DATETIME NOT NULL,
    to_sequence TINYINT(4) NOT NULL,
    PRIMARY KEY(to_tr_id,to_dst_id),
    CONSTRAINT TRV_TRIP FOREIGN KEY (to_tr_id) REFERENCES trip(tr_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT TRV_DEST FOREIGN KEY (to_dst_id) REFERENCES destination(dst_id)
    ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE event(
    ev_tr_id INT(11) NOT NULL,
    ev_start DATETIME NOT NULL,
    ev_end DATETIME NOT NULL,
    ev_descr TEXT NOT NULL,
    PRIMARY KEY(ev_tr_id, ev_start),
    CONSTRAINT EV_TRIP FOREIGN KEY (ev_tr_id) REFERENCES trip(tr_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) engine=InnoDB;

CREATE TABLE customer(
    cust_id INT(11) NOT NULL AUTO_INCREMENT,
    cust_name VARCHAR(30) NOT NULL,
    cust_lname VARCHAR(30) NOT NULL,
    cust_email VARCHAR(100) NOT NULL,
    cust_phone VARCHAR(15) NOT NULL,
    cust_address TEXT NOT NULL,
    cust_birth_date DATE NOT NULL,
    PRIMARY KEY(cust_id)
)engine=InnoDB;

CREATE TABLE reservation(
    res_tr_id INT(11) NOT NULL,
    res_seatnum TINYINT(4) NOT NULL,
    res_cust_id INT(11) NOT NULL,
    res_status ENUM('PENDING','CONFIRMED','PAID','CANCELLED') NOT NULL,
    res_total_cost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(res_tr_id,res_seatnum),
    CONSTRAINT RES_TRIP FOREIGN KEY (res_tr_id) REFERENCES trip(tr_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT RES_CUST FOREIGN KEY (res_cust_id) REFERENCES customer(cust_id)
    ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;