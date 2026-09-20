package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.impl.CartDAOImpl;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.exception.InsufficientStockException;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.Product;

import java.math.BigDecimal;
import java.util.List;

public class CartService {

    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public CartService() {
        this(new CartDAOImpl(), new ProductDAOImpl());
    }

    public CartService(CartDAO cartDAO, ProductDAO productDAO) {
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    public List<CartItem> getCartItems(Long userId) {
        if (userId == null) {
            return List.of();
        }
        return cartDAO.findByUserId(userId);
    }

    public boolean addToCart(Long userId, Long productId, int quantity) {
        if (userId == null || productId == null) {
            throw new ValidationException("User ID and Product ID are required.");
        }
        if (quantity <= 0) {
            throw new ValidationException("Quantity must be greater than zero.");
        }

        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new ResourceNotFoundException("Product not found.");
        }

        CartItem existing = cartDAO.findByUserAndProduct(userId, productId);
        int currentInCart = (existing != null) ? existing.getQuantity() : 0;
        int requestedTotal = currentInCart + quantity;

        if (product.getStockQty() < requestedTotal) {
            throw new InsufficientStockException("Insufficient stock. Only " + product.getStockQty() + " units available.");
        }

        return cartDAO.addToCart(userId, productId, quantity);
    }

    public boolean updateQuantity(Long cartItemId, Long userId, int quantity) {
        if (cartItemId == null || userId == null) {
            throw new ValidationException("Cart Item ID and User ID are required.");
        }
        if (quantity <= 0) {
            return cartDAO.removeFromCart(cartItemId, userId);
        }

        List<CartItem> userItems = cartDAO.findByUserId(userId);
        CartItem target = userItems.stream()
                .filter(item -> item.getId().equals(cartItemId))
                .findFirst()
                .orElse(null);

        if (target == null) {
            throw new ResourceNotFoundException("Cart item not found.");
        }

        Product product = target.getProduct();
        if (product != null && product.getStockQty() < quantity) {
            throw new InsufficientStockException("Insufficient stock. Only " + product.getStockQty() + " units available.");
        }

        return cartDAO.updateQuantity(cartItemId, quantity);
    }

    public boolean removeFromCart(Long cartItemId, Long userId) {
        if (cartItemId == null || userId == null) {
            return false;
        }
        return cartDAO.removeFromCart(cartItemId, userId);
    }

    public boolean clearCart(Long userId) {
        if (userId == null) {
            return false;
        }
        return cartDAO.clearCart(userId);
    }

    public BigDecimal calculateCartTotal(Long userId) {
        List<CartItem> items = getCartItems(userId);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getItemTotal());
        }
        return total;
    }

    public int getCartItemCount(Long userId) {
        if (userId == null) return 0;
        return cartDAO.getCartItemCount(userId);
    }
}
