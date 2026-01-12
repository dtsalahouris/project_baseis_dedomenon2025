DROP TABLE IF EXISTS trip_history;

CREATE TABLE trip_history (
  id_taxidiou INT NOT NULL,
  tr_departure DATE NOT NULL,
  tr_return DATE NOT NULL,
  plithos_dest INT NOT NULL,
  plithos_partic INT NOT NULL,
  sinolo_esodon DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_taxidiou)
) ENGINE=InnoDB;
