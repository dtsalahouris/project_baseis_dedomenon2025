CREATE TABLE dba (
  dba_id INT AUTO_INCREMENT PRIMARY KEY,
  dba_username VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NULL
) ENGINE=InnoDB;

ALTER TABLE dba
ADD CONSTRAINT uq_dba_username UNIQUE (dba_username);

INSERT INTO dba (dba_username, start_date, end_date)
VALUES ('root', CURDATE(), NULL);
