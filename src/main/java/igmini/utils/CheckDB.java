package igmini.utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

public class CheckDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("❌ Database connection failed!");
                return;
            }
            System.out.println("✅ Connected to Database: " + conn.getCatalog());
            DatabaseMetaData metaData = conn.getMetaData();
            
            // Check tables
            String[] types = {"TABLE"};
            try (ResultSet rs = metaData.getTables(null, null, "%", types)) {
                System.out.println("\n--- Tables list ---");
                while (rs.next()) {
                    String tableName = rs.getString("TABLE_NAME");
                    System.out.println("Table: " + tableName);
                    
                    // Check columns for this table
                    try (ResultSet cols = metaData.getColumns(null, null, tableName, "%")) {
                        while (cols.next()) {
                            String colName = cols.getString("COLUMN_NAME");
                            String colType = cols.getString("TYPE_NAME");
                            System.out.println("   - Column: " + colName + " (" + colType + ")");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
