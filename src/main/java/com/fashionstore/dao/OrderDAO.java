


package com.fashionstore.dao;

import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import java.util.List;

public interface OrderDAO {

    // Place new order
    int placeOrder(Order order);

    // Add items to order
    boolean addOrderItems(List<OrderItem> orderItems);

    // Get order by ID
    Order getOrderById(int orderId);

    // Get all orders of a user
    List<Order> getOrdersByUserId(int userId);

    // Get all items of an order
    List<OrderItem> getOrderItems(int orderId);

    // Update order status
    boolean updateOrderStatus(int orderId, String status);
}