
package com.fashionstore.model;

public class Order {

    private int orderId;
    private int userId;
    private String orderDate;
    private double totalAmount;
    private String paymentMethod;
    private String orderStatus;
    private String deliveryName;
    private String deliveryPhone;
    private String deliveryAddress;
    private String deliveryCity;
    private String deliveryState;
    private String deliveryPincode;
    private String trackingNumber;
    private String estimatedDelivery;
    private String placedAt;
    private String processingAt;
    private String shippedAt;
    private String deliveredAt;

    // Default Constructor
    public Order() {}

    // Parameterized Constructor
    public Order(int orderId, int userId, String orderDate, double totalAmount,
                 String paymentMethod, String orderStatus, String deliveryName,
                 String deliveryPhone, String deliveryAddress, String deliveryCity,
                 String deliveryState, String deliveryPincode,
                 String trackingNumber, String estimatedDelivery,
                 String placedAt, String processingAt,
                 String shippedAt, String deliveredAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.deliveryName = deliveryName;
        this.deliveryPhone = deliveryPhone;
        this.deliveryAddress = deliveryAddress;
        this.deliveryCity = deliveryCity;
        this.deliveryState = deliveryState;
        this.deliveryPincode = deliveryPincode;
        this.trackingNumber = trackingNumber;
        this.estimatedDelivery = estimatedDelivery;
        this.placedAt = placedAt;
        this.processingAt = processingAt;
        this.shippedAt = shippedAt;
        this.deliveredAt = deliveredAt;
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { 
        this.paymentMethod = paymentMethod; 
    }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { 
        this.orderStatus = orderStatus; 
    }

    public String getDeliveryName() { return deliveryName; }
    public void setDeliveryName(String deliveryName) { 
        this.deliveryName = deliveryName; 
    }

    public String getDeliveryPhone() { return deliveryPhone; }
    public void setDeliveryPhone(String deliveryPhone) { 
        this.deliveryPhone = deliveryPhone; 
    }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { 
        this.deliveryAddress = deliveryAddress; 
    }

    public String getDeliveryCity() { return deliveryCity; }
    public void setDeliveryCity(String deliveryCity) { 
        this.deliveryCity = deliveryCity; 
    }

    public String getDeliveryState() { return deliveryState; }
    public void setDeliveryState(String deliveryState) { 
        this.deliveryState = deliveryState; 
    }

    public String getDeliveryPincode() { return deliveryPincode; }
    public void setDeliveryPincode(String deliveryPincode) { 
        this.deliveryPincode = deliveryPincode; 
    }

    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { 
        this.trackingNumber = trackingNumber; 
    }

    public String getEstimatedDelivery() { return estimatedDelivery; }
    public void setEstimatedDelivery(String estimatedDelivery) { 
        this.estimatedDelivery = estimatedDelivery; 
    }

    public String getPlacedAt() { return placedAt; }
    public void setPlacedAt(String placedAt) { this.placedAt = placedAt; }

    public String getProcessingAt() { return processingAt; }
    public void setProcessingAt(String processingAt) { 
        this.processingAt = processingAt; 
    }

    public String getShippedAt() { return shippedAt; }
    public void setShippedAt(String shippedAt) { this.shippedAt = shippedAt; }

    public String getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(String deliveredAt) { 
        this.deliveredAt = deliveredAt; 
    }
}
