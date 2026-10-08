package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Review;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.ReviewService;
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
import java.util.List;

import com.praveen.praveenmart.util.JsonUtil;

/**
 * REST API for Product Reviews versioned under /api/v1/reviews (Section 13).
 */
@WebServlet(name = "ReviewApiController", urlPatterns = {"/api/v1/reviews", "/api/v1/reviews/*"})
public class ReviewApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewApiController.class);
    private final Gson gson = JsonUtil.getGson();
    private ReviewService reviewService = new ReviewService();

    @Override
    public void init() {
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null || productIdParam.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "productId parameter is required.")));
            return;
        }

        try {
            Long productId = Long.parseLong(productIdParam.trim());
            List<Review> reviews = reviewService.getReviewsForProduct(productId);
            double avgRating = reviewService.getAverageRating(productId);
            int count = reviewService.getReviewCount(productId);

            JsonObject result = new JsonObject();
            result.add("reviews", gson.toJsonTree(reviews));
            result.addProperty("averageRating", avgRating);
            result.addProperty("reviewCount", count);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INVALID_ID", "productId must be a valid number.")));
        } catch (Exception e) {
            logger.error("Error retrieving reviews", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Could not fetch reviews.")));
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
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Please sign in to write a review.")));
            return;
        }

        try {
            JsonObject body = parseRequestBody(request);
            Long productId = body.has("productId") ? body.get("productId").getAsLong() : null;
            if (productId == null && request.getParameter("productId") != null) {
                productId = Long.parseLong(request.getParameter("productId"));
            }

            int rating = body.has("rating") ? body.get("rating").getAsInt() : 5;
            if (request.getParameter("rating") != null) {
                rating = Integer.parseInt(request.getParameter("rating"));
            }

            String comment = body.has("comment") ? body.get("comment").getAsString() : request.getParameter("comment");

            if (productId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "productId is required.")));
                return;
            }

            reviewService.addReview(productId, user.getId(), rating, comment);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(gson.toJson(ApiResponse.ok("Review submitted successfully.")));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error submitting review", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Could not submit review.")));
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
