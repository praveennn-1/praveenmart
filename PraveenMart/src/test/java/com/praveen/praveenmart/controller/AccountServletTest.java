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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AccountServletTest extends BaseDAOTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    private AccountServlet servlet;
    private UserDAO userDAO;
    private User testUser;

    @BeforeEach
    public void setUp() {
        servlet = new AccountServlet();
        servlet.init();
        userDAO = new UserDAOImpl();

        testUser = userDAO.findByEmail("buyer@praveenmart.com");
        assertNotNull(testUser);
    }

    @Test
    public void testDoGetForwardsToDashboard() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(testUser);
        when(request.getRequestDispatcher("/dashboard.jsp")).thenReturn(requestDispatcher);

        servlet.doGet(request, response);

        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostUpdatesDefaultAddress() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(testUser);

        when(request.getParameter("recipientName")).thenReturn("Account Delivery Lead");
        when(request.getParameter("phone")).thenReturn("+91 9888877777");
        when(request.getParameter("street")).thenReturn("77 Marina Beach Road");
        when(request.getParameter("city")).thenReturn("Chennai");
        when(request.getParameter("state")).thenReturn("Tamil Nadu");
        when(request.getParameter("pincode")).thenReturn("600004");
        when(request.getContextPath()).thenReturn("");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/dashboard.jsp?updated=true");

        User updatedUser = userDAO.findById(testUser.getId());
        assertNotNull(updatedUser);
        assertEquals("Account Delivery Lead", updatedUser.getRecipientName());
        assertEquals("+91 9888877777", updatedUser.getPhone());
        assertEquals("77 Marina Beach Road", updatedUser.getStreet());
        assertEquals("Chennai", updatedUser.getCity());
        assertEquals("Tamil Nadu", updatedUser.getState());
        assertEquals("600004", updatedUser.getPincode());
    }
}
