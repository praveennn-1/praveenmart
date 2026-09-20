package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ProductServiceTest {

    @Mock
    private ProductDAO productDAO;

    private ProductService productService;

    @BeforeEach
    public void setUp() {
        productService = new ProductService(productDAO);
    }

    @Test
    public void testCreateProductValidationPriceZero() {
        Product p = new Product();
        p.setName("Free Item");
        p.setPrice(BigDecimal.ZERO);
        p.setCategory("Fashion & Style");
        p.setStockQty(10);

        assertThrows(ValidationException.class, () -> productService.createProduct(p));
    }

    @Test
    public void testCreateProductSuccess() {
        Product p = new Product();
        p.setSellerId(1L);
        p.setName("Valid Product");
        p.setPrice(new BigDecimal("1299.00"));
        p.setCategory("Fashion & Style");
        p.setStockQty(10);

        when(productDAO.createProduct(any(Product.class))).thenReturn(true);

        boolean created = productService.createProduct(p);
        assertTrue(created);
        verify(productDAO, times(1)).createProduct(p);
    }
}
