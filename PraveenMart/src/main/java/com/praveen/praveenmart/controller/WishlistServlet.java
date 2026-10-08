package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.model.WishlistItem;
import com.praveen.praveenmart.service.WishlistService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller handling user wishlist and save-for-later actions.
 */
@WebServlet(name = "WishlistServlet", urlPatterns = {
        "/wishlist",
        "/wishlist/add",
        "/wishlist/remove",
        "/wishlist/move-to-cart",
        "/wishlist/save-for-later"
})
public class WishlistServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(WishlistServlet.class);
    private WishlistService wishlistService;

    @Override
    public void init() {
        this.wishlistService = new WishlistService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=/wishlist");
            return;
        }

        List<WishlistItem> items = wishlistService.getUserWishlist(user.getId());
        request.setAttribute("wishlistItems", items);
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        String productIdStr = request.getParameter("productId");
        String redirect = request.getParameter("redirect");

        if (productIdStr == null || productIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
            return;
        }

        try {
            Long productId = Long.parseLong(productIdStr.trim());
            switch (path) {
                case "/wishlist/add" -> {
                    wishlistService.addToWishlist(user.getId(), productId);
                    request.getSession().setAttribute("msgSuccess", "Item added to your wishlist!");
                }
                case "/wishlist/remove" -> {
                    wishlistService.removeFromWishlist(user.getId(), productId);
                    request.getSession().setAttribute("msgSuccess", "Item removed from your wishlist.");
                }
                case "/wishlist/move-to-cart" -> {
                    wishlistService.moveToCart(user.getId(), productId);
                    request.getSession().setAttribute("msgSuccess", "Item moved to cart successfully!");
                }
                case "/wishlist/save-for-later" -> {
                    wishlistService.saveForLater(user.getId(), productId);
                    request.getSession().setAttribute("msgSuccess", "Item saved for later in your wishlist!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }
        } catch (Exception e) {
            logger.error("Error processing wishlist action {}", path, e);
            request.getSession().setAttribute("msgError", e.getMessage());
        }

        if (redirect != null && !redirect.isBlank()) {
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
}
