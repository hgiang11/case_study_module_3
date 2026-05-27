package igmini.utils;


import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/instagram_mini?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";    private static final String USER = "root";
    private static final String PASSWORD = "hgiang1123";

    public static Connection getConnection() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

        } catch (Exception e) {
            System.out.println("Error while connecting to the database:" + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}