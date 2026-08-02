
package com.fashionstore.daoimpl;

import com.fashionstore.dao.AdminDAO;
import com.fashionstore.model.Order;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;
import com.fashionstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AdminDAOImpl implements AdminDAO {

    // =============================================
    // DASHBOARD STATS
    // =============================================

    @Override
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = true";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getting total products: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getting total orders: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_admin = false";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getting total users: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders "
                   + "WHERE order_status != 'Cancelled'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.out.println("Error getting total revenue: " + e.getMessage());
        }
        return 0.0;
    }

    @Override
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting recent orders: " + e.getMessage());
        }
        return orders;
    }

    // =============================================
    // PRODUCT MANAGEMENT
    // =============================================

    @Override
    public List<Product> getAllProductsForAdmin() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p "
                   + "LEFT JOIN categories c ON p.category_id = c.category_id "
                   + "ORDER BY p.product_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all products for admin: "
                + e.getMessage());
        }
        return products;
    }

    @Override
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, "
                   + "image_url, category_id, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql,
                     Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getImageUrl());
            ps.setInt(5, product.getCategoryId());
            ps.setBoolean(6, product.isActive());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int productId = rs.getInt(1);
                    return productId > 0;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name=?, description=?, price=?, "
                   + "image_url=?, category_id=?, is_active=? "
                   + "WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getImageUrl());
            ps.setInt(5, product.getCategoryId());
            ps.setBoolean(6, product.isActive());
            ps.setInt(7, product.getProductId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET is_active = false WHERE product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
        }
        return false;
    }

    // =============================================
    // ORDER MANAGEMENT
    // =============================================

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all orders: " + e.getMessage());
        }
        return orders;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating order status: " + e.getMessage());
        }
        return false;
    }

    // =============================================
    // USER MANAGEMENT
    // =============================================

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_admin = false "
                   + "ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all users: " + e.getMessage());
        }
        return users;
    }

    // =============================================
    // HELPER MAPPERS
    // =============================================

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setActive(rs.getBoolean("is_active"));
        product.setCreatedAt(rs.getString("created_at"));
        product.setUpdatedAt(rs.getString("updated_at"));
        return product;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getString("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setDeliveryName(rs.getString("delivery_name"));
        order.setDeliveryPhone(rs.getString("delivery_phone"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setDeliveryCity(rs.getString("delivery_city"));
        order.setDeliveryState(rs.getString("delivery_state"));
        order.setDeliveryPincode(rs.getString("delivery_pincode"));
        return order;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setCreatedAt(rs.getString("created_at"));
        user.setAdmin(rs.getBoolean("is_admin"));
        return user;
    }
}