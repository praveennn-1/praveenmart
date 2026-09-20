package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class ProductService {

    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);
    private final ProductDAO productDAO;

    public ProductService() {
        this(new ProductDAOImpl());
    }

    public ProductService(ProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }

    public List<Product> getProductsByCategory(String category) {
        if (category == null || category.trim().isBlank() || "all".equalsIgnoreCase(category.trim())) {
            return getAllProducts();
        }
        return productDAO.findByCategory(category.trim());
    }

    public List<Product> searchProducts(String keyword, String category) {
        return productDAO.search(keyword, category);
    }

    public List<Product> getProductsBySellerId(Long sellerId) {
        if (sellerId == null) {
            return List.of();
        }
        return productDAO.findBySellerId(sellerId);
    }

    public Product getProductById(Long id) {
        if (id == null) {
            return null;
        }
        return productDAO.findById(id);
    }

    public boolean createProduct(Product product) {
        validateProduct(product);
        boolean created = productDAO.createProduct(product);
        if (created) {
            logger.info("Product created: id={}, name={}, sellerId={}", product.getId(), product.getName(),
                    product.getSellerId());
        }
        return created;
    }

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

    public boolean deleteProduct(Long id, Long sellerId) {
        if (id == null) {
            return false;
        }
        return productDAO.deleteProduct(id, sellerId);
    }

    public boolean adminDeleteProduct(Long id) {
        if (id == null) {
            return false;
        }
        return productDAO.adminDeleteProduct(id);
    }

    public int getTotalProductsCount() {
        return productDAO.countProducts();
    }

    public int getSellerProductsCount(Long sellerId) {
        if (sellerId == null)
            return 0;
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
