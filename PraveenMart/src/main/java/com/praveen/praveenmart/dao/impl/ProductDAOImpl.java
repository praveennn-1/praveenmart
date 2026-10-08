package com.praveen.praveenmart.dao.impl;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link ProductDAO} for product catalog persistence.
 */
public class ProductDAOImpl implements ProductDAO {

    private static final Logger logger = LoggerFactory.getLogger(ProductDAOImpl.class);

    private static final String BASE_SELECT = """
            SELECT p.id, p.seller_id, p.name, p.description, p.price, p.stock_qty, p.category, p.image_url, p.created_at,
                   u.name AS seller_name
            FROM products p
            LEFT JOIN users u ON p.seller_id = u.id
            """;

    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT + " ORDER BY p.id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all products", e);
        }
        return products;
    }

    @Override
    public List<Product> findByCategory(String category) {
        if (category == null || category.trim().isBlank() || "all".equalsIgnoreCase(category.trim())) {
            return findAll();
        }
        return search(null, category);
    }

    @Override
    public List<Product> search(String keyword, String category) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1 ");

        boolean hasKeyword = keyword != null && !keyword.trim().isBlank();
        boolean hasCategory = category != null && !category.trim().isBlank() && !"all".equalsIgnoreCase(category.trim());

        if (hasKeyword) {
            sql.append(" AND (LOWER(p.name) LIKE ? OR LOWER(p.description) LIKE ?) ");
        }
        if (hasCategory) {
            String cat = category.trim().toLowerCase();
            if (cat.contains("fashion") || cat.contains("style") || cat.contains("apparel")) {
                sql.append(" AND (LOWER(p.category) LIKE '%fashion%' OR LOWER(p.category) LIKE '%style%' OR LOWER(p.category) LIKE '%apparel%') ");
            } else if (cat.contains("home") || cat.contains("kitchen")) {
                sql.append(" AND (LOWER(p.category) LIKE '%home%' OR LOWER(p.category) LIKE '%kitchen%') ");
            } else {
                sql.append(" AND LOWER(p.category) LIKE ? ");
            }
        }
        sql.append(" ORDER BY p.id DESC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (hasKeyword) {
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (hasCategory) {
                String cat = category.trim().toLowerCase();
                if (!cat.contains("fashion") && !cat.contains("style") && !cat.contains("apparel") && !cat.contains("home") && !cat.contains("kitchen")) {
                    stmt.setString(paramIndex++, "%" + cat + "%");
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching products: keyword={}, category={}", keyword, category, e);
        }
        return products;
    }

    @Override
    public List<Product> findBySellerId(Long sellerId) {
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE p.seller_id = ? ORDER BY p.id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding products by sellerId: {}", sellerId, e);
        }
        return products;
    }

    @Override
    public Product findById(Long id) {
        String sql = BASE_SELECT + " WHERE p.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding product by id: {}", id, e);
        }
        return null;
    }

    @Override
    public boolean createProduct(Product product) {
        String sql = """
                INSERT INTO products (seller_id, name, description, price, stock_qty, category, image_url)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, product.getSellerId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setBigDecimal(4, product.getPrice());
            stmt.setInt(5, product.getStockQty());
            stmt.setString(6, product.getCategory());
            stmt.setString(7, product.getImageUrl());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating product: {}", product.getName(), e);
        }
        return false;
    }

    @Override
    public boolean updateProduct(Product product) {
        String sql = """
                UPDATE products
                SET name = ?, description = ?, price = ?, stock_qty = ?, category = ?, image_url = ?
                WHERE id = ? AND (seller_id = ? OR seller_id IS NULL)
                """;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStockQty());
            stmt.setString(5, product.getCategory());
            stmt.setString(6, product.getImageUrl());
            stmt.setLong(7, product.getId());
            if (product.getSellerId() != null) {
                stmt.setLong(8, product.getSellerId());
            } else {
                stmt.setNull(8, Types.BIGINT);
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating product id: {}", product.getId(), e);
        }
        return false;
    }

    @Override
    public boolean deleteProduct(Long id, Long sellerId) {
        String sql = "DELETE FROM products WHERE id = ? AND (seller_id = ? OR ? IS NULL)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            if (sellerId != null) {
                stmt.setLong(2, sellerId);
                stmt.setLong(3, sellerId);
            } else {
                stmt.setNull(2, Types.BIGINT);
                stmt.setNull(3, Types.BIGINT);
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting product id: {}", id, e);
        }
        return false;
    }

    @Override
    public boolean adminDeleteProduct(Long id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error admin deleting product id: {}", id, e);
        }
        return false;
    }

    @Override
    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting products", e);
        }
        return 0;
    }

    @Override
    public int countProductsBySeller(Long sellerId) {
        String sql = "SELECT COUNT(*) FROM products WHERE seller_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting products for seller: {}", sellerId, e);
        }
        return 0;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getLong("id"));
        p.setSellerId(rs.getLong("seller_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStockQty(rs.getInt("stock_qty"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));
        if (rs.getTimestamp("created_at") != null) {
            p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        try {
            p.setSellerName(rs.getString("seller_name"));
        } catch (SQLException ignored) {
        }
        return p;
    }
}
