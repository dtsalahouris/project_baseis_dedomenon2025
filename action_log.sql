CREATE TABLE action_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  table_name VARCHAR(50) NOT NULL,
  action_type ENUM('INSERT','UPDATE','DELETE') NOT NULL,
  date_time DATETIME NOT NULL,
dba_user VARCHAR(100) NOT NULL,
  CONSTRAINT fk_actionlog_dba
    FOREIGN KEY (dba_user )
    REFERENCES dba(dba_username)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB;
