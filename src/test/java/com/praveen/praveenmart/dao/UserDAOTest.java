package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class UserDAOTest extends BaseDAOTest {

    private UserDAO userDAO;

    @BeforeEach
    public void setUp() {
        userDAO = new UserDAOImpl();
    }

    @Test
    public void testFindSeedUsers() {
        User admin = userDAO.findByEmail("admin@praveenmart.com");
        assertNotNull(admin);
        assertEquals("ADMIN", admin.getRole());

        User seller = userDAO.findByEmail("seller@praveenmart.com");
        assertNotNull(seller);
        assertEquals("SELLER", seller.getRole());
    }

    @Test
    public void testCreateAndFindUser() {
        User newUser = new User();
        newUser.setName("Test Buyer");
        newUser.setEmail("testbuyer_" + System.currentTimeMillis() + "@test.com");
        newUser.setPasswordHash("$2a$10$8K1p/a0dL1LXMIgoEDFrwOdMQiP8eB3fO8Xo9J5LhQp0u81yWz47.");
        newUser.setRole("BUYER");

        boolean created = userDAO.createUser(newUser);
        assertTrue(created);
        assertNotNull(newUser.getId());

        User found = userDAO.findById(newUser.getId());
        assertNotNull(found);
        assertEquals("Test Buyer", found.getName());
        assertEquals("BUYER", found.getRole());
    }

    @Test
    public void testCountUsers() {
        int count = userDAO.countUsers();
        assertTrue(count >= 3);
    }
}
