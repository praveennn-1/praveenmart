package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.model.WishlistItem;
import com.praveen.praveenmart.service.WishlistService;
import com.praveen.praveenmart.util.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST API Controller for Wishlist management conforming to Section 13 API Contract Standards.
 */
@WebServlet(name = "WishlistApiController", urlPatterns = {
        "/api/v1/wishlist",
        "/api/v1/wishlist/toggle",
        "/api/v1/wishlist/count"
})
public class WishlistApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(WishlistApiController.class);
    private final Gson gson = JsonUtil.getGson();
    private WishlistService wishlistService;

    @Override
    public void init() {
        this.wishlistService = new WishlistService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Authentication required to access wishlist.")));
            return;
        }

        String path = request.getServletPath();
        if ("/api/v1/wishlist/count".equals(path)) {
            int count = wishlistService.getWishlistCount(user.getId());
            Map<String, Object> data = Map.of("count", count);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(data)));
            return;
        }

        List<WishlistItem> items = wishlistService.getUserWishlist(user.getId());
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(ApiResponse.ok(items)));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = getSessionUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Authentication required to modify wishlist.")));
            return;
        }

        Long productId = null;
        try {
            String contentType = request.getContentType();
            if (contentType != null && contentType.contains("application/json")) {
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                }
                JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);
                if (json != null && json.has("productId")) {
                    productId = json.get("productId").getAsLong();
                }
            } else {
                String param = request.getParameter("productId");
                if (param != null && !param.isBlank()) {
                    productId = Long.parseLong(param.trim());
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("BAD_REQUEST", "Invalid request body.")));
            return;
        }

        if (productId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "productId is required.")));
            return;
        }

        try {
            boolean inWishlist = wishlistService.toggleWishlist(user.getId(), productId);
            int count = wishlistService.getWishlistCount(user.getId());

            Map<String, Object> result = new HashMap<>();
            result.put("inWishlist", inWishlist);
            result.put("count", count);
            result.put("message", inWishlist ? "Added to wishlist" : "Removed from wishlist");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));
        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (ResourceNotFoundException e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error in wishlist toggle API", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INTERNAL_ERROR", "An unexpected error occurred.")));
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
