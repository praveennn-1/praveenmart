package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.dao.OrderDAO;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.impl.CartDAOImpl;
import com.praveen.praveenmart.dao.impl.OrderDAOImpl;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.exception.AppException;
import com.praveen.praveenmart.exception.InsufficientStockException;
import com.praveen.praveenmart.exception.ResourceNotFoundException;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.OrderItem;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.util.DBUtil;
import com.praveen.praveenmart.service.payment.PaymentResult;
import com.praveen.praveenmart.service.payment.PaymentStrategy;
import com.praveen.praveenmart.service.payment.PaymentStrategyFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Service orchestrating order placement, stock updates, payment processing, and status workflow.
 */
public class OrderService {

    private static final Logger logger = LoggerFactory.getLogger(OrderService.class);
    private final OrderDAO orderDAO;
    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public OrderService() {
        this(new OrderDAOImpl(), new CartDAOImpl(), new ProductDAOImpl());
    }

    public OrderService(OrderDAO orderDAO, CartDAO cartDAO, ProductDAO productDAO) {
        this.orderDAO = orderDAO;
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    /**
     * Places an order from cart contents using mock payment confirmation.
     */
    public Order placeOrder(Long buyerId, String shippingAddress, String paymentMethod) {
        return placeOrder(buyerId, shippingAddress, paymentMethod, Collections.emptyMap());
    }

    /**
     * Places an order from cart contents using swappable PaymentStrategy.
     */
    public Order placeOrder(Long buyerId, String shippingAddress, String paymentMethod, Map<String, String> paymentDetails) {
        if (buyerId == null) {
            throw new ValidationException("Buyer ID is required.");
        }

        List<CartItem> cartItems = cartDAO.findByUserId(buyerId);
        if (cartItems.isEmpty()) {
            throw new ValidationException("Cannot place order with an empty cart.");
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            Product p = item.getProduct();
            if (p == null) {
                p = productDAO.findById(item.getProductId());
            }
            if (p == null) {
                throw new AppException("Product not found for ID: " + item.getProductId());
            }
            if (p.getStockQty() < item.getQuantity()) {
                throw new InsufficientStockException("Product '" + p.getName() + "' does not have enough stock.");
            }
            totalAmount = totalAmount.add(p.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }

        PaymentStrategy strategy = PaymentStrategyFactory.getStrategy(paymentMethod);
        PaymentResult paymentResult = strategy.processPayment(null, totalAmount, paymentDetails != null ? paymentDetails : Collections.emptyMap());
        if (!paymentResult.isSuccessful()) {
            throw new ValidationException(paymentResult.getMessage());
        }

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Order order = new Order();
                order.setBuyerId(buyerId);
                order.setStatus("CONFIRMED");
                order.setTotalAmount(totalAmount);

                Long orderId = orderDAO.createOrder(conn, order);
                order.setId(orderId);

                for (CartItem item : cartItems) {
                    Product p = item.getProduct() != null ? item.getProduct() : productDAO.findById(item.getProductId());

                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setProductId(p.getId());
                    orderItem.setQuantity(item.getQuantity());
                    orderItem.setUnitPrice(p.getPrice());

                    orderDAO.createOrderItem(conn, orderItem);

                    boolean stockUpdated = orderDAO.deductProductStock(conn, p.getId(), item.getQuantity());
                    if (!stockUpdated) {
                        throw new InsufficientStockException("Failed to update stock for product: " + p.getName());
                    }
                }

                cartDAO.clearCart(buyerId);

                conn.commit();
                logger.info("Order placed successfully: orderId={}, buyerId={}, total={}", orderId, buyerId, totalAmount);
                return getOrderById(orderId);

            } catch (Exception e) {
                conn.rollback();
                logger.error("Transaction rolled back for order creation buyerId={}", buyerId, e);
                if (e instanceof AppException) {
                    throw (AppException) e;
                }
                throw new AppException("Failed to complete order checkout: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.error("Database error during order placement", e);
            throw new AppException("Database error during order placement: " + e.getMessage(), e);
        }
    }

    /**
     * Finds an order by ID.
     *
     * @param orderId the order ID
     * @return Order entity or null
     */
    public Order getOrderById(Long orderId) {
        return orderDAO.findById(orderId);
    }

    /**
     * Retrieves all orders placed by a specific buyer.
     *
     * @param buyerId the buyer ID
     * @return list of orders
     */
    public List<Order> getBuyerOrders(Long buyerId) {
        if (buyerId == null) {
            return List.of();
        }
        return orderDAO.findByBuyerId(buyerId);
    }

    /**
     * Retrieves all orders across the entire platform.
     *
     * @return list of all orders
     */
    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    /**
     * Retrieves incoming order line items for products belonging to a seller.
     *
     * @param sellerId the seller ID
     * @return list of order items
     */
    public List<OrderItem> getSellerIncomingOrders(Long sellerId) {
        if (sellerId == null) {
            return List.of();
        }
        return orderDAO.findItemsBySellerId(sellerId);
    }

    /**
     * Updates an order's status along the fulfillment lifecycle (Requirement O2).
     *
     * @param orderId   the order ID
     * @param newStatus the target status ('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED')
     * @return true if updated successfully
     */
    public boolean updateOrderStatus(Long orderId, String newStatus) {
        if (orderId == null || newStatus == null || newStatus.isBlank()) {
            throw new ValidationException("Order ID and status are required.");
        }
        String target = newStatus.trim().toUpperCase();
        Set<String> validStatuses = Set.of("PENDING", "CONFIRMED", "SHIPPED", "DELIVERED", "CANCELLED");
        if (!validStatuses.contains(target)) {
            throw new ValidationException("Invalid status: " + newStatus + ". Must be one of: " + validStatuses);
        }

        Order existing = orderDAO.findById(orderId);
        if (existing == null) {
            throw new ResourceNotFoundException("Order not found with ID: " + orderId);
        }

        boolean updated = orderDAO.updateOrderStatus(orderId, target);
        if (updated) {
            logger.info("Order {} status updated from {} to {}", orderId, existing.getStatus(), target);
        }
        return updated;
    }

    /**
     * Returns total platform order count.
     *
     * @return total order count
     */
    public int getTotalOrdersCount() {
        return orderDAO.countOrders();
    }

    /**
     * Returns order count for a specific seller.
     *
     * @param sellerId the seller ID
     * @return seller order count
     */
    public int getSellerOrdersCount(Long sellerId) {
        if (sellerId == null) {
            return 0;
        }
        return orderDAO.countOrdersBySeller(sellerId);
    }

    /**
     * Computes the total platform revenue across all confirmed/delivered orders.
     *
     * @return total platform revenue
     */
    public BigDecimal getTotalPlatformRevenue() {
        return orderDAO.calculateTotalRevenue();
    }

    /**
     * Computes total revenue earned by a specific seller (Requirement O3).
     *
     * @param sellerId the seller ID
     * @return seller revenue
     */
    public BigDecimal getSellerRevenue(Long sellerId) {
        if (sellerId == null) {
            return BigDecimal.ZERO;
        }
        return orderDAO.calculateSellerRevenue(sellerId);
    }
}
