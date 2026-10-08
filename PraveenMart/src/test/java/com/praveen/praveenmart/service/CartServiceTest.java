package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.exception.InsufficientStockException;
import com.praveen.praveenmart.model.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CartServiceTest {

    @Mock
    private CartDAO cartDAO;

    @Mock
    private ProductDAO productDAO;

    private CartService cartService;

    @BeforeEach
    public void setUp() {
        cartService = new CartService(cartDAO, productDAO);
    }

    @Test
    public void testAddToCartExceedsStockThrowsException() {
        Product p = new Product();
        p.setId(10L);
        p.setName("Limited Item");
        p.setPrice(new BigDecimal("999.00"));
        p.setStockQty(3);

        when(productDAO.findById(10L)).thenReturn(p);
        when(cartDAO.findByUserAndProduct(1L, 10L)).thenReturn(null);

        assertThrows(InsufficientStockException.class, () -> {
            cartService.addToCart(1L, 10L, 5);
        });
    }

    @Test
    public void testAddToCartSuccess() {
        Product p = new Product();
        p.setId(10L);
        p.setName("Available Item");
        p.setPrice(new BigDecimal("999.00"));
        p.setStockQty(20);

        when(productDAO.findById(10L)).thenReturn(p);
        when(cartDAO.findByUserAndProduct(1L, 10L)).thenReturn(null);
        when(cartDAO.addToCart(1L, 10L, 2)).thenReturn(true);

        boolean added = cartService.addToCart(1L, 10L, 2);
        assertTrue(added);
        verify(cartDAO, times(1)).addToCart(1L, 10L, 2);
    }
}
