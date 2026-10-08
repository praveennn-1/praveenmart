package com.praveen.praveenmart.dao;

import com.praveen.praveenmart.model.User;

import java.util.List;

/**
 * Data Access Object interface for user identity, role, and authentication queries.
 */
public interface UserDAO {

    /**
     * Finds a user by primary key ID.
     *
     * @param id the user ID
     * @return User entity or null
     */
    User findById(Long id);

    /**
     * Finds a user by unique email address.
     *
     * @param email the user email
     * @return User entity or null
     */
    User findByEmail(String email);

    /**
     * Retrieves all users registered in the platform.
     *
     * @return list of users
     */
    List<User> findAll();

    /**
     * Creates a new user record.
     *
     * @param user the user entity
     * @return true if created
     */
    boolean createUser(User user);

    /**
     * Updates an existing user record.
     *
     * @param user the user entity
     * @return true if updated
     */
    boolean updateUser(User user);

    /**
     * Deletes a user by primary key ID.
     *
     * @param id the user ID
     * @return true if deleted
     */
    boolean deleteUser(Long id);

    /**
     * Counts the total number of users.
     *
     * @return total user count
     */
    int countUsers();

    /**
     * Counts users belonging to a specific role.
     *
     * @param role the role name ('BUYER', 'SELLER', 'ADMIN')
     * @return count of users with that role
     */
    int countUsersByRole(String role);
}
