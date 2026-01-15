package app;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Db {

    private static final String HOST = "localhost";
    private static final int PORT = 3306;
    private static final String SCHEMA = "travel_agency_2025";
    private static final String USER = "root";
    private static final String PASS = "";
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + SCHEMA +
            "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    public static Connection get() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
