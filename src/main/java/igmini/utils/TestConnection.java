package igmini.utils;


public class TestConnection {

    public static void main(String[] args) {

        if (DBConnection.getConnection() != null) {
            System.out.println("Connected!");
        } else {
            System.out.println("Failed!");
        }
    }
}
