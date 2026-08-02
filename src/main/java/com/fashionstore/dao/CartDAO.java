
package com.fashionstore.dao;

import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import java.util.List;

public interface CartDAO {

    // Create cart for user
    boolean createCart(int userId);

    // Get cart by user ID
    Cart getCartByUserId(int userId);

    // Add item to cart
    boolean addItemToCart(CartItem cartItem);

    // Update item quantity in cart
    boolean updateCartItemQuantity(int cartItemId, int quantity);

    // Remove item from cart
    boolean removeItemFromCart(int cartItemId);

    // Get all items in cart
    List<CartItem> getCartItems(int cartId);

    // Get total amount of cart
    double getCartTotal(int cartId);

    // Clear cart after order placed
    boolean clearCart(int cartId);

    // Get cart item count
    int getCartItemCount(int cartId);
}
