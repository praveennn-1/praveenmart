package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.dto.ProductResponseDTO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.ProductService;
import com.praveen.praveenmart.service.ReviewService;
import com.praveen.praveenmart.util.JsonUtil;
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
import java.util.ArrayList;
import java.util.List;

/**
 * REST API for Product operations versioned under /api/v1/products (Section 13).
 */
@WebServlet(name = "ProductApiController", urlPatterns = {"/api/v1/products", "/api/v1/products/*"})
public class ProductApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ProductApiController.class);
    private final Gson gson = JsonUtil.getGson();
    private ProductService productService = new ProductService();
    private ReviewService reviewService = new ReviewService();

    @Override
    public void init() {
        this.productService = new ProductService();
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                idParam = pathInfo.substring(1);
            }
        }

        try {
            if (idParam != null && !idParam.isBlank()) {
                Long id = Long.parseLong(idParam.trim());
                Product product = productService.getProductById(id);
                if (product == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", "Product not found with id: " + id)));
                    return;
                }
                double avgRating = reviewService.getAverageRating(product.getId());
                int reviewCount = reviewService.getReviewCount(product.getId());
                ProductResponseDTO dto = toDTO(product, avgRating, reviewCount);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok(dto)));
                return;
            }

            String keyword = request.getParameter("keyword");
            String category = request.getParameter("category");

            List<Product> products = productService.searchProducts(keyword, category);
            List<ProductResponseDTO> dtos = new ArrayList<>();
            for (Product p : products) {
                double avgRating = reviewService.getAverageRating(p.getId());
                int reviewCount = reviewService.getReviewCount(p.getId());
                dtos.add(toDTO(p, avgRating, reviewCount));
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(dtos)));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INVALID_ID", "Product ID must be a valid number.")));
        } catch (Exception e) {
            logger.error("Error in ProductApiController doGet", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to retrieve products.")));
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
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Authentication required.")));
            return;
        }
        if (!"SELLER".equalsIgnoreCase(user.getRole()) && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(gson.toJson(ApiResponse.fail("FORBIDDEN", "Only sellers or admins can create products.")));
            return;
        }

        try {
            Product product = readProductFromBody(request);
            product.setSellerId(user.getId());

            productService.createProduct(product);
            ProductResponseDTO dto = toDTO(product, 0.0, 0);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(gson.toJson(ApiResponse.ok(dto)));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Error creating product via API", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to create product.")));
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
            response.getWriter().write(gson.toJson(ApiResponse.fail("UNAUTHORIZED", "Authentication required.")));
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                idParam = pathInfo.substring(1);
            }
        }

        if (idParam == null || idParam.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "Product ID is required.")));
            return;
        }

        try {
            Long productId = Long.parseLong(idParam.trim());
            boolean success;
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                success = productService.adminDeleteProduct(productId);
            } else {
                success = productService.deleteProduct(productId, user.getId());
            }

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(ApiResponse.ok("Product deleted successfully.")));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(ApiResponse.fail("NOT_FOUND", "Product not found or access denied.")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INVALID_ID", "Product ID must be a number.")));
        } catch (Exception e) {
            logger.error("Error deleting product via API", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to delete product.")));
        }
    }

    private Product readProductFromBody(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            try (BufferedReader reader = request.getReader()) {
                return gson.fromJson(reader, Product.class);
            }
        }

        Product p = new Product();
        p.setName(request.getParameter("name"));
        p.setDescription(request.getParameter("description"));
        String priceStr = request.getParameter("price");
        if (priceStr != null && !priceStr.isBlank()) {
            p.setPrice(new BigDecimal(priceStr.trim()));
        }
        String stockStr = request.getParameter("stock");
        if (stockStr == null || stockStr.isBlank()) {
            stockStr = request.getParameter("stock_qty");
        }
        if (stockStr != null && !stockStr.isBlank()) {
            p.setStockQty(Integer.parseInt(stockStr.trim()));
        }
        p.setCategory(request.getParameter("category"));
        p.setImageUrl(request.getParameter("imageUrl") != null ? request.getParameter("imageUrl") : request.getParameter("image_url"));
        return p;
    }

    private ProductResponseDTO toDTO(Product p, double avgRating, int reviewCount) {
        return ProductResponseDTO.builder()
                .id(p.getId())
                .sellerId(p.getSellerId())
                .sellerName(p.getSellerName())
                .name(p.getName())
                .description(p.getDescription())
                .price(p.getPrice())
                .stockQty(p.getStockQty())
                .category(p.getCategory())
                .imageUrl(p.getImageUrl())
                .averageRating(avgRating)
                .reviewCount(reviewCount)
                .createdAt(p.getCreatedAt())
                .build();
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
