package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(RegisterServlet.class);
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try {
            if (name == null || email == null || password == null ||
                    name.isBlank() || email.isBlank() || password.isBlank()) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if (password.trim().length() < 8) {
                request.setAttribute("error", "Password must be at least 8 characters long.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if ("ADMIN".equalsIgnoreCase(role)) {
                request.setAttribute("error", "Admin accounts cannot be registered.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            boolean success = userService.registerUser(name.trim(), email.trim(), password, role);

            if (!success) {
                request.setAttribute("error", "Registration failed. Email may already be registered.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            request.setAttribute("success", "Account created successfully! Please sign in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Error during registration", e);
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
