

package com.fashionstore.dao;

import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import java.util.List;

public interface OrderDAO {

    int placeOrder(Order order);
    boolean addOrderItems(List<OrderItem> orderItems);
    Order getOrderById(int orderId);
    List<Order> getOrdersByUserId(int userId);
    List<OrderItem> getOrderItems(int orderId);
    boolean updateOrderStatus(int orderId, String status);

    // New method for tracking number
    boolean updateTrackingNumber(int orderId, String trackingNumber);
}