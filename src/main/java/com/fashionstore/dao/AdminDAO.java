
package com.fashionstore.dao;

import com.fashionstore.model.Order;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import java.util.List;

public interface AdminDAO {

    // =============================================
    // DASHBOARD STATS
    // =============================================

    // Get total products count
    int getTotalProducts();

    // Get total orders count
    int getTotalOrders();

    // Get total users count
    int getTotalUsers();

    // Get total revenue
    double getTotalRevenue();

    // Get recent orders for dashboard
    List<Order> getRecentOrders(int limit);

    // =============================================
    // PRODUCT MANAGEMENT
    // =============================================

    // Get all products including inactive
    List<Product> getAllProductsForAdmin();

    // Add new product
    boolean addProduct(Product product);

    // Update existing product
    boolean updateProduct(Product product);

    // Delete product (soft delete)
    boolean deleteProduct(int productId);

    // =============================================
    // ORDER MANAGEMENT
    // =============================================

    // Get all orders
    List<Order> getAllOrders();

    // Update order status
    boolean updateOrderStatus(int orderId, String status);

    // =============================================
    // USER MANAGEMENT
    // =============================================

    // Get all users
    List<User> getAllUsers();

  
}