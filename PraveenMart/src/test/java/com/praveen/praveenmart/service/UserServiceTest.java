package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.UserDAO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {

    @Mock
    private UserDAO userDAO;

    private UserService userService;

    @BeforeEach
    public void setUp() {
        userService = new UserService(userDAO);
    }

    @Test
    public void testAuthenticateSuccess() {
        String hash = PasswordUtil.hashPassword("secret123");
        User user = new User(1L, "Test User", "user@test.com", hash, "BUYER", null);
        when(userDAO.findByEmail("user@test.com")).thenReturn(user);

        User authenticated = userService.authenticate("user@test.com", "secret123");
        assertNotNull(authenticated);
        assertEquals("Test User", authenticated.getName());
    }

    @Test
    public void testAuthenticateWrongPassword() {
        String hash = PasswordUtil.hashPassword("secret123");
        User user = new User(1L, "Test User", "user@test.com", hash, "BUYER", null);
        when(userDAO.findByEmail("user@test.com")).thenReturn(user);

        User authenticated = userService.authenticate("user@test.com", "wrongpass");
        assertNull(authenticated);
    }

    @Test
    public void testRegisterPasswordTooShortThrowsException() {
        assertThrows(ValidationException.class, () -> {
            userService.registerUser("Test User", "user@test.com", "short", "BUYER");
        });
    }

    @Test
    public void testRegisterSuccess() {
        when(userDAO.findByEmail("newuser@test.com")).thenReturn(null);
        when(userDAO.createUser(any(User.class))).thenReturn(true);

        boolean registered = userService.registerUser("New User", "newuser@test.com", "validpassword123", "SELLER");
        assertTrue(registered);
        verify(userDAO, times(1)).createUser(any(User.class));
    }

    @Test
    public void testRegisterWithAdminRoleDefaultsToBuyer() {
        when(userDAO.findByEmail("adminattempt@test.com")).thenReturn(null);
        org.mockito.ArgumentCaptor<User> captor = org.mockito.ArgumentCaptor.forClass(User.class);
        when(userDAO.createUser(captor.capture())).thenReturn(true);

        boolean registered = userService.registerUser("Hacker", "adminattempt@test.com", "validpassword123", "ADMIN");
        assertTrue(registered);
        assertEquals("BUYER", captor.getValue().getRole());
    }
}
