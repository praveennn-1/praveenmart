package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.CartItem;

import java.util.List;

/**
 * Data Access Object interface for user shopping cart operations (Requirement F4).
 */
public interface CartDAO {

    /**
     * Retrieves all cart items for a specific user with associated product information.
     *
     * @param userId the user ID
     * @return list of cart items
     */
    List<CartItem> findByUserId(Long userId);

    /**
     * Finds a specific cart item for a given user and product.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return CartItem entity or null
     */
    CartItem findByUserAndProduct(Long userId, Long productId);

    /**
     * Adds an item to the user's cart or increments quantity if it already exists.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @param quantity  the quantity to add
     * @return true if added
     */
    boolean addToCart(Long userId, Long productId, int quantity);

    /**
     * Updates the item quantity for an existing cart item.
     *
     * @param cartItemId the cart item ID
     * @param quantity   the new quantity
     * @return true if updated
     */
    boolean updateQuantity(Long cartItemId, int quantity);

    /**
     * Removes an item from the user's cart ensuring user ownership.
     *
     * @param cartItemId the cart item ID
     * @param userId     the user ID
     * @return true if removed
     */
    boolean removeFromCart(Long cartItemId, Long userId);

    /**
     * Empties all items from the user's cart.
     *
     * @param userId the user ID
     * @return true if cleared
     */
    boolean clearCart(Long userId);

    /**
     * Calculates the total sum of item quantities in the user's cart.
     *
     * @param userId the user ID
     * @return total item quantity count
     */
    int getCartItemCount(Long userId);
}
