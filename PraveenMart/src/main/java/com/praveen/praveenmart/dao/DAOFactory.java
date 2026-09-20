package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.dao.impl.*;

/**
 * Factory pattern implementation for DAO instantiation as mandated in Section 12.
 */
public class DAOFactory {

    private static final UserDAO userDAO = new UserDAOImpl();
    private static final ProductDAO productDAO = new ProductDAOImpl();
    private static final OrderDAO orderDAO = new OrderDAOImpl();
    private static final CartDAO cartDAO = new CartDAOImpl();
    private static final ReviewDAO reviewDAO = new ReviewDAOImpl();

    private DAOFactory() {
    }

    public static UserDAO getUserDAO() {
        return userDAO;
    }

    public static ProductDAO getProductDAO() {
        return productDAO;
    }

    public static OrderDAO getOrderDAO() {
        return orderDAO;
    }

    public static CartDAO getCartDAO() {
        return cartDAO;
    }

    public static ReviewDAO getReviewDAO() {
        return reviewDAO;
    }
}
