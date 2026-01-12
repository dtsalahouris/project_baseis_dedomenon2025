-- index a
CREATE INDEX index_departure
ON trip_history (tr_departure);

-- index b 
CREATE INDEX index_plithos_dest
ON trip_history (plithos_dest);