package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.util.DBUtil;
import org.junit.jupiter.api.BeforeAll;

import java.sql.Connection;

public abstract class BaseDAOTest {

    @BeforeAll
    public static synchronized void setupTestDatabase() throws Exception {
        DBUtil.shutdown();
        System.setProperty("db.url", "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;MODE=LEGACY");
        System.setProperty("db.user", "sa");
        System.setProperty("db.password", "");
        DBUtil.initDataSource();
        try (Connection conn = DBUtil.getConnection()) {
            DBUtil.executeSqlScript(conn, "schema.sql");
            DBUtil.executeSqlScript(conn, "seed.sql");
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.executeUpdate("MERGE INTO users (id, name, email, password_hash, role) KEY(id) VALUES " +
                    "(2, 'Verified Seller', 'seller@praveenmart.com', '$2a$10$UOxSj/FHkESiVXpXDHfB.Oh/az6PMolnHvqDLo.PwdB6N7AChcQlO', 'SELLER'), " +
                    "(3, 'Demo Buyer', 'buyer@praveenmart.com', '$2a$10$8MXN1c2qpHjUxf0NXGRRmery11Xx9wOSJCAUzCP.aGRbt8XnnkvpC', 'BUYER')");
                stmt.executeUpdate("UPDATE products SET seller_id = 2 WHERE seller_id = 1");
                stmt.executeUpdate("UPDATE reviews SET user_id = 3 WHERE user_id = 1");
            }
        }
    }
}
