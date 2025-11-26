package com.foodtruck.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    
    private static final String URL = "jdbc:mysql://localhost:3306/FOOD_APP_DB";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}