package com.praveen.praveenmart.controller;

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
import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/reviews/add"})
public class ReviewServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewServlet.class);
    private ReviewService reviewService;

    @Override
    public void init() {
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Long productId = Long.parseLong(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            reviewService.addReview(productId, user.getId(), rating, comment);
            request.getSession().setAttribute("msgSuccess", "Review submitted successfully!");

            response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId);

        } catch (Exception e) {
            logger.error("Error adding review", e);
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
