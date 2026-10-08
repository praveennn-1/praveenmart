package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.OrderItem;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.OrderService;
import com.praveen.praveenmart.service.ProductService;
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

@WebServlet(name = "SellerServlet", urlPatterns = {
        "/seller/dashboard",
        "/seller/products",
        "/seller/products/create",
        "/seller/products/edit",
        "/seller/products/delete",
        "/seller/orders",
        "/seller/orders/update-status"
})
public class SellerServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(SellerServlet.class);
    private ProductService productService;
    private OrderService orderService;

    @Override
    public void init() {
        this.productService = new ProductService();
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null || (!"SELLER".equalsIgnoreCase(user.getRole()) && !"ADMIN".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/seller/products/delete".equals(path)) {
            handleDeleteProduct(request, response, user);
            return;
        }

        renderDashboard(request, response, user);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null || (!"SELLER".equalsIgnoreCase(user.getRole()) && !"ADMIN".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/seller/products/create" -> handleCreateProduct(request, response, user);
            case "/seller/products/edit" -> handleEditProduct(request, response, user);
            case "/seller/products/delete" -> handleDeleteProduct(request, response, user);
            case "/seller/orders/update-status" -> handleUpdateOrderStatus(request, response, user);
            default -> renderDashboard(request, response, user);
        }
    }

    private void renderDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        List<Product> products = productService.getProductsBySellerId(user.getId());
        List<OrderItem> incomingOrders = orderService.getSellerIncomingOrders(user.getId());
        int totalProducts = productService.getSellerProductsCount(user.getId());
        int totalOrders = orderService.getSellerOrdersCount(user.getId());
        BigDecimal totalRevenue = orderService.getSellerRevenue(user.getId());

        request.setAttribute("products", products);
        request.setAttribute("incomingOrders", incomingOrders);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/seller_dashboard.jsp").forward(request, response);
    }

    private void handleCreateProduct(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            String name = request.getParameter("name");
            if (name == null || name.isBlank()) {
                name = request.getParameter("title");
            }
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            if (stockStr == null || stockStr.isBlank()) {
                stockStr = request.getParameter("stock_qty");
            }
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");
            if (imageUrl == null || imageUrl.isBlank()) {
                imageUrl = request.getParameter("image_url");
            }

            BigDecimal price = new BigDecimal(priceStr.trim());
            int stock = Integer.parseInt(stockStr.trim());

            Product p = new Product();
            p.setSellerId(user.getId());
            p.setName(name.trim());
            p.setDescription(description != null ? description.trim() : "");
            p.setPrice(price);
            p.setStockQty(stock);
            p.setCategory(category != null ? category.trim() : "General");
            p.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

            productService.createProduct(p);
            request.getSession().setAttribute("msgSuccess", "Product published successfully!");

        } catch (ValidationException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
        } catch (Exception e) {
            logger.error("Error creating product by seller {}", user.getId(), e);
            request.getSession().setAttribute("msgError", "Failed to publish product. Check input values.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/dashboard");
    }

    private void handleEditProduct(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            Long productId = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            if (name == null || name.isBlank()) {
                name = request.getParameter("title");
            }
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            if (stockStr == null || stockStr.isBlank()) {
                stockStr = request.getParameter("stock_qty");
            }
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");
            if (imageUrl == null || imageUrl.isBlank()) {
                imageUrl = request.getParameter("image_url");
            }

            BigDecimal price = new BigDecimal(priceStr.trim());
            int stock = Integer.parseInt(stockStr.trim());

            Product p = new Product();
            p.setId(productId);
            p.setSellerId(user.getId());
            p.setName(name.trim());
            p.setDescription(description != null ? description.trim() : "");
            p.setPrice(price);
            p.setStockQty(stock);
            p.setCategory(category != null ? category.trim() : "General");
            p.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

            productService.updateProduct(p);
            request.getSession().setAttribute("msgSuccess", "Product updated successfully!");

        } catch (ValidationException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
        } catch (Exception e) {
            logger.error("Error updating product", e);
            request.getSession().setAttribute("msgError", "Failed to update product.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/dashboard");
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            Long productId = Long.parseLong(request.getParameter("id"));
            productService.deleteProduct(productId, user.getId());
            request.getSession().setAttribute("msgSuccess", "Product listing removed.");
        } catch (Exception e) {
            logger.error("Error deleting product", e);
            request.getSession().setAttribute("msgError", "Could not delete product listing.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/dashboard");
    }

    private void handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            Long orderId = Long.parseLong(request.getParameter("orderId"));
            String status = request.getParameter("status");
            orderService.updateOrderStatus(orderId, status);
            request.getSession().setAttribute("msgSuccess", "Order status updated to " + status);
        } catch (Exception e) {
            logger.error("Error updating order status", e);
            request.getSession().setAttribute("msgError", "Could not update order status.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/dashboard");
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
