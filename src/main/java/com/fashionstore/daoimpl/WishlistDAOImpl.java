package com.fashionstore.daoimpl;

import com.fashionstore.dao.WishlistDAO;
import com.fashionstore.model.Product;
import com.fashionstore.model.Wishlist;
import com.fashionstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAOImpl implements WishlistDAO {

    // Add to wishlist
    @Override
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding to wishlist: " + e.getMessage());
        }
        return false;
    }

    // Remove from wishlist
    @Override
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error removing from wishlist: " + e.getMessage());
        }
        return false;
    }

    // Check if in wishlist
    @Override
    public boolean isInWishlist(int userId, int productId) {
        String sql = "SELECT wishlist_id FROM wishlist " +
                     "WHERE user_id = ? AND product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Error checking wishlist: " + e.getMessage());
        }
        return false;
    }

    // Get all wishlist products
    @Override
    public List<Product> getWishlistProducts(int userId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.* FROM products p " +
                     "JOIN wishlist w ON p.product_id = w.product_id " +
                     "WHERE w.user_id = ? AND p.is_active = true " +
                     "ORDER BY w.added_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting wishlist: " + e.getMessage());
        }
        return products;
    }

    // Get wishlist count
    @Override
    public int getWishlistCount(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getting wishlist count: " + e.getMessage());
        }
        return 0;
    }

    // Helper mapper
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
        return product;
    }
}