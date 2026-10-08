package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/orders/details", "/orders/success"})
public class OrderServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/orders/success".equals(path)) {
            handleOrderSuccess(request, response);
        } else if ("/orders/details".equals(path)) {
            handleOrderDetails(request, response, user);
        } else {
            handleOrderList(request, response, user);
        }
    }

    private void handleOrderList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Order> orders = orderService.getBuyerOrders(user.getId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }

    private void handleOrderDetails(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            Long orderId = Long.parseLong(idParam);
            Order order = orderService.getOrderById(orderId);

            if (order == null || (!order.getBuyerId().equals(user.getId()) && !"ADMIN".equalsIgnoreCase(user.getRole()))) {
                request.setAttribute("errorMessage", "Order not found or unauthorized access.");
                request.getRequestDispatcher("/404.jsp").forward(request, response);
                return;
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/order_details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handleOrderSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("orderId");
        if (idParam != null && !idParam.isBlank()) {
            try {
                Long orderId = Long.parseLong(idParam);
                Order order = orderService.getOrderById(orderId);
                request.setAttribute("order", order);
            } catch (NumberFormatException ignored) {
            }
        }
        request.getRequestDispatcher("/order_success.jsp").forward(request, response);
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
