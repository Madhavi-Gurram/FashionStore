package com.fashionstore.model;

public class Wishlist {

    private int wishlistId;
    private int userId;
    private int productId;
    private String addedAt;

    public Wishlist() {}

    public Wishlist(int wishlistId, int userId, int productId, String addedAt) {
        this.wishlistId = wishlistId;
        this.userId     = userId;
        this.productId  = productId;
        this.addedAt    = addedAt;
    }

    public int getWishlistId() { return wishlistId; }
    public void setWishlistId(int wishlistId) { this.wishlistId = wishlistId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getAddedAt() { return addedAt; }
    public void setAddedAt(String addedAt) { this.addedAt = addedAt; }
}