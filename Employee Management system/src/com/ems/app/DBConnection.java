package com.ems.app;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            // This URL points to your local MySQL server and the specific database you created
            String url = "jdbc:mysql://localhost:3306/employee_management";
            String user = "root";
            String password = "ricK999_@777"; // Put your actual root password here!
            
            con = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the database successfully!");
            
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
        return con;
    }
}