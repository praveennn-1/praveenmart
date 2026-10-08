package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.dao.impl.WishlistDAOImpl;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.model.WishlistItem;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class WishlistDAOTest extends BaseDAOTest {

    private WishlistDAO wishlistDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;
    private Long buyerId;
    private Long productId;

    @BeforeEach
    public void setUp() {
        wishlistDAO = new WishlistDAOImpl();
        productDAO = new ProductDAOImpl();
        userDAO = new UserDAOImpl();

        User buyer = userDAO.findByEmail("buyer@praveenmart.com");
        assertNotNull(buyer);
        buyerId = buyer.getId();

        List<Product> products = productDAO.findAll();
        assertFalse(products.isEmpty());
        productId = products.get(0).getId();

        wishlistDAO.clearWishlist(buyerId);
    }

    @Test
    public void testAddAndFindWishlistItem() {
        boolean added = wishlistDAO.addToWishlist(buyerId, productId);
        assertTrue(added);

        assertTrue(wishlistDAO.isInWishlist(buyerId, productId));
        assertEquals(1, wishlistDAO.countByUserId(buyerId));

        List<WishlistItem> items = wishlistDAO.findByUserId(buyerId);
        assertNotNull(items);
        assertEquals(1, items.size());
        assertEquals(productId, items.get(0).getProductId());
        assertNotNull(items.get(0).getProduct());
    }

    @Test
    public void testRemoveFromWishlist() {
        wishlistDAO.addToWishlist(buyerId, productId);
        assertTrue(wishlistDAO.isInWishlist(buyerId, productId));

        boolean removed = wishlistDAO.removeFromWishlist(buyerId, productId);
        assertTrue(removed);
        assertFalse(wishlistDAO.isInWishlist(buyerId, productId));
        assertEquals(0, wishlistDAO.countByUserId(buyerId));
    }

    @Test
    public void testClearWishlist() {
        List<Product> products = productDAO.findAll();
        if (products.size() > 1) {
            wishlistDAO.addToWishlist(buyerId, products.get(0).getId());
            wishlistDAO.addToWishlist(buyerId, products.get(1).getId());
            assertEquals(2, wishlistDAO.countByUserId(buyerId));

            boolean cleared = wishlistDAO.clearWishlist(buyerId);
            assertTrue(cleared);
            assertEquals(0, wishlistDAO.countByUserId(buyerId));
        }
    }
}
