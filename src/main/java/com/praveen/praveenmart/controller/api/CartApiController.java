package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.exception.ValidationException;
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
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import com.praveen.praveenmart.util.JsonUtil;
import java.util.Map;

/**
 * REST API for Cart operations versioned under /api/v1/cart (Section 13).
 */
@WebServlet(name = "CartApiController", urlPatterns = {"/api/v1/cart", "/api/v1/cart/*"})
public class CartApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CartApiController.class);
    private final Gson gson = JsonUtil.getGson();
    private CartService cartService = new CartService();

    @Override
    public void init() {
        this.cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to access cart.")));
            return;
        }

        try {
            List<CartItem> items = cartService.getCartItems(user.getId());
            BigDecimal total = cartService.calculateCartTotal(user.getId());
            int count = cartService.getCartItemCount(user.getId());

            Map<String, Object> data = new HashMap<>();
            data.put("items", items);
            data.put("totalAmount", total);
            data.put("itemCount", count);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(data)));

        } catch (Exception e) {
            logger.error("Error retrieving cart for user {}", user.getId(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Could not load cart.")));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to modify cart.")));
            return;
        }

        try {
            JsonObject body = parseRequestBody(request);
            Long productId = body.has("productId") ? body.get("productId").getAsLong() : null;
            if (productId == null && request.getParameter("productId") != null) {
                productId = Long.parseLong(request.getParameter("productId"));
            }

            int quantity = 1;
            if (body.has("quantity")) {
                quantity = body.get("quantity").getAsInt();
            } else if (request.getParameter("quantity") != null) {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            }

            if (productId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "Product ID is required.")));
                return;
            }

            cartService.addToCart(user.getId(), productId, quantity);
            int newCount = cartService.getCartItemCount(user.getId());
            BigDecimal newTotal = cartService.calculateCartTotal(user.getId());

            Map<String, Object> result = new HashMap<>();
            result.put("message", "Item added to cart.");
            result.put("itemCount", newCount);
            result.put("totalAmount", newTotal);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error adding to cart", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Could not add item to cart.")));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to update cart.")));
            return;
        }

        try {
            JsonObject body = parseRequestBody(request);
            Long productId = body.has("productId") ? body.get("productId").getAsLong() : null;
            int quantity = body.has("quantity") ? body.get("quantity").getAsInt() : 1;

            if (productId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "Product ID is required.")));
                return;
            }

            cartService.updateQuantity(user.getId(), productId, quantity);
            int newCount = cartService.getCartItemCount(user.getId());
            BigDecimal newTotal = cartService.calculateCartTotal(user.getId());

            Map<String, Object> result = new HashMap<>();
            result.put("message", "Cart quantity updated.");
            result.put("itemCount", newCount);
            result.put("totalAmount", newTotal);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error updating cart quantity", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to update cart.")));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in.")));
            return;
        }

        String idParam = request.getParameter("productId");
        try {
            if ("clear".equalsIgnoreCase(request.getParameter("action")) || idParam == null) {
                cartService.clearCart(user.getId());
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok("Cart cleared.")));
                return;
            }

            Long productId = Long.parseLong(idParam.trim());
            cartService.removeFromCart(user.getId(), productId);

            int newCount = cartService.getCartItemCount(user.getId());
            BigDecimal newTotal = cartService.calculateCartTotal(user.getId());

            Map<String, Object> result = new HashMap<>();
            result.put("message", "Item removed from cart.");
            result.put("itemCount", newCount);
            result.put("totalAmount", newTotal);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));

        } catch (Exception e) {
            logger.error("Error removing item from cart", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to remove item.")));
        }
    }

    private JsonObject parseRequestBody(HttpServletRequest request) {
        try (BufferedReader reader = request.getReader()) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String body = sb.toString().trim();
            if (!body.isEmpty()) {
                JsonObject obj = com.praveen.praveenmart.util.JsonUtil.getGson().fromJson(body, JsonObject.class);
                return obj != null ? obj : new JsonObject();
            }
        } catch (Exception ignored) {
        }
        return new JsonObject();
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
