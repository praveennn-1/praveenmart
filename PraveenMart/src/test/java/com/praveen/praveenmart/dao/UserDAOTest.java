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

    @Test
    public void testUpdateAndFindDefaultAddress() {
        User newUser = new User();
        newUser.setName("Address User");
        newUser.setEmail("address_user_" + System.currentTimeMillis() + "@test.com");
        newUser.setPasswordHash("$2a$10$8K1p/a0dL1LXMIgoEDFrwOdMQiP8eB3fO8Xo9J5LhQp0u81yWz47.");
        newUser.setRole("BUYER");

        boolean created = userDAO.createUser(newUser);
        assertTrue(created);
        assertNotNull(newUser.getId());

        boolean updated = userDAO.updateDefaultAddress(newUser.getId(), "Recipient Name", "+91 9988776655",
                "123 Market Street", "Chennai", "Tamil Nadu", "600001");
        assertTrue(updated);

        User retrieved = userDAO.findById(newUser.getId());
        assertNotNull(retrieved);
        assertEquals("Recipient Name", retrieved.getRecipientName());
        assertEquals("+91 9988776655", retrieved.getPhone());
        assertEquals("123 Market Street", retrieved.getStreet());
        assertEquals("Chennai", retrieved.getCity());
        assertEquals("Tamil Nadu", retrieved.getState());
        assertEquals("600001", retrieved.getPincode());
        assertTrue(retrieved.hasDefaultAddress());
        assertEquals("123 Market Street, Chennai, Tamil Nadu - 600001", retrieved.getFormattedAddress());
    }
}
