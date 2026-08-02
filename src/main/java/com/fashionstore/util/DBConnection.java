
package com.fashionstore.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/fashion_store";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    // Method to get database connection
    public static Connection getConnection() {
        Connection con = null;

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create Connection
            con = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("✅ DB Connection Successful!");

        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL Driver Not Found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Database Connection Failed!");
            e.printStackTrace();
        }

        return con;
    }

    // Method to close connection
    public static void closeConnection(Connection con) {
        if (con != null) {
            try {
                if (!con.isClosed()) {
                    con.close();
                    System.out.println("🔒 Connection Closed.");
                }
            } catch (SQLException e) {
                System.out.println("❌ Error Closing Connection!");
                e.printStackTrace();
            }
        }
    }
}