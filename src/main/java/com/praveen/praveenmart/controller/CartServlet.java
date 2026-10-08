package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.exception.InsufficientStockException;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.CartService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove", "/cart/clear"})
public class CartServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CartServlet.class);
    private CartService cartService;

    @Override
    public void init() {
        this.cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/cart/remove".equals(path)) {
            handleRemove(request, response);
            return;
        } else if ("/cart/clear".equals(path)) {
            handleClear(request, response);
            return;
        }

        handleViewCart(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/cart/add" -> handleAdd(request, response);
            case "/cart/update" -> handleUpdate(request, response);
            case "/cart/remove" -> handleRemove(request, response);
            case "/cart/clear" -> handleClear(request, response);
            default -> handleViewCart(request, response);
        }
    }

    private void handleViewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        BigDecimal subtotal = cartService.calculateCartTotal(user.getId());
        BigDecimal shipping = subtotal.compareTo(BigDecimal.ZERO) > 0 && subtotal.compareTo(new BigDecimal("2000")) < 0
                ? new BigDecimal("99.00")
                : BigDecimal.ZERO;
        BigDecimal grandTotal = subtotal.add(shipping);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", shipping);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        User user = getSessionUser(request);
        if (user == null) {
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("requireLogin", true);
                json.addProperty("redirect", request.getContextPath() + "/login.jsp");
                json.addProperty("message", "Please sign in to add products to your cart.");
                response.getWriter().write(json.toString());
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Long productId = Long.parseLong(request.getParameter("productId"));
            String qtyStr = request.getParameter("quantity");
            int quantity = (qtyStr != null && !qtyStr.isBlank()) ? Integer.parseInt(qtyStr) : 1;

            cartService.addToCart(user.getId(), productId, quantity);
            request.getSession().setAttribute("cartMessage", "Product added to cart!");

            if (isAjax) {
                int count = cartService.getCartItemCount(user.getId());
                BigDecimal total = cartService.calculateCartTotal(user.getId());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_OK);
                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Product added to cart!");
                json.addProperty("itemCount", count);
                json.addProperty("totalAmount", total);
                json.addProperty("quantity", quantity);
                json.addProperty("productId", productId);
                response.getWriter().write(json.toString());
                return;
            }

        } catch (InsufficientStockException e) {
            request.getSession().setAttribute("cartError", e.getMessage());
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("message", e.getMessage());
                response.getWriter().write(json.toString());
                return;
            }
        } catch (Exception e) {
            logger.error("Error adding product to cart", e);
            request.getSession().setAttribute("cartError", "Could not add product to cart.");
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("message", "Could not add product to cart.");
                response.getWriter().write(json.toString());
                return;
            }
        }

        if ("true".equalsIgnoreCase(request.getParameter("buyNow"))) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            cartService.updateQuantity(cartItemId, user.getId(), quantity);
            request.getSession().setAttribute("cartMessage", "Cart updated.");

        } catch (InsufficientStockException e) {
            request.getSession().setAttribute("cartError", e.getMessage());
        } catch (Exception e) {
            logger.error("Error updating cart quantity", e);
            request.getSession().setAttribute("cartError", "Could not update quantity.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            cartService.removeFromCart(cartItemId, user.getId());
            request.getSession().setAttribute("cartMessage", "Item removed from cart.");
        } catch (Exception e) {
            logger.error("Error removing cart item", e);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleClear(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = getSessionUser(request);
        if (user != null) {
            cartService.clearCart(user.getId());
            request.getSession().setAttribute("cartMessage", "Cart cleared.");
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
