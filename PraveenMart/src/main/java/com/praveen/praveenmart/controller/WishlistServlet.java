package com.praveen.praveenmart.controller;

import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.model.WishlistItem;
import com.praveen.praveenmart.service.WishlistService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.service.CartService;

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

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        User user = getSessionUser(request);
        if (user == null) {
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("redirect", request.getContextPath() + "/login.jsp");
                json.addProperty("message", "Please sign in to manage your wishlist.");
                response.getWriter().write(json.toString());
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        String productIdStr = request.getParameter("productId");
        String redirect = request.getParameter("redirect");

        if (productIdStr == null || productIdStr.isBlank()) {
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("message", "Invalid product ID.");
                response.getWriter().write(json.toString());
                return;
            }
            response.sendRedirect(request.getContextPath() + "/wishlist");
            return;
        }

        String actionMsg = "Success";
        try {
            Long productId = Long.parseLong(productIdStr.trim());
            switch (path) {
                case "/wishlist/add" -> {
                    wishlistService.addToWishlist(user.getId(), productId);
                    actionMsg = "Item added to your wishlist!";
                    request.getSession().setAttribute("msgSuccess", actionMsg);
                }
                case "/wishlist/remove" -> {
                    wishlistService.removeFromWishlist(user.getId(), productId);
                    actionMsg = "Item removed from your wishlist.";
                    request.getSession().setAttribute("msgSuccess", actionMsg);
                }
                case "/wishlist/move-to-cart" -> {
                    wishlistService.moveToCart(user.getId(), productId);
                    actionMsg = "Item moved to cart successfully!";
                    request.getSession().setAttribute("msgSuccess", actionMsg);
                }
                case "/wishlist/save-for-later" -> {
                    wishlistService.saveForLater(user.getId(), productId);
                    actionMsg = "Item saved for later in your wishlist!";
                    request.getSession().setAttribute("msgSuccess", actionMsg);
                    if (!isAjax) {
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                }
            }

            if (isAjax) {
                CartService cs = new CartService();
                int cartCount = cs.getCartItemCount(user.getId());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", actionMsg);
                json.addProperty("cartCount", cartCount);
                json.addProperty("productId", productId);
                response.getWriter().write(json.toString());
                return;
            }
        } catch (Exception e) {
            logger.error("Error processing wishlist action {}", path, e);
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("message", e.getMessage());
                response.getWriter().write(json.toString());
                return;
            }
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
