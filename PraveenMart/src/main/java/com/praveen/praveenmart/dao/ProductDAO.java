package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.Product;

import java.util.List;

/**
 * Data Access Object interface for Product operations.
 */
public interface ProductDAO {

    /**
     * Retrieves all products in the database.
     *
     * @return list of products
     */
    List<Product> findAll();

    /**
     * Finds products belonging to a specific category.
     *
     * @param category the category name
     * @return list of products
     */
    List<Product> findByCategory(String category);

    /**
     * Searches products by keyword in name/description and optional category.
     *
     * @param keyword  the search term
     * @param category the optional category
     * @return list of matched products
     */
    List<Product> search(String keyword, String category);

    /**
     * Finds all products listed by a seller.
     *
     * @param sellerId the seller ID
     * @return list of products
     */
    List<Product> findBySellerId(Long sellerId);

    /**
     * Finds a single product by primary key ID.
     *
     * @param id the product ID
     * @return product or null
     */
    Product findById(Long id);

    /**
     * Inserts a new product record.
     *
     * @param product the product entity
     * @return true if created
     */
    boolean createProduct(Product product);

    /**
     * Updates an existing product record.
     *
     * @param product the product entity
     * @return true if updated
     */
    boolean updateProduct(Product product);

    /**
     * Deletes a product verifying seller ownership.
     *
     * @param id       the product ID
     * @param sellerId the seller ID
     * @return true if deleted
     */
    boolean deleteProduct(Long id, Long sellerId);

    /**
     * Deletes a product as an administrator without seller ownership check.
     *
     * @param id the product ID
     * @return true if deleted
     */
    boolean adminDeleteProduct(Long id);

    /**
     * Counts the total number of products.
     *
     * @return total product count
     */
    int countProducts();

    /**
     * Counts the products listed by a seller.
     *
     * @param sellerId the seller ID
     * @return product count
     */
    int countProductsBySeller(Long sellerId);
}
