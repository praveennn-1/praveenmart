package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.ReviewDAOImpl;
import com.praveen.praveenmart.model.Review;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ReviewDAOTest extends BaseDAOTest {

    private ReviewDAO reviewDAO;

    @BeforeEach
    void setUp() {
        reviewDAO = new ReviewDAOImpl();
    }

    @Test
    @DisplayName("Should create review and retrieve average rating")
    void testCreateReviewAndCalculateAverage() {
        Review review = new Review();
        review.setProductId(14L); // Smart Fitness Tracker Watch
        review.setUserId(3L); // buyer
        review.setRating(5);
        review.setComment("Excellent build and long battery life!");

        boolean created = reviewDAO.createReview(review);
        assertTrue(created, "Review should be created successfully");

        List<Review> reviews = reviewDAO.findByProductId(14L);
        assertFalse(reviews.isEmpty(), "Reviews list should not be empty");

        double avg = reviewDAO.getAverageRating(14L);
        assertTrue(avg >= 4.0, "Average rating should be around 5.0");

        int count = reviewDAO.countReviews(14L);
        assertTrue(count >= 1, "Review count should be at least 1");
    }
}
