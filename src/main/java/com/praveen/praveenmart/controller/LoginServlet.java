package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userService.authenticate(email, password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setMaxInactiveInterval(30 * 60);
        newSession.setAttribute("user", user);

        logger.info("User logged in successfully: {} (Role: {})", user.getEmail(), user.getRole());

        if (redirect != null && !redirect.isBlank() && !redirect.contains("login") && !redirect.contains("register")) {
            response.sendRedirect(request.getContextPath() + redirect);
            return;
        }

        if ("ADMIN".equalsIgnoreCase(user.getRole()) && "admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("SELLER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/seller/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
