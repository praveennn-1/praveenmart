package com.praveen.praveenmart.dao.impl;

import com.praveen.praveenmart.dao.WishlistDAO;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.model.WishlistItem;
import com.praveen.praveenmart.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link WishlistDAO} using PreparedStatement and HikariCP connection pooling.
 */
public class WishlistDAOImpl implements WishlistDAO {

    private static final Logger logger = LoggerFactory.getLogger(WishlistDAOImpl.class);

    /**
     * Adds a product to the user's wishlist using an idempotent MERGE or INSERT statement.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if inserted successfully
     */
    @Override
    public boolean addToWishlist(Long userId, Long productId) {
        String sql = "INSERT INTO wishlist_items (user_id, product_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // Error code 23505 is unique index violation in H2 (already in wishlist)
            if ("23505".equals(e.getSQLState())) {
                logger.debug("Product {} is already in wishlist for user {}", productId, userId);
                return true;
            }
            logger.error("Error adding to wishlist user={} product={}", userId, productId, e);
            return false;
        }
    }

    /**
     * Removes a product from the user's wishlist.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if deleted
     */
    @Override
    public boolean removeFromWishlist(Long userId, Long productId) {
        String sql = "DELETE FROM wishlist_items WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error removing from wishlist user={} product={}", userId, productId, e);
            return false;
        }
    }

    /**
     * Finds all wishlist items for a given user including joined product details.
     *
     * @param userId the user ID
     * @return list of wishlist items
     */
    @Override
    public List<WishlistItem> findByUserId(Long userId) {
        List<WishlistItem> items = new ArrayList<>();
        String sql = "SELECT w.id, w.user_id, w.product_id, w.created_at, "
                + "p.id AS p_id, p.name AS p_name, p.description AS p_description, "
                + "p.price AS p_price, p.stock_qty AS p_stock, p.category AS p_category, "
                + "p.image_url AS p_image "
                + "FROM wishlist_items w "
                + "JOIN products p ON w.product_id = p.id "
                + "WHERE w.user_id = ? "
                + "ORDER BY w.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    WishlistItem item = new WishlistItem();
                    item.setId(rs.getLong("id"));
                    item.setUserId(rs.getLong("user_id"));
                    item.setProductId(rs.getLong("product_id"));
                    if (rs.getTimestamp("created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }

                    Product product = new Product();
                    product.setId(rs.getLong("p_id"));
                    product.setName(rs.getString("p_name"));
                    product.setDescription(rs.getString("p_description"));
                    product.setPrice(rs.getBigDecimal("p_price"));
                    product.setStockQty(rs.getInt("p_stock"));
                    product.setCategory(rs.getString("p_category"));
                    product.setImageUrl(rs.getString("p_image"));

                    item.setProduct(product);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching wishlist items for user={}", userId, e);
        }
        return items;
    }

    /**
     * Checks whether a specific product exists in the user's wishlist.
     *
     * @param userId    the user ID
     * @param productId the product ID
     * @return true if item exists
     */
    @Override
    public boolean isInWishlist(Long userId, Long productId) {
        String sql = "SELECT 1 FROM wishlist_items WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking wishlist user={} product={}", userId, productId, e);
            return false;
        }
    }

    /**
     * Returns total item count in user's wishlist.
     *
     * @param userId the user ID
     * @return count of items
     */
    @Override
    public int countByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM wishlist_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting wishlist for user={}", userId, e);
        }
        return 0;
    }

    /**
     * Clears all items in the user's wishlist.
     *
     * @param userId the user ID
     * @return true if cleared successfully
     */
    @Override
    public boolean clearWishlist(Long userId) {
        String sql = "DELETE FROM wishlist_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            logger.error("Error clearing wishlist for user={}", userId, e);
            return false;
        }
    }
}
