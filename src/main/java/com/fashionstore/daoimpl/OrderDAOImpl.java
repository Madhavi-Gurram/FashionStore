
package com.fashionstore.daoimpl;

import com.fashionstore.dao.OrderDAO;
import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import com.fashionstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    // =============================================
    // PLACE NEW ORDER
    // =============================================
    @Override
    public int placeOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, payment_method, " +
                     "order_status, delivery_name, delivery_phone, delivery_address, " +
                     "delivery_city, delivery_state, delivery_pincode, " +
                     "tracking_number, estimated_delivery) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql,
                     Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setString(3, order.getPaymentMethod());
            ps.setString(4, order.getOrderStatus());
            ps.setString(5, order.getDeliveryName());
            ps.setString(6, order.getDeliveryPhone());
            ps.setString(7, order.getDeliveryAddress());
            ps.setString(8, order.getDeliveryCity());
            ps.setString(9, order.getDeliveryState());
            ps.setString(10, order.getDeliveryPincode());
            ps.setString(11, order.getTrackingNumber());
            ps.setString(12, order.getEstimatedDelivery());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error placing order: " + e.getMessage());
        }
        return -1;
    }

    // =============================================
    // ADD ORDER ITEMS
    // =============================================
    @Override
    public boolean addOrderItems(List<OrderItem> orderItems) {
        String sql = "INSERT INTO order_items " +
                     "(order_id, product_id, variant_id, quantity, price) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (OrderItem item : orderItems) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getVariantId());
                ps.setInt(4, item.getQuantity());
                ps.setDouble(5, item.getPrice());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            return results.length > 0;

        } catch (SQLException e) {
            System.out.println("Error adding order items: " + e.getMessage());
        }
        return false;
    }

    // =============================================
    // GET ORDER BY ID
    // =============================================
    @Override
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapOrder(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error getting order by ID: " + e.getMessage());
        }
        return null;
    }

    // =============================================
    // GET ALL ORDERS OF A USER
    // =============================================
    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? " +
                     "ORDER BY order_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting orders by user: " + e.getMessage());
        }
        return orders;
    }

    // =============================================
    // GET ALL ITEMS OF AN ORDER
    // =============================================
    @Override
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orderItems.add(mapOrderItem(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error getting order items: " + e.getMessage());
        }
        return orderItems;
    }

    // =============================================
    // UPDATE ORDER STATUS + TIMESTAMPS
    // =============================================
    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ?, " +
                     "processing_at = CASE WHEN ? = 'Processing' " +
                     "  THEN NOW() ELSE processing_at END, " +
                     "shipped_at = CASE WHEN ? = 'Shipped' " +
                     "  THEN NOW() ELSE shipped_at END, " +
                     "delivered_at = CASE WHEN ? = 'Delivered' " +
                     "  THEN NOW() ELSE delivered_at END " +
                     "WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setString(4, status);
            ps.setInt(5, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating order status: " + e.getMessage());
        }
        return false;
    }

    // =============================================
    // UPDATE TRACKING NUMBER
    // =============================================
    @Override
    public boolean updateTrackingNumber(int orderId, String trackingNumber) {
        String sql = "UPDATE orders SET tracking_number = ? " +
                     "WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, trackingNumber);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating tracking number: " + e.getMessage());
        }
        return false;
    }

    // =============================================
    // HELPER METHODS
    // =============================================
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
        order.setTrackingNumber(rs.getString("tracking_number"));
        order.setEstimatedDelivery(rs.getString("estimated_delivery"));
        order.setPlacedAt(rs.getString("placed_at"));
        order.setProcessingAt(rs.getString("processing_at"));
        order.setShippedAt(rs.getString("shipped_at"));
        order.setDeliveredAt(rs.getString("delivered_at"));
        return order;
    }

    private OrderItem mapOrderItem(ResultSet rs) throws SQLException {
        OrderItem orderItem = new OrderItem();
        orderItem.setOrderItemId(rs.getInt("order_item_id"));
        orderItem.setOrderId(rs.getInt("order_id"));
        orderItem.setProductId(rs.getInt("product_id"));
        orderItem.setVariantId(rs.getInt("variant_id"));
        orderItem.setQuantity(rs.getInt("quantity"));
        orderItem.setPrice(rs.getDouble("price"));
        return orderItem;
    }
}