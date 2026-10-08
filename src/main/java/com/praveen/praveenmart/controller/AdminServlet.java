package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.dto.UserResponseDTO;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.OrderService;
import com.praveen.praveenmart.service.ProductService;
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
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/users/delete",
        "/admin/orders",
        "/admin/products/delete"
})
public class AdminServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminServlet.class);
    private UserService userService;
    private ProductService productService;
    private OrderService orderService;

    @Override
    public void init() {
        this.userService = new UserService();
        this.productService = new ProductService();
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole()) || !"admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/products/delete".equals(path)) {
            handleDeleteProduct(request, response);
            return;
        } else if ("/admin/users/delete".equals(path)) {
            handleDeleteUser(request, response);
            return;
        }

        renderDashboard(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole()) || !"admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/products/delete".equals(path)) {
            handleDeleteProduct(request, response);
        } else if ("/admin/users/delete".equals(path)) {
            handleDeleteUser(request, response);
        } else {
            renderDashboard(request, response);
        }
    }

    private void renderDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<UserResponseDTO> users = userService.getAllUsers();
        List<Product> products = productService.getAllProducts();
        List<Order> orders = orderService.getAllOrders();

        int totalUsers = userService.getTotalUsersCount();
        int totalBuyers = userService.getBuyersCount();
        int totalSellers = userService.getSellersCount();
        int totalProducts = productService.getTotalProductsCount();
        int totalOrders = orderService.getTotalOrdersCount();
        BigDecimal totalRevenue = orderService.getTotalPlatformRevenue();

        request.setAttribute("users", users);
        request.setAttribute("products", products);
        request.setAttribute("orders", orders);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalBuyers", totalBuyers);
        request.setAttribute("totalSellers", totalSellers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Long productId = Long.parseLong(request.getParameter("id"));
            productService.adminDeleteProduct(productId);
            request.getSession().setAttribute("msgSuccess", "Listing removed by admin.");
        } catch (Exception e) {
            logger.error("Error admin deleting product", e);
            request.getSession().setAttribute("msgError", "Could not remove listing.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            userService.deleteUser(userId);
            request.getSession().setAttribute("msgSuccess", "User account removed.");
        } catch (Exception e) {
            logger.error("Error admin deleting user", e);
            request.getSession().setAttribute("msgError", "Could not remove user.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
