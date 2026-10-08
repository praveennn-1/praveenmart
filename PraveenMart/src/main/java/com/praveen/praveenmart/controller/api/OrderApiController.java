package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.dto.OrderSummaryDTO;
import com.praveen.praveenmart.exception.AppException;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.OrderItem;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import com.praveen.praveenmart.util.JsonUtil;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST API for Order operations versioned under /api/v1/orders (Section 13).
 */
@WebServlet(name = "OrderApiController", urlPatterns = {"/api/v1/orders", "/api/v1/orders/*"})
public class OrderApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(OrderApiController.class);
    private final Gson gson = JsonUtil.getGson();
    private OrderService orderService = new OrderService();

    @Override
    public void init() {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to view orders.")));
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                idParam = pathInfo.substring(1);
            }
        }

        try {
            if (idParam != null && !idParam.isBlank()) {
                Long orderId = Long.parseLong(idParam.trim());
                Order order = orderService.getOrderById(orderId);
                if (order == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", "Order not found.")));
                    return;
                }

                // Security check: only buyer, seller of items, or admin can view
                if (!order.getBuyerId().equals(user.getId()) && !"ADMIN".equalsIgnoreCase(user.getRole())) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write(gson.toJson(ApiResponse.fail("FORBIDDEN", "Access denied.")));
                    return;
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok(order)));
                return;
            }

            boolean isSellerRequest = "true".equalsIgnoreCase(request.getParameter("seller"));
            if (isSellerRequest) {
                if (!"SELLER".equalsIgnoreCase(user.getRole()) && !"ADMIN".equalsIgnoreCase(user.getRole())) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write(gson.toJson(ApiResponse.fail("FORBIDDEN", "Seller role required.")));
                    return;
                }
                List<OrderItem> items = orderService.getSellerIncomingOrders(user.getId());
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok(items)));
                return;
            }

            List<Order> orders = orderService.getBuyerOrders(user.getId());
            List<OrderSummaryDTO> summaries = new ArrayList<>();
            for (Order o : orders) {
                summaries.add(OrderSummaryDTO.builder()
                        .orderId(o.getId())
                        .buyerId(o.getBuyerId())
                        .buyerName(o.getBuyerName() != null ? o.getBuyerName() : user.getName())
                        .status(o.getStatus())
                        .totalAmount(o.getTotalAmount())
                        .itemCount(o.getItems() != null ? o.getItems().size() : 0)
                        .createdAt(o.getCreatedAt())
                        .build());
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(summaries)));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INVALID_ID", "Order ID must be a number.")));
        } catch (Exception e) {
            logger.error("Error retrieving orders", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to retrieve orders.")));
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
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to place an order.")));
            return;
        }

        try {
            JsonObject body = parseRequestBody(request);
            String address = body.has("shippingAddress") ? body.get("shippingAddress").getAsString() : request.getParameter("shippingAddress");
            String paymentMethod = body.has("paymentMethod") ? body.get("paymentMethod").getAsString() : request.getParameter("paymentMethod");

            Map<String, String> paymentDetails = new HashMap<>();
            if (body.has("paymentDetails") && body.get("paymentDetails").isJsonObject()) {
                JsonObject details = body.getAsJsonObject("paymentDetails");
                for (String key : details.keySet()) {
                    paymentDetails.put(key, details.get(key).getAsString());
                }
            } else {
                paymentDetails.put("cardNumber", request.getParameter("cardNumber"));
                paymentDetails.put("cvv", request.getParameter("cvv"));
                paymentDetails.put("upiId", request.getParameter("upiId"));
            }

            Order placedOrder = orderService.placeOrder(user.getId(), address, paymentMethod, paymentDetails);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(gson.toJson(ApiResponse.ok(placedOrder)));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (AppException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("ORDER_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error placing order via API", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Could not complete order placement.")));
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
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in.")));
            return;
        }

        if (!"SELLER".equalsIgnoreCase(user.getRole()) && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(gson.toJson(ApiResponse.fail("FORBIDDEN", "Only sellers or admins can update order statuses.")));
            return;
        }

        try {
            JsonObject body = parseRequestBody(request);
            Long orderId = body.has("orderId") ? body.get("orderId").getAsLong() : null;
            String status = body.has("status") ? body.get("status").getAsString() : null;

            if (orderId == null || status == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "orderId and status are required.")));
                return;
            }

            boolean updated = orderService.updateOrderStatus(orderId, status);
            if (updated) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok("Order status updated to " + status.toUpperCase())));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", "Order not found.")));
            }
        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (ResourceNotFoundException e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error updating order status", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to update order status.")));
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
