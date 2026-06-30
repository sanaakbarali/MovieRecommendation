package com.movie.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConfig {
    private static Properties properties = new Properties();
    private static String url;
    private static String username;
    private static String password;
    private static String driver;
    
    static {
        try {
            // Load properties file
            InputStream input = DatabaseConfig.class.getClassLoader()
                .getResourceAsStream("db.properties");
            properties.load(input);
            
            // Check if running on Render (production)
            String isProduction = System.getenv("RENDER");
            
            if (isProduction != null && isProduction.equals("true")) {
                // Production - Aiven
                String host = System.getenv("DB_HOST");
                String port = System.getenv("DB_PORT");
                String dbName = System.getenv("DB_NAME");
                String ssl = System.getenv("DB_SSL");
                
                if (host == null || host.isEmpty()) {
                    host = System.getenv("DB_HOST"); // Fallback
                }
                
                // Build URL with SSL
                String urlTemplate = "jdbc:mysql://%s:%s/%s?useSSL=true&requireSSL=true&serverTimezone=UTC";
                url = String.format(urlTemplate, 
                    System.getenv("DB_HOST"), 
                    System.getenv("DB_PORT"), 
                    System.getenv("DB_NAME"));
                
                username = System.getenv("DB_USER");
                password = System.getenv("DB_PASSWORD");
                driver = properties.getProperty("db.production.driver");
                
                System.out.println("✅ Using Aiven Production Database");
                System.out.println("   Host: " + System.getenv("DB_HOST"));
                System.out.println("   Database: " + System.getenv("DB_NAME"));
            } else {
                // Local development
                url = properties.getProperty("db.url");
                username = properties.getProperty("db.username");
                password = properties.getProperty("db.password");
                driver = properties.getProperty("db.driver");
                
                System.out.println("✅ Using Local Development Database");
                System.out.println("   URL: " + url);
            }
            
            // Load JDBC driver
            Class.forName(driver);
            
        } catch (Exception e) {
            System.err.println("❌ Error loading database configuration:");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
    
    public static String getUrl() {
        return url;
    }
    
    public static String getUsername() {
        return username;
    }
    
    public static String getPassword() {
        return password;
    }
    
    public static String getDriver() {
        return driver;
    }
}