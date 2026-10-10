package com.praveen.praveenmart.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtil {

    private static final Logger logger = LoggerFactory.getLogger(DBUtil.class);
    private static HikariDataSource dataSource;

    static {
        initDataSource();
    }

    public static synchronized void initDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            return;
        }

        String jdbcUrl = EnvUtil.get("DB_URL", System.getProperty("db.url", "jdbc:h2:~/praveenmart;AUTO_SERVER=TRUE;MODE=LEGACY"));
        if (jdbcUrl == null || jdbcUrl.isBlank()) {
            jdbcUrl = "jdbc:h2:~/praveenmart;AUTO_SERVER=TRUE;MODE=LEGACY";
        }

        String dbUser = EnvUtil.get("DB_USER", System.getProperty("db.user", "sa"));
        if (dbUser == null)
            dbUser = "sa";

        String dbPass = EnvUtil.get("DB_PASSWORD", System.getProperty("db.password", ""));
        if (dbPass == null)
            dbPass = "";

        HikariConfig config = new HikariConfig();
        config.setDriverClassName("org.h2.Driver");
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPass);
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(30000);
        config.setPoolName("PraveenMartHikariPool");

        dataSource = new HikariDataSource(config);
        logger.info("HikariCP connection pool initialized for URL: {}", jdbcUrl);

        initSchemaAndSeed();
    }

    private static void initSchemaAndSeed() {
        try (Connection conn = dataSource.getConnection();
                Statement stmt = conn.createStatement()) {

            boolean tablesExist = false;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_NAME = 'PRODUCTS'")) {
                if (rs.next() && rs.getInt(1) > 0) {
                    tablesExist = true;
                }
            } catch (Exception ignored) {}

            if (!tablesExist) {
                logger.info("Initializing schema from schema.sql...");
                executeSqlScript(conn, "schema.sql");
                logger.info("Schema created successfully.");

                logger.info("Populating database with seed.sql...");
                executeSqlScript(conn, "seed.sql");
                logger.info("Seed data inserted successfully.");
            } else {
                // Ensure removed products are purged from existing database
                try {
                    String purgedProducts = "'Waterproof Commuter Laptop Backpack', 'Classic White Cotton T-Shirt', " +
                            "'Vintage Knit Open-Collar Polo Shirt (Espresso & Cream)', " +
                            "'Designer Trio Messenger Crossbody Bag (Monogram Eclipse)', " +
                            "'Rongke Polo Automatic Ratchet Genuine Leather Belt', " +
                            "'Pro Multi-Pocket Travel Laptop Backpack (Water-Resistant)'";
                    stmt.executeUpdate("DELETE FROM cart_items WHERE product_id IN (SELECT id FROM products WHERE name IN (" + purgedProducts + "))");
                    stmt.executeUpdate("DELETE FROM wishlist_items WHERE product_id IN (SELECT id FROM products WHERE name IN (" + purgedProducts + "))");
                    stmt.executeUpdate("DELETE FROM reviews WHERE product_id IN (SELECT id FROM products WHERE name IN (" + purgedProducts + "))");
                    stmt.executeUpdate("DELETE FROM order_items WHERE product_id IN (SELECT id FROM products WHERE name IN (" + purgedProducts + "))");
                    stmt.executeUpdate("DELETE FROM products WHERE name IN (" + purgedProducts + ")");
                } catch (Exception ignored) {}

                try {
                    stmt.executeUpdate("UPDATE users SET password_hash = '$2a$12$Qs9MYxz7kZzwvtFYEppWmuX7qE5NosItdl9iYhexsALdqCqNp9oJq' WHERE email = 'admin@praveenmart.com'");
                } catch (Exception ignored) {}

                boolean hasNewSeed = false;
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM products WHERE name = 'Full HD Streaming Webcam' AND image_url = '/images/webcam.jpg'")) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        hasNewSeed = true;
                    }
                } catch (Exception ignored) {}

                if (!hasNewSeed) {
                    logger.info("Updating product catalog to new simplified products from seed.sql...");
                    try { stmt.executeUpdate("DELETE FROM cart_items"); } catch (Exception ignored) {}
                    try { stmt.executeUpdate("DELETE FROM order_items"); } catch (Exception ignored) {}
                    try { stmt.executeUpdate("DELETE FROM reviews"); } catch (Exception ignored) {}
                    try { stmt.executeUpdate("DELETE FROM products"); } catch (Exception ignored) {}
                    executeSqlScript(conn, "seed.sql");
                    logger.info("New product catalog seeded successfully.");
                } else {
                    logger.info("Database schema and products already up to date.");
                }
                // Ensure optional migration tables such as wishlist_items exist
                try {
                    executeSqlScript(conn, "db/migrations/V4__add_wishlist_table.sql");
                } catch (Exception ignored) {}

                // Ensure default delivery address columns exist in users table
                try {
                    executeSqlScript(conn, "db/migrations/V5__add_user_default_address.sql");
                } catch (Exception ignored) {}
                try {
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS recipient_name VARCHAR(100)");
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20)");
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS street VARCHAR(255)");
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS city VARCHAR(100)");
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS state VARCHAR(100)");
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN IF NOT EXISTS pincode VARCHAR(20)");
                } catch (Exception ignored) {}
            }
        } catch (Exception e) {
            logger.error("Error during database schema and seed initialization", e);
        }
    }

    public static void executeSqlScript(Connection conn, String scriptPath) throws SQLException {
        InputStream is = DBUtil.class.getClassLoader().getResourceAsStream(scriptPath);
        if (is == null) {
            logger.warn("Could not find script file on classpath: {}", scriptPath);
            return;
        }

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder cleanedSql = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmedLine = line.trim();
                if (!trimmedLine.startsWith("--")) {
                    cleanedSql.append(line).append("\n");
                }
            }

            String[] statements = cleanedSql.toString().split(";");
            for (String statement : statements) {
                String trimmed = statement.trim();
                if (!trimmed.isEmpty()) {
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute(trimmed);
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Failed to execute SQL script: {}", scriptPath, e);
            throw new SQLException("Failed to execute SQL script: " + scriptPath, e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null || dataSource.isClosed()) {
            initDataSource();
        }
        return dataSource.getConnection();
    }

    public static DataSource getDataSource() {
        return dataSource;
    }

    public static synchronized void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            logger.info("Closing HikariCP connection pool...");
            dataSource.close();
            logger.info("Connection pool closed.");
        }
    }
}
