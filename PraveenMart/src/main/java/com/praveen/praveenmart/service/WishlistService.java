package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.dao.DAOFactory;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.WishlistDAO;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.WishlistItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Service orchestrating wishlist and save-for-later actions (Requirement O1).
 */
public class WishlistService {

    private static final Logger logger = LoggerFactory.getLogger(WishlistService.class);
    private final WishlistDAO wishlistDAO;
    private final ProductDAO productDAO;
    private final CartDAO cartDAO;

    /**
     * Default constructor utilizing {@link DAOFactory}.
     */
    public WishlistService() {
        this(DAOFactory.getWishlistDAO(), DAOFactory.getProductDAO(), DAOFactory.getCartDAO());
    }

    /**
     * Constructor for dependency injection and testing.
     *
     * @param wishlistDAO the wishlist data access object
     * @param productDAO  the product data access object
     * @param cartDAO     the cart data access object
     */
    public WishlistService(WishlistDAO wishlistDAO, ProductDAO productDAO, CartDAO cartDAO) {
        this.wishlistDAO = wishlistDAO;
        this.productDAO = productDAO;
        this.cartDAO = cartDAO;
    }

    /**
     * Retrieves all items in a user's wishlist.
     *
     * @param userId the user ID
     * @return list of wishlist items
     */
    public List<WishlistItem> getUserWishlist(Long userId) {
        if (userId == null) {
            throw new ValidationException("User ID is required.");
        }
        return wishlistDAO.findByUserId(userId);
    }

    /**
     * Adds a product to the user's wishlist with input validation.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if added
     */
    public boolean addToWishlist(Long userId, Long productId) {
        if (userId == null) {
            throw new ValidationException("User ID is required.");
        }
        if (productId == null) {
            throw new ValidationException("Product ID is required.");
        }

        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new ResourceNotFoundException("Product with ID " + productId + " does not exist.");
        }

        boolean added = wishlistDAO.addToWishlist(userId, productId);
        if (added) {
            logger.info("Added product {} to wishlist for user {}", productId, userId);
        }
        return added;
    }

    /**
     * Removes a product from the user's wishlist.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if removed
     */
    public boolean removeFromWishlist(Long userId, Long productId) {
        if (userId == null || productId == null) {
            throw new ValidationException("User ID and Product ID are required.");
        }
        boolean removed = wishlistDAO.removeFromWishlist(userId, productId);
        if (removed) {
            logger.info("Removed product {} from wishlist for user {}", productId, userId);
        }
        return removed;
    }

    /**
     * Toggles the wishlist status of a product (adds if not present, removes if already present).
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if the item is now in the wishlist, false if removed
     */
    public boolean toggleWishlist(Long userId, Long productId) {
        if (userId == null || productId == null) {
            throw new ValidationException("User ID and Product ID are required.");
        }
        if (wishlistDAO.isInWishlist(userId, productId)) {
            wishlistDAO.removeFromWishlist(userId, productId);
            return false;
        } else {
            Product product = productDAO.findById(productId);
            if (product == null) {
                throw new ResourceNotFoundException("Product not found: " + productId);
            }
            wishlistDAO.addToWishlist(userId, productId);
            return true;
        }
    }

    /**
     * Checks if a product is currently in the user's wishlist.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if present
     */
    public boolean isInWishlist(Long userId, Long productId) {
        if (userId == null || productId == null) {
            return false;
        }
        return wishlistDAO.isInWishlist(userId, productId);
    }

    /**
     * Moves a product from the wishlist into the shopping cart.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if moved successfully
     */
    public boolean moveToCart(Long userId, Long productId) {
        if (userId == null || productId == null) {
            throw new ValidationException("User ID and Product ID are required.");
        }
        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new ResourceNotFoundException("Product not found: " + productId);
        }

        cartDAO.addToCart(userId, productId, 1);
        wishlistDAO.removeFromWishlist(userId, productId);
        logger.info("Moved product {} from wishlist to cart for user {}", productId, userId);
        return true;
    }

    /**
     * Moves an item from the shopping cart into the wishlist ("Save for Later").
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if saved for later successfully
     */
    public boolean saveForLater(Long userId, Long productId) {
        if (userId == null || productId == null) {
            throw new ValidationException("User ID and Product ID are required.");
        }
        wishlistDAO.addToWishlist(userId, productId);
        com.praveen.praveenmart.model.CartItem existing = cartDAO.findByUserAndProduct(userId, productId);
        if (existing != null) {
            cartDAO.removeFromCart(existing.getId(), userId);
        }
        logger.info("Saved product {} for later for user {}", productId, userId);
        return true;
    }

    /**
     * Counts the total items in the user's wishlist.
     *
     * @param userId the user ID
     * @return count of items
     */
    public int getWishlistCount(Long userId) {
        if (userId == null) {
            return 0;
        }
        return wishlistDAO.countByUserId(userId);
    }
}
