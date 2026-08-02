
package com.fashionstore.model;

public class Cart {

    private int cartId;
    private int userId;
    private String createdAt;

    // Default Constructor
    public Cart() {}

    // Parameterized Constructor
    public Cart(int cartId, int userId, String createdAt) {
        this.cartId = cartId;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
