package com.pahanaedu.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/bookshop";
    private static final String USER = "root";
    private static final String PASSWORD = "Lief123";

    private static Connection connection;

    private DBConnection() {}

    public static synchronized Connection getInstance() throws Exception {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            } catch (SQLException e) {
                throw new Exception("Error creating database connection", e);
            }
        }
        return connection;
    }
}
