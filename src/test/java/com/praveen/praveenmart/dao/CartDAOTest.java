package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.CartDAOImpl;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class CartDAOTest extends BaseDAOTest {

    private CartDAO cartDAO;
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private Long buyerId;
    private Long productId;

    @BeforeEach
    public void setUp() {
        cartDAO = new CartDAOImpl();
        userDAO = new UserDAOImpl();
        productDAO = new ProductDAOImpl();

        User buyer = userDAO.findByEmail("buyer@praveenmart.com");
        assertNotNull(buyer);
        buyerId = buyer.getId();

        List<Product> products = productDAO.findAll();
        assertFalse(products.isEmpty());
        productId = products.get(0).getId();

        cartDAO.clearCart(buyerId);
    }

    @Test
    public void testAddToCartAndFind() {
        boolean added = cartDAO.addToCart(buyerId, productId, 2);
        assertTrue(added);

        List<CartItem> items = cartDAO.findByUserId(buyerId);
        assertFalse(items.isEmpty());
        assertEquals(2, items.get(0).getQuantity());
        assertNotNull(items.get(0).getProduct());

        int count = cartDAO.getCartItemCount(buyerId);
        assertEquals(2, count);
    }

    @Test
    public void testUpdateQuantityAndRemove() {
        cartDAO.addToCart(buyerId, productId, 1);
        List<CartItem> items = cartDAO.findByUserId(buyerId);
        assertFalse(items.isEmpty());
        Long cartItemId = items.get(0).getId();

        boolean updated = cartDAO.updateQuantity(cartItemId, 4);
        assertTrue(updated);
        assertEquals(4, cartDAO.getCartItemCount(buyerId));

        boolean removed = cartDAO.removeFromCart(cartItemId, buyerId);
        assertTrue(removed);
        assertEquals(0, cartDAO.getCartItemCount(buyerId));
    }
}
