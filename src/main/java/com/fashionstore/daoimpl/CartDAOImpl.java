
package com.fashionstore.daoimpl;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {

    // Create cart for user
    @Override
    public boolean createCart(int userId) {
        String sql = "INSERT INTO cart (user_id) VALUES (?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error creating cart: " + e.getMessage());
        }
        return false;
    }

    // Get cart by user ID
    @Override
    public Cart getCartByUserId(int userId) {
        String sql = "SELECT * FROM cart WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCart(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting cart: " + e.getMessage());
        }
        return null;
    }

    // Add item to cart
    @Override
    public boolean addItemToCart(CartItem cartItem) {
        // Check if same product+variant already exists in cart
        String checkSql = "SELECT cart_item_id, quantity FROM cart_items " +
                          "WHERE cart_id = ? AND product_id = ? AND variant_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setInt(1, cartItem.getCartId());
            checkPs.setInt(2, cartItem.getProductId());
            checkPs.setInt(3, cartItem.getVariantId());
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Item exists — update quantity
                int existingQty = rs.getInt("quantity");
                int cartItemId = rs.getInt("cart_item_id");
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
                PreparedStatement updatePs = con.prepareStatement(updateSql);
                updatePs.setInt(1, existingQty + cartItem.getQuantity());
                updatePs.setInt(2, cartItemId);
                return updatePs.executeUpdate() > 0;
            } else {
                // Item does not exist — insert new
                String insertSql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) " +
                                   "VALUES (?, ?, ?, ?)";
                PreparedStatement insertPs = con.prepareStatement(insertSql);
                insertPs.setInt(1, cartItem.getCartId());
                insertPs.setInt(2, cartItem.getProductId());
                insertPs.setInt(3, cartItem.getVariantId());
                insertPs.setInt(4, cartItem.getQuantity());
                return insertPs.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error adding item to cart: " + e.getMessage());
        }
        return false;
    }

    // Update item quantity in cart
    @Override
    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating cart item quantity: " + e.getMessage());
        }
        return false;
    }

    // Remove item from cart
    @Override
    public boolean removeItemFromCart(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error removing item from cart: " + e.getMessage());
        }
        return false;
    }

    // Get all items in cart
    @Override
    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE cart_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cartItems.add(mapCartItem(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting cart items: " + e.getMessage());
        }
        return cartItems;
    }

    // Get total amount of cart
    @Override
    public double getCartTotal(int cartId) {
        String sql = "SELECT SUM(p.price * ci.quantity) AS total " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.product_id " +
                     "WHERE ci.cart_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (SQLException e) {
            System.out.println("Error getting cart total: " + e.getMessage());
        }
        return 0.0;
    }

    // Clear cart after order placed
    @Override
    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;

        } catch (SQLException e) {
            System.out.println("Error clearing cart: " + e.getMessage());
        }
        return false;
    }

    // Get cart item count
    @Override
    public int getCartItemCount(int cartId) {
        String sql = "SELECT COUNT(*) AS count FROM cart_items WHERE cart_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }

        } catch (SQLException e) {
            System.out.println("Error getting cart item count: " + e.getMessage());
        }
        return 0;
    }

    // Helper method to map ResultSet to Cart object
    private Cart mapCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setCreatedAt(rs.getString("created_at"));
        return cart;
    }

    // Helper method to map ResultSet to CartItem object
    private CartItem mapCartItem(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setCartItemId(rs.getInt("cart_item_id"));
        cartItem.setCartId(rs.getInt("cart_id"));
        cartItem.setProductId(rs.getInt("product_id"));
        cartItem.setVariantId(rs.getInt("variant_id"));
        cartItem.setQuantity(rs.getInt("quantity"));
        return cartItem;
    }
}
