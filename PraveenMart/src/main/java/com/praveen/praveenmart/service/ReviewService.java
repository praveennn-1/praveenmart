package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ReviewDAO;
import com.praveen.praveenmart.dao.impl.ReviewDAOImpl;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Review;

import java.util.List;

/**
 * Service managing customer reviews and ratings on products (Requirement F8).
 */
public class ReviewService {

    private final ReviewDAO reviewDAO;

    /**
     * Default constructor initializing with {@link ReviewDAOImpl}.
     */
    public ReviewService() {
        this(new ReviewDAOImpl());
    }

    /**
     * Dependency injection constructor for testing.
     *
     * @param reviewDAO the review data access object
     */
    public ReviewService(ReviewDAO reviewDAO) {
        this.reviewDAO = reviewDAO;
    }

    /**
     * Retrieves all approved customer reviews for a given product.
     *
     * @param productId the product ID
     * @return list of reviews
     */
    public List<Review> getReviewsForProduct(Long productId) {
        if (productId == null) {
            return List.of();
        }
        return reviewDAO.findByProductId(productId);
    }

    /**
     * Submits a new product review and star rating with validation.
     *
     * @param productId the product ID
     * @param userId    the user ID
     * @param rating    the star rating (1 to 5)
     * @param comment   the written feedback
     * @return true if review was created successfully
     */
    public boolean addReview(Long productId, Long userId, int rating, String comment) {
        if (productId == null || userId == null) {
            throw new ValidationException("Product and User are required to submit a review.");
        }
        if (rating < 1 || rating > 5) {
            throw new ValidationException("Rating must be between 1 and 5 stars.");
        }

        Review review = new Review();
        review.setProductId(productId);
        review.setUserId(userId);
        review.setRating(rating);
        review.setComment(comment != null ? comment.trim() : "");

        return reviewDAO.createReview(review);
    }

    /**
     * Computes the average star rating for a product.
     *
     * @param productId the product ID
     * @return average rating
     */
    public double getAverageRating(Long productId) {
        if (productId == null) {
            return 0.0;
        }
        return reviewDAO.getAverageRating(productId);
    }

    /**
     * Returns the total review count for a product.
     *
     * @param productId the product ID
     * @return review count
     */
    public int getReviewCount(Long productId) {
        if (productId == null) {
            return 0;
        }
        return reviewDAO.countReviews(productId);
    }
}
