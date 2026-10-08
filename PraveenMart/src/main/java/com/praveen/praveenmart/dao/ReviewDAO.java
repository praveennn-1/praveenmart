package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.Review;

import java.util.List;

/**
 * Data Access Object interface for product reviews and star ratings (Requirement F8).
 */
public interface ReviewDAO {

    /**
     * Retrieves all customer reviews for a specific product.
     *
     * @param productId the product ID
     * @return list of reviews
     */
    List<Review> findByProductId(Long productId);

    /**
     * Persists a new customer review and rating.
     *
     * @param review the review entity
     * @return true if created
     */
    boolean createReview(Review review);

    /**
     * Calculates the average star rating for a product (1.0 to 5.0).
     *
     * @param productId the product ID
     * @return average rating
     */
    double getAverageRating(Long productId);

    /**
     * Returns the total review count for a product.
     *
     * @param productId the product ID
     * @return review count
     */
    int countReviews(Long productId);
}
