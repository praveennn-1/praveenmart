package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Service managing product catalog, seller listings, filtering, and validation (Requirement F2, F3).
 */
public class ProductService {

    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);
    private final ProductDAO productDAO;

    /**
     * Default constructor initializing with default {@link ProductDAOImpl}.
     */
    public ProductService() {
        this(new ProductDAOImpl());
    }

    /**
     * Dependency injection constructor for testing.
     *
     * @param productDAO the product data access object
     */
    public ProductService(ProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    /**
     * Retrieves all products available in the catalog.
     *
     * @return list of all products
     */
    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }

    /**
     * Retrieves products filtered by category.
     *
     * @param category the category name
     * @return list of products matching category
     */
    public List<Product> getProductsByCategory(String category) {
        if (category == null || category.trim().isBlank() || "all".equalsIgnoreCase(category.trim())) {
            return getAllProducts();
        }
        return productDAO.findByCategory(category.trim());
    }

    /**
     * Searches products by keyword and optional category filter.
     *
     * @param keyword  the search keyword
     * @param category the optional category filter
     * @return list of matched products
     */
    public List<Product> searchProducts(String keyword, String category) {
        return productDAO.search(keyword, category);
    }

    /**
     * Retrieves products listed by a specific seller.
     *
     * @param sellerId the seller ID
     * @return list of products owned by seller
     */
    public List<Product> getProductsBySellerId(Long sellerId) {
        if (sellerId == null) {
            return List.of();
        }
        return productDAO.findBySellerId(sellerId);
    }

    /**
     * Finds a single product by its unique ID.
     *
     * @param id the product ID
     * @return product or null if not found
     */
    public Product getProductById(Long id) {
        if (id == null) {
            return null;
        }
        return productDAO.findById(id);
    }

    /**
     * Creates a new product listing with validation.
     *
     * @param product the product entity
     * @return true if created successfully
     */
    public boolean createProduct(Product product) {
        validateProduct(product);
        boolean created = productDAO.createProduct(product);
        if (created) {
            logger.info("Product created: id={}, name={}, sellerId={}", product.getId(), product.getName(),
                    product.getSellerId());
        }
        return created;
    }

    /**
     * Updates an existing product listing.
     *
     * @param product the product entity with updated details
     * @return true if updated successfully
     */
    public boolean updateProduct(Product product) {
        validateProduct(product);
        if (product.getId() == null) {
            throw new ValidationException("Product ID is required for update.");
        }
        boolean updated = productDAO.updateProduct(product);
        if (updated) {
            logger.info("Product updated: id={}, name={}", product.getId(), product.getName());
        }
        return updated;
    }

    /**
     * Deletes a product owned by a specific seller.
     *
     * @param id       the product ID
     * @param sellerId the seller ID
     * @return true if deleted
     */
    public boolean deleteProduct(Long id, Long sellerId) {
        if (id == null) {
            return false;
        }
        return productDAO.deleteProduct(id, sellerId);
    }

    /**
     * Moderates and deletes a product listing as an administrator.
     *
     * @param id the product ID
     * @return true if deleted
     */
    public boolean adminDeleteProduct(Long id) {
        if (id == null) {
            return false;
        }
        return productDAO.adminDeleteProduct(id);
    }

    /**
     * Returns the total count of products in the platform.
     *
     * @return total product count
     */
    public int getTotalProductsCount() {
        return productDAO.countProducts();
    }

    /**
     * Returns the product count for a specific seller.
     *
     * @param sellerId the seller ID
     * @return product count
     */
    public int getSellerProductsCount(Long sellerId) {
        if (sellerId == null) {
            return 0;
        }
        return productDAO.countProductsBySeller(sellerId);
    }

    private void validateProduct(Product product) {
        if (product == null) {
            throw new ValidationException("Product cannot be null.");
        }
        if (product.getName() == null || product.getName().trim().isBlank()) {
            throw new ValidationException("Product name is required.");
        }
        if (!ValidationUtil.isValidPrice(product.getPrice())) {
            throw new ValidationException("Product price must be a positive number.");
        }
        if (!ValidationUtil.isValidStock(product.getStockQty())) {
            throw new ValidationException("Product stock quantity must be non-negative.");
        }
        if (!ValidationUtil.isValidCategory(product.getCategory())) {
            throw new ValidationException("Product category is required.");
        }
    }
}
