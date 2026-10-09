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

/**
 * Controller managing account details, default delivery addresses, and user profiles.
 */
@WebServlet(name = "AccountServlet", urlPatterns = {"/account", "/account/address", "/profile"})
public class AccountServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AccountServlet.class);
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=/account");
            return;
        }

        // Always reload fresh user state from DB
        User freshUser = userService.findById(user.getId());
        if (freshUser != null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("user", freshUser);
            }
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String recipientName = request.getParameter("recipientName");
        String phone = request.getParameter("phone");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");

        boolean saved = userService.saveDefaultAddress(user.getId(), recipientName, phone, street, city, state, pincode);
        if (saved) {
            user.setRecipientName(recipientName != null ? recipientName.trim() : null);
            user.setPhone(phone != null ? phone.trim() : null);
            user.setStreet(street != null ? street.trim() : null);
            user.setCity(city != null ? city.trim() : null);
            user.setState(state != null ? state.trim() : null);
            user.setPincode(pincode != null ? pincode.trim() : null);
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("user", user);
            }
            logger.info("Account default address successfully updated for userId={}", user.getId());
        }

        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(isAjax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":" + saved + ",\"message\":\"Default address saved successfully.\"}");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?updated=true");
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
