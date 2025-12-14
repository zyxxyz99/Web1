package ocms.web;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBUtil provides a static utility method to establish and return a database connection.
 * This ensures connection parameters are managed centrally and connections can be closed safely.
 */
public class DBUtil {

    // 1. Database Connection Details
    // NOTE: Replace '3306' with your actual MySQL port if different.
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/Online_LMS?serverTimezone=UTC";

    // IMPORTANT: REPLACE these with your actual MySQL credentials
    private static final String USER = "root"; 
    private static final String PASS = "12345678"; 

    /**
     * Establishes and returns a new connection to the Online_LMS database.
     * @return A valid Connection object, or null if connection fails.
     */
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the JDBC driver
            Class.forName(JDBC_DRIVER);

            System.out.println("Attempting to connect to database...");
            
            // Establish the connection
            connection = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("Connection successful!");

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found. Make sure the MySQL Connector JAR is in the build path.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed. Check URL, credentials, and ensure MySQL server is running.");
            e.printStackTrace();
        }
        return connection;
    }
    
    /**
     * Closes the database connection safely.
     * @param connection The Connection object to close.
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connection closed.");
            } catch (SQLException e) {
                System.err.println("Error closing connection.");
                e.printStackTrace();
            }
        }
    }

    /**
     * Simple main method to test the connection utility.
     * You can run this file directly to test if your setup is correct.
     */
    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = getConnection();
            // If conn is not null, the connection was successful
        } finally {
            closeConnection(conn);
        }
    }
}