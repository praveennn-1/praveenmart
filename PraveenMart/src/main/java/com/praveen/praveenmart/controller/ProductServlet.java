package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.Review;
import com.praveen.praveenmart.service.ProductService;
import com.praveen.praveenmart.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product-details"})
public class ProductServlet extends HttpServlet {

    private ProductService productService;
    private ReviewService reviewService;

    @Override
    public void init() {
        this.productService = new ProductService();
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/product-details".equals(path)) {
            handleProductDetails(request, response);
        } else {
            handleProductList(request, response);
        }
    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String keyword = request.getParameter("q");

        List<Product> products;
        if (keyword != null && !keyword.trim().isBlank()) {
            products = productService.searchProducts(keyword.trim(), category);
        } else if (category != null && !category.trim().isBlank() && !"all".equalsIgnoreCase(category)) {
            products = productService.getProductsByCategory(category.trim());
        } else {
            products = productService.getAllProducts();
        }

        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", category != null ? category : "all");
        request.setAttribute("searchQuery", keyword != null ? keyword : "");

        request.getRequestDispatcher("/store.jsp").forward(request, response);
    }

    private void handleProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            Long productId = Long.parseLong(idParam);
            Product product = productService.getProductById(productId);

            if (product == null) {
                request.setAttribute("errorMessage", "Product not found.");
                request.getRequestDispatcher("/404.jsp").forward(request, response);
                return;
            }

            List<Review> reviews = reviewService.getReviewsForProduct(productId);
            double avgRating = reviewService.getAverageRating(productId);
            int reviewCount = reviewService.getReviewCount(productId);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);

            request.getRequestDispatcher("/product_details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
