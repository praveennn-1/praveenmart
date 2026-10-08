package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.WishlistItem;

import java.util.List;

/**
 * Data Access Object interface for wishlist and save-for-later management.
 */
public interface WishlistDAO {

    /**
     * Adds a product to the user's wishlist.
     *
     * @param userId    the user's identifier
     * @param productId the product's identifier
     * @return true if added, false if already exists or operation fails
     */
    boolean addToWishlist(Long userId, Long productId);

    /**
     * Removes a product from the user's wishlist.
     *
     * @param userId    the user's identifier
     * @param productId the product's identifier
     * @return true if removed, false otherwise
     */
    boolean removeFromWishlist(Long userId, Long productId);

    /**
     * Retrieves all wishlist items for a specific user with populated product details.
     *
     * @param userId the user's identifier
     * @return list of WishlistItem objects
     */
    List<WishlistItem> findByUserId(Long userId);

    /**
     * Checks if a specific product is in the user's wishlist.
     *
     * @param userId    the user's identifier
     * @param productId the product's identifier
     * @return true if present, false otherwise
     */
    boolean isInWishlist(Long userId, Long productId);

    /**
     * Counts the total number of items in a user's wishlist.
     *
     * @param userId the user's identifier
     * @return total item count
     */
    int countByUserId(Long userId);

    /**
     * Clears all items from a user's wishlist.
     *
     * @param userId the user's identifier
     * @return true if cleared successfully
     */
    boolean clearWishlist(Long userId);
}
