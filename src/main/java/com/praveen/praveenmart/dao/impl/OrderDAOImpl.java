package com.praveen.praveenmart.dao.impl;

import com.praveen.praveenmart.dao.OrderDAO;
import com.praveen.praveenmart.model.Order;
import com.praveen.praveenmart.model.OrderItem;
import com.praveen.praveenmart.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link OrderDAO} supporting transactional order management.
 */
public class OrderDAOImpl implements OrderDAO {

    private static final Logger logger = LoggerFactory.getLogger(OrderDAOImpl.class);

    @Override
    public Long createOrder(Connection conn, Order order) throws SQLException {
        String sql = "INSERT INTO orders (buyer_id, status, total_amount) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, order.getBuyerId());
            stmt.setString(2, order.getStatus() != null ? order.getStatus() : "CONFIRMED");
            stmt.setBigDecimal(3, order.getTotalAmount());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        long orderId = rs.getLong(1);
                        order.setId(orderId);
                        return orderId;
                    }
                }
            }
        }
        throw new SQLException("Failed to create order, no ID obtained.");
    }

    @Override
    public boolean createOrderItem(Connection conn, OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, item.getOrderId());
            stmt.setLong(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setBigDecimal(4, item.getUnitPrice());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        item.setId(rs.getLong(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean deductProductStock(Connection conn, Long productId, int quantity) throws SQLException {
        String sql = "UPDATE products SET stock_qty = stock_qty - ? WHERE id = ? AND stock_qty >= ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setLong(2, productId);
            stmt.setInt(3, quantity);

            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public Order findById(Long orderId) {
        String sql = """
                SELECT o.id, o.buyer_id, o.status, o.total_amount, o.created_at,
                       u.name AS buyer_name, u.email AS buyer_email
                FROM orders o
                JOIN users u ON o.buyer_id = u.id
                WHERE o.id = ?
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(findItemsByOrderId(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding order by id: {}", orderId, e);
        }
        return null;
    }

    @Override
    public List<Order> findByBuyerId(Long buyerId) {
        List<Order> orders = new ArrayList<>();
        String sql = """
                SELECT o.id, o.buyer_id, o.status, o.total_amount, o.created_at,
                       u.name AS buyer_name, u.email AS buyer_email
                FROM orders o
                JOIN users u ON o.buyer_id = u.id
                WHERE o.buyer_id = ?
                ORDER BY o.id DESC
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(findItemsByOrderId(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding orders for buyer: {}", buyerId, e);
        }
        return orders;
    }

    @Override
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = """
                SELECT o.id, o.buyer_id, o.status, o.total_amount, o.created_at,
                       u.name AS buyer_name, u.email AS buyer_email
                FROM orders o
                JOIN users u ON o.buyer_id = u.id
                ORDER BY o.id DESC
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(findItemsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            logger.error("Error finding all orders", e);
        }
        return orders;
    }

    @Override
    public List<OrderItem> findItemsByOrderId(Long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = """
                SELECT oi.id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price, oi.created_at,
                       p.name AS product_name, p.image_url, p.seller_id
                FROM order_items oi
                JOIN products p ON oi.product_id = p.id
                WHERE oi.order_id = ?
                ORDER BY oi.id ASC
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getLong("id"));
                    item.setOrderId(rs.getLong("order_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImageUrl(rs.getString("image_url"));
                    item.setSellerId(rs.getLong("seller_id"));
                    if (rs.getTimestamp("created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding items for order: {}", orderId, e);
        }
        return items;
    }

    @Override
    public List<OrderItem> findItemsBySellerId(Long sellerId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = """
                SELECT oi.id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price, oi.created_at,
                       p.name AS product_name, p.image_url, p.seller_id
                FROM order_items oi
                JOIN products p ON oi.product_id = p.id
                WHERE p.seller_id = ?
                ORDER BY oi.id DESC
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getLong("id"));
                    item.setOrderId(rs.getLong("order_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImageUrl(rs.getString("image_url"));
                    item.setSellerId(rs.getLong("seller_id"));
                    if (rs.getTimestamp("created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding order items for seller: {}", sellerId, e);
        }
        return items;
    }

    @Override
    public boolean updateOrderStatus(Long orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setLong(2, orderId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating status for order: {}", orderId, e);
        }
        return false;
    }

    @Override
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting orders", e);
        }
        return 0;
    }

    @Override
    public int countOrdersBySeller(Long sellerId) {
        String sql = """
                SELECT COUNT(DISTINCT oi.order_id)
                FROM order_items oi
                JOIN products p ON oi.product_id = p.id
                WHERE p.seller_id = ?
                """;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting seller orders: {}", sellerId, e);
        }
        return 0;
    }

    @Override
    public BigDecimal calculateTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'CANCELLED'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            logger.error("Error calculating total revenue", e);
        }
        return BigDecimal.ZERO;
    }

    @Override
    public BigDecimal calculateSellerRevenue(Long sellerId) {
        String sql = """
                SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0)
                FROM order_items oi
                JOIN products p ON oi.product_id = p.id
                JOIN orders o ON oi.order_id = o.id
                WHERE p.seller_id = ? AND o.status != 'CANCELLED'
                """;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error calculating revenue for seller: {}", sellerId, e);
        }
        return BigDecimal.ZERO;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setBuyerId(rs.getLong("buyer_id"));
        order.setStatus(rs.getString("status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        if (rs.getTimestamp("created_at") != null) {
            order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        try {
            order.setBuyerName(rs.getString("buyer_name"));
            order.setBuyerEmail(rs.getString("buyer_email"));
        } catch (SQLException ignored) {
        }
        return order;
    }
}
