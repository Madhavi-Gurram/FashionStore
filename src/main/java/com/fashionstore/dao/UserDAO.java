
package com.fashionstore.dao;

import com.fashionstore.model.User;

public interface UserDAO {

    // Register new user
    boolean registerUser(User user);

    // Login user by email and password
    User loginUser(String email, String password);

    // Get user by ID
    User getUserById(int userId);

    // Get user by email
    User getUserByEmail(String email);

    // Get user by phone
    User getUserByPhone(String phone);

    // Update user profile
    boolean updateUser(User user);

    // Update password
    boolean updatePassword(int userId, String newPassword);

    // Check if email already exists
    boolean isEmailExists(String email);
}
