package com.fashionstore.dao;

import com.fashionstore.model.Product;
import com.fashionstore.model.Wishlist;
import java.util.List;

public interface WishlistDAO {

    // Add product to wishlist
    boolean addToWishlist(int userId, int productId);

    // Remove product from wishlist
    boolean removeFromWishlist(int userId, int productId);

    // Check if product is in wishlist
    boolean isInWishlist(int userId, int productId);

    // Get all wishlist items for user
    List<Product> getWishlistProducts(int userId);

    // Get wishlist count
    int getWishlistCount(int userId);
}