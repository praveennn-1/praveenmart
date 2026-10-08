package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.OrderItem;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Order and OrderItem persistence within transactional boundaries.
 */
public interface OrderDAO {

    /**
     * Creates an order record using an existing database connection within a transaction.
     *
     * @param conn  the active transactional database connection
     * @param order the order entity
     * @return generated order ID
     * @throws SQLException on database error
     */
    Long createOrder(Connection conn, Order order) throws SQLException;

    /**
     * Creates an order item record within a transaction.
     *
     * @param conn the active transactional database connection
     * @param item the order item entity
     * @return true if created
     * @throws SQLException on database error
     */
    boolean createOrderItem(Connection conn, OrderItem item) throws SQLException;

    /**
     * Atomically deducts product stock within a transaction if sufficient stock is available.
     *
     * @param conn      the active transactional database connection
     * @param productId the product ID
     * @param quantity  the quantity to deduct
     * @return true if deducted successfully
     * @throws SQLException on database error
     */
    boolean deductProductStock(Connection conn, Long productId, int quantity) throws SQLException;

    /**
     * Finds an order by its ID with items populated.
     *
     * @param orderId the order ID
     * @return order entity or null
     */
    Order findById(Long orderId);

    /**
     * Finds all orders placed by a specific buyer.
     *
     * @param buyerId the buyer ID
     * @return list of orders
     */
    List<Order> findByBuyerId(Long buyerId);

    /**
     * Retrieves all orders across the marketplace.
     *
     * @return list of orders
     */
    List<Order> findAll();

    /**
     * Retrieves order items for a specific order.
     *
     * @param orderId the order ID
     * @return list of order items
     */
    List<OrderItem> findItemsByOrderId(Long orderId);

    /**
     * Retrieves all incoming order line items for products owned by a seller.
     *
     * @param sellerId the seller ID
     * @return list of order items
     */
    List<OrderItem> findItemsBySellerId(Long sellerId);

    /**
     * Updates an order's fulfillment status (PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED).
     *
     * @param orderId the order ID
     * @param status  the target status
     * @return true if updated
     */
    boolean updateOrderStatus(Long orderId, String status);

    /**
     * Counts the total number of orders placed.
     *
     * @return order count
     */
    int countOrders();

    /**
     * Counts orders containing items sold by a specific seller.
     *
     * @param sellerId the seller ID
     * @return order count
     */
    int countOrdersBySeller(Long sellerId);

    /**
     * Calculates total gross revenue across all confirmed/delivered orders.
     *
     * @return total revenue
     */
    BigDecimal calculateTotalRevenue();

    /**
     * Calculates total revenue earned by a specific seller.
     *
     * @param sellerId the seller ID
     * @return seller revenue
     */
    BigDecimal calculateSellerRevenue(Long sellerId);
}
