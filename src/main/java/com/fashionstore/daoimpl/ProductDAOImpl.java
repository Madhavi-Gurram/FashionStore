
package com.fashionstore.daoimpl;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;
import com.fashionstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    // Get all active products
    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting all products: " + e.getMessage());
        }
        return products;
    }

    // Get product by ID
    @Override
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ? AND is_active = true";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapProduct(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
        }
        return null;
    }

    // Get products by category
    @Override
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ? AND is_active = true";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting products by category: " + e.getMessage());
        }
        return products;
    }

    // Search products by keyword
    @Override
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true " +
                     "AND (name LIKE ? OR description LIKE ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchKey = "%" + keyword + "%";
            ps.setString(1, searchKey);
            ps.setString(2, searchKey);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error searching products: " + e.getMessage());
        }
        return products;
    }

    // Filter products by price range
    @Override
    public List<Product> filterByPriceRange(double minPrice, double maxPrice) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true " +
                     "AND price BETWEEN ? AND ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, minPrice);
            ps.setDouble(2, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error filtering by price: " + e.getMessage());
        }
        return products;
    }

    // Filter products by category and price range
    @Override
    public List<Product> filterProducts(int categoryId, double minPrice, double maxPrice) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true " +
                     "AND category_id = ? AND price BETWEEN ? AND ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setDouble(2, minPrice);
            ps.setDouble(3, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error filtering products: " + e.getMessage());
        }
        return products;
    }

    // Get all variants of a product
    @Override
    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                variants.add(mapVariant(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting variants: " + e.getMessage());
        }
        return variants;
    }

    // Get specific variant by ID
    @Override
    public ProductVariant getVariantById(int variantId) {
        String sql = "SELECT * FROM product_variants WHERE variant_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, variantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapVariant(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting variant by ID: " + e.getMessage());
        }
        return null;
    }

    // Check stock availability
    @Override
    public boolean isStockAvailable(int variantId, int quantity) {
        String sql = "SELECT stock FROM product_variants WHERE variant_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, variantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock") >= quantity;
            }

        } catch (SQLException e) {
            System.out.println("Error checking stock: " + e.getMessage());
        }
        return false;
    }

    // Update stock after order placed
    @Override
    public boolean updateStock(int variantId, int quantity) {
        String sql = "UPDATE product_variants SET stock = stock - ? WHERE variant_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, variantId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating stock: " + e.getMessage());
        }
        return false;
    }

    // Helper method to map ResultSet to Product object
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

    // Helper method to map ResultSet to ProductVariant object
    private ProductVariant mapVariant(ResultSet rs) throws SQLException {
        ProductVariant variant = new ProductVariant();
        variant.setVariantId(rs.getInt("variant_id"));
        variant.setProductId(rs.getInt("product_id"));
        variant.setSize(rs.getString("size"));
        variant.setStock(rs.getInt("stock"));
        return variant;
    }
}