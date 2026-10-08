package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.WishlistDAO;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.WishlistItem;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class WishlistServiceTest {

    @Mock
    private WishlistDAO wishlistDAO;

    @Mock
    private ProductDAO productDAO;

    @Mock
    private CartDAO cartDAO;

    private WishlistService wishlistService;

    @BeforeEach
    public void setUp() {
        wishlistService = new WishlistService(wishlistDAO, productDAO, cartDAO);
    }

    @Test
    public void testGetUserWishlist() {
        WishlistItem item = new WishlistItem(1L, 10L, 100L, null);
        when(wishlistDAO.findByUserId(10L)).thenReturn(List.of(item));

        List<WishlistItem> result = wishlistService.getUserWishlist(10L);
        assertNotNull(result);
        assertEquals(1, result.size());
        verify(wishlistDAO).findByUserId(10L);
    }

    @Test
    public void testGetUserWishlist_NullUserId_ThrowsValidationException() {
        assertThrows(ValidationException.class, () -> wishlistService.getUserWishlist(null));
    }

    @Test
    public void testAddToWishlist_Success() {
        Product p = new Product();
        p.setId(100L);
        p.setName("Wireless Mouse");

        when(productDAO.findById(100L)).thenReturn(p);
        when(wishlistDAO.addToWishlist(10L, 100L)).thenReturn(true);

        boolean added = wishlistService.addToWishlist(10L, 100L);
        assertTrue(added);
        verify(wishlistDAO).addToWishlist(10L, 100L);
    }

    @Test
    public void testAddToWishlist_ProductNotFound_ThrowsException() {
        when(productDAO.findById(999L)).thenReturn(null);

        assertThrows(ResourceNotFoundException.class, () -> wishlistService.addToWishlist(10L, 999L));
        verify(wishlistDAO, never()).addToWishlist(anyLong(), anyLong());
    }

    @Test
    public void testToggleWishlist() {
        Product p = new Product();
        p.setId(100L);

        // When not in wishlist: should add
        when(wishlistDAO.isInWishlist(10L, 100L)).thenReturn(false);
        when(productDAO.findById(100L)).thenReturn(p);
        when(wishlistDAO.addToWishlist(10L, 100L)).thenReturn(true);

        boolean inWishlist = wishlistService.toggleWishlist(10L, 100L);
        assertTrue(inWishlist);

        // When already in wishlist: should remove
        when(wishlistDAO.isInWishlist(10L, 100L)).thenReturn(true);
        when(wishlistDAO.removeFromWishlist(10L, 100L)).thenReturn(true);

        boolean inWishlistAfter = wishlistService.toggleWishlist(10L, 100L);
        assertFalse(inWishlistAfter);
    }

    @Test
    public void testMoveToCart() {
        Product p = new Product();
        p.setId(100L);
        p.setPrice(new BigDecimal("99.00"));

        when(productDAO.findById(100L)).thenReturn(p);
        when(cartDAO.addToCart(10L, 100L, 1)).thenReturn(true);
        when(wishlistDAO.removeFromWishlist(10L, 100L)).thenReturn(true);

        boolean moved = wishlistService.moveToCart(10L, 100L);
        assertTrue(moved);
        verify(cartDAO).addToCart(10L, 100L, 1);
        verify(wishlistDAO).removeFromWishlist(10L, 100L);
    }
}
