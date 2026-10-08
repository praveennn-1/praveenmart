package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.exception.AppException;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.CartService;
import com.praveen.praveenmart.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/checkout/place-order"})
public class CheckoutServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CheckoutServlet.class);
    private CartService cartService;
    private OrderService orderService;

    @Override
    public void init() {
        this.cartService = new CartService();
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=/checkout");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        BigDecimal subtotal = cartService.calculateCartTotal(user.getId());
        BigDecimal shipping = subtotal.compareTo(new BigDecimal("2000")) < 0 ? new BigDecimal("99.00") : BigDecimal.ZERO;
        BigDecimal grandTotal = subtotal.add(shipping);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", shipping);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String paymentMethod = request.getParameter("paymentMethod");

        String fullAddress = String.format("%s, %s, %s - %s", street, city, state, pincode);

        java.util.Map<String, String> paymentDetails = new java.util.HashMap<>();
        paymentDetails.put("cardNumber", request.getParameter("cardNumber"));
        paymentDetails.put("cvv", request.getParameter("cvv"));
        paymentDetails.put("upiId", request.getParameter("upiId"));

        try {
            Order order = orderService.placeOrder(user.getId(), fullAddress, paymentMethod, paymentDetails);
            logger.info("Order successfully placed via checkout: orderId={}", order.getId());
            response.sendRedirect(request.getContextPath() + "/orders/success?orderId=" + order.getId());

        } catch (AppException e) {
            logger.warn("Failed to place order for user {}: {}", user.getId(), e.getMessage());
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            logger.error("Unexpected error during checkout for user {}", user.getId(), e);
            request.setAttribute("error", "An unexpected error occurred while placing your order.");
            doGet(request, response);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
