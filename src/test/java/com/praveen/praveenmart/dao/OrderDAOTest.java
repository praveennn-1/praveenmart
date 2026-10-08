package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.OrderDAOImpl;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.dao.impl.UserDAOImpl;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.OrderItem;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.User;
import com.praveen.praveenmart.util.DBUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class OrderDAOTest extends BaseDAOTest {

    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private Long buyerId;
    private Long productId;

    @BeforeEach
    public void setUp() {
        orderDAO = new OrderDAOImpl();
        userDAO = new UserDAOImpl();
        productDAO = new ProductDAOImpl();

        User buyer = userDAO.findByEmail("buyer@praveenmart.com");
        assertNotNull(buyer);
        buyerId = buyer.getId();

        List<Product> products = productDAO.findAll();
        assertFalse(products.isEmpty());
        productId = products.get(0).getId();
    }

    @Test
    public void testCreateOrderAndRetrieve() throws Exception {
        Order order = new Order();
        order.setBuyerId(buyerId);
        order.setStatus("CONFIRMED");
        order.setTotalAmount(new BigDecimal("2499.00"));

        try (Connection conn = DBUtil.getConnection()) {
            Long orderId = orderDAO.createOrder(conn, order);
            assertNotNull(orderId);

            OrderItem item = new OrderItem();
            item.setOrderId(orderId);
            item.setProductId(productId);
            item.setQuantity(1);
            item.setUnitPrice(new BigDecimal("2499.00"));

            boolean itemCreated = orderDAO.createOrderItem(conn, item);
            assertTrue(itemCreated);

            Order retrieved = orderDAO.findById(orderId);
            assertNotNull(retrieved);
            assertEquals("CONFIRMED", retrieved.getStatus());
            assertFalse(retrieved.getItems().isEmpty());
            assertEquals(productId, retrieved.getItems().get(0).getProductId());
        }
    }
}
