package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.dao.BaseDAOTest;
import com.praveen.praveenmart.dao.UserDAO;
import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CheckoutServletTest extends BaseDAOTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    private CheckoutServlet servlet;
    private UserDAO userDAO;
    private User testUser;

    @BeforeEach
    public void setUp() {
        servlet = new CheckoutServlet();
        servlet.init();
        userDAO = new UserDAOImpl();

        testUser = userDAO.findByEmail("buyer@praveenmart.com");
        assertNotNull(testUser, "Test buyer must exist in seed DB");
    }

    @Test
    public void testSaveAddressEndpointPersistsDefaultAddressInAccount() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(testUser);
        when(request.getServletPath()).thenReturn("/checkout/save-address");

        when(request.getParameter("fullName")).thenReturn("Praveen Delivery");
        when(request.getParameter("phone")).thenReturn("+91 9123456789");
        when(request.getParameter("street")).thenReturn("100 Innovation Boulevard");
        when(request.getParameter("city")).thenReturn("Bengaluru");
        when(request.getParameter("state")).thenReturn("Karnataka");
        when(request.getParameter("pincode")).thenReturn("560001");

        StringWriter stringWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(printWriter);

        servlet.doPost(request, response);

        printWriter.flush();
        assertTrue(stringWriter.toString().contains("\"success\":true"));

        User reloaded = userDAO.findById(testUser.getId());
        assertNotNull(reloaded);
        assertEquals("Praveen Delivery", reloaded.getRecipientName());
        assertEquals("+91 9123456789", reloaded.getPhone());
        assertEquals("100 Innovation Boulevard", reloaded.getStreet());
        assertEquals("Bengaluru", reloaded.getCity());
        assertEquals("Karnataka", reloaded.getState());
        assertEquals("560001", reloaded.getPincode());
        assertTrue(reloaded.hasDefaultAddress());
    }
}
