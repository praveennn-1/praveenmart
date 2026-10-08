package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ProductDAOTest extends BaseDAOTest {

    private ProductDAO productDAO;
    private UserDAO userDAO;
    private Long sellerId;

    @BeforeEach
    public void setUp() {
        productDAO = new ProductDAOImpl();
        userDAO = new UserDAOImpl();
        User seller = userDAO.findByEmail("seller@praveenmart.com");
        assertNotNull(seller);
        sellerId = seller.getId();
    }

    @Test
    public void testFindAllProducts() {
        List<Product> products = productDAO.findAll();
        assertNotNull(products);
        assertFalse(products.isEmpty());
    }

    @Test
    public void testCreateAndFindProduct() {
        Product p = new Product();
        p.setSellerId(sellerId);
        p.setName("Organic Green Tea");
        p.setDescription("Pure mountain harvested whole leaf organic green tea.");
        p.setPrice(new BigDecimal("499.00"));
        p.setStockQty(50);
        p.setCategory("Organic Essentials");
        p.setImageUrl("https://example.com/tea.jpg");

        boolean created = productDAO.createProduct(p);
        assertTrue(created);
        assertNotNull(p.getId());

        Product found = productDAO.findById(p.getId());
        assertNotNull(found);
        assertEquals("Organic Green Tea", found.getName());
        assertEquals("Organic Essentials", found.getCategory());
        assertEquals(50, found.getStockQty());
    }

    @Test
    public void testSearchProducts() {
        List<Product> results = productDAO.search("Cotton", "all");
        assertNotNull(results);
        assertTrue(results.stream().anyMatch(p -> p.getName().toLowerCase().contains("cotton")));
    }
}
