package com.praveen.praveenmart.dao.impl;

import com.praveen.praveenmart.dao.CartDAO;
import com.praveen.praveenmart.model.CartItem;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link CartDAO} for shopping cart persistence.
 */
public class CartDAOImpl implements CartDAO {

    private static final Logger logger = LoggerFactory.getLogger(CartDAOImpl.class);

    @Override
    public List<CartItem> findByUserId(Long userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = """
                SELECT c.id AS cart_id, c.user_id, c.product_id, c.quantity, c.created_at AS cart_created_at,
                       p.id AS product_id, p.seller_id, p.name, p.description, p.price, p.stock_qty, p.category, p.image_url,
                       u.name AS seller_name
                FROM cart_items c
                JOIN products p ON c.product_id = p.id
                LEFT JOIN users u ON p.seller_id = u.id
                WHERE c.user_id = ?
                ORDER BY c.id DESC
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getLong("cart_id"));
                    item.setUserId(rs.getLong("user_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    if (rs.getTimestamp("cart_created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("cart_created_at").toLocalDateTime());
                    }

                    Product p = new Product();
                    p.setId(rs.getLong("product_id"));
                    p.setSellerId(rs.getLong("seller_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setStockQty(rs.getInt("stock_qty"));
                    p.setCategory(rs.getString("category"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setSellerName(rs.getString("seller_name"));
                    item.setProduct(p);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding cart items for user: {}", userId, e);
        }
        return items;
    }

    @Override
    public CartItem findByUserAndProduct(Long userId, Long productId) {
        String sql = "SELECT id, user_id, product_id, quantity, created_at FROM cart_items WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getLong("id"));
                    item.setUserId(rs.getLong("user_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    if (rs.getTimestamp("created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    return item;
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding cart item user={}, product={}", userId, productId, e);
        }
        return null;
    }

    @Override
    public boolean addToCart(Long userId, Long productId, int quantity) {
        CartItem existing = findByUserAndProduct(userId, productId);
        if (existing != null) {
            return updateQuantity(existing.getId(), existing.getQuantity() + quantity);
        }

        String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            stmt.setInt(3, quantity);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error adding to cart user={}, product={}, qty={}", userId, productId, quantity, e);
        }
        return false;
    }

    @Override
    public boolean updateQuantity(Long cartItemId, int quantity) {
        if (quantity <= 0) {
            String deleteSql = "DELETE FROM cart_items WHERE id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                stmt.setLong(1, cartItemId);
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                logger.error("Error deleting cart item with zero qty: {}", cartItemId, e);
                return false;
            }
        }

        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setLong(2, cartItemId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating cart item qty: {}", cartItemId, e);
        }
        return false;
    }

    @Override
    public boolean removeFromCart(Long cartItemId, Long userId) {
        String sql = "DELETE FROM cart_items WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, cartItemId);
            stmt.setLong(2, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error removing cart item: {} for user: {}", cartItemId, userId, e);
        }
        return false;
    }

    @Override
    public boolean clearCart(Long userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            logger.error("Error clearing cart for user: {}", userId, e);
        }
        return false;
    }

    @Override
    public int getCartItemCount(Long userId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting cart items for user: {}", userId, e);
        }
        return 0;
    }
}
