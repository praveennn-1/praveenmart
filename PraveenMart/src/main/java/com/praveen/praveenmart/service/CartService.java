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

/**
 * Service managing user shopping cart operations, stock validation, and total computation (Requirement F4).
 */
public class CartService {

    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    /**
     * Default constructor initializing with default DAOs.
     */
    public CartService() {
        this(new CartDAOImpl(), new ProductDAOImpl());
    }

    /**
     * Dependency injection constructor for testing.
     *
     * @param cartDAO    the cart data access object
     * @param productDAO the product data access object
     */
    public CartService(CartDAO cartDAO, ProductDAO productDAO) {
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    /**
     * Retrieves all items currently in the user's cart.
     *
     * @param userId the user ID
     * @return list of cart items
     */
    public List<CartItem> getCartItems(Long userId) {
        if (userId == null) {
            return List.of();
        }
        return cartDAO.findByUserId(userId);
    }

    /**
     * Adds a product to the cart with inventory availability check.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @param quantity  the quantity to add
     * @return true if added successfully
     */
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

    /**
     * Updates the quantity of an item in the user's cart.
     *
     * @param cartItemId the cart item ID
     * @param userId     the user ID
     * @param quantity   the new quantity
     * @return true if updated
     */
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

    /**
     * Removes an item from the cart verifying user ownership.
     *
     * @param cartItemId the cart item ID
     * @param userId     the user ID
     * @return true if removed
     */
    public boolean removeFromCart(Long cartItemId, Long userId) {
        if (cartItemId == null || userId == null) {
            return false;
        }
        return cartDAO.removeFromCart(cartItemId, userId);
    }

    /**
     * Empties all items in the user's cart.
     *
     * @param userId the user ID
     * @return true if cleared
     */
    public boolean clearCart(Long userId) {
        if (userId == null) {
            return false;
        }
        return cartDAO.clearCart(userId);
    }

    /**
     * Calculates the subtotal price of all items in the cart.
     *
     * @param userId the user ID
     * @return total monetary amount
     */
    public BigDecimal calculateCartTotal(Long userId) {
        List<CartItem> items = getCartItems(userId);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getItemTotal());
        }
        return total;
    }

    /**
     * Returns total unit count across all items in user's cart.
     *
     * @param userId the user ID
     * @return total unit count
     */
    public int getCartItemCount(Long userId) {
        if (userId == null) {
            return 0;
        }
        return cartDAO.getCartItemCount(userId);
    }
}
