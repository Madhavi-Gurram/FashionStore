
package com.fashionstore.controller;

import com.fashionstore.daoimpl.CartDAOImpl;
import com.fashionstore.daoimpl.ProductDAOImpl;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private CartDAOImpl cartDAO;
    private ProductDAOImpl productDAO;

    @Override
    public void init() {
        cartDAO   = new CartDAOImpl();
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "view";

        switch (action) {

            case "view":
                handleViewCart(request, response);
                break;

            case "remove":
                handleRemoveItem(request, response);
                break;

            default:
                handleViewCart(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "add":
                handleAddToCart(request, response);
                break;

            case "update":
                handleUpdateQuantity(request, response);
                break;

            default:
                handleViewCart(request, response);
                break;
        }
    }

    // =============================================
    // VIEW CART
    // =============================================
    private void handleViewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Not logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        Cart cart = cartDAO.getCartByUserId(userId);

        if (cart == null) {
            cartDAO.createCart(userId);
            cart = cartDAO.getCartByUserId(userId);
        }

        List<CartItem> cartItems = cartDAO.getCartItems(cart.getCartId());

        // Build enriched cart item data
        List<Map<String, Object>> enrichedItems = new ArrayList<>();

        for (CartItem item : cartItems) {
            Map<String, Object> map = new HashMap<>();
            Product product         = productDAO.getProductById(item.getProductId());
            ProductVariant variant  = productDAO.getVariantById(item.getVariantId());

            map.put("cartItem", item);
            map.put("product",  product);
            map.put("variant",  variant);
            map.put("subtotal", product.getPrice() * item.getQuantity());

            enrichedItems.add(map);
        }

        double cartTotal = cartDAO.getCartTotal(cart.getCartId());
        int    itemCount = cartDAO.getCartItemCount(cart.getCartId());

        // Update cart count in session
        session.setAttribute("cartCount", itemCount);

        request.setAttribute("cart",         cart);
        request.setAttribute("enrichedItems", enrichedItems);
        request.setAttribute("cartTotal",     cartTotal);
        request.setAttribute("itemCount",     itemCount);

        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp")
               .forward(request, response);
    }

    // =============================================
    // ADD TO CART
    // =============================================
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Not logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String productIdStr = request.getParameter("productId");
        String variantIdStr = request.getParameter("variantId");
        String quantityStr  = request.getParameter("quantity");

        if (productIdStr == null || variantIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int variantId = Integer.parseInt(variantIdStr);
            int quantity  = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;

            // Check stock
            if (!productDAO.isStockAvailable(variantId, quantity)) {
                response.sendRedirect(request.getContextPath()
                    + "/products?action=detail&id=" + productId
                    + "&error=outofstock");
                return;
            }

            // Get or create cart
            Cart cart = cartDAO.getCartByUserId(userId);
            if (cart == null) {
                cartDAO.createCart(userId);
                cart = cartDAO.getCartByUserId(userId);
            }

            // Add item
            CartItem cartItem = new CartItem();
            cartItem.setCartId(cart.getCartId());
            cartItem.setProductId(productId);
            cartItem.setVariantId(variantId);
            cartItem.setQuantity(quantity);

            cartDAO.addItemToCart(cartItem);

            // Update cart count in session
            int itemCount = cartDAO.getCartItemCount(cart.getCartId());
            session.setAttribute("cartCount", itemCount);

            // Redirect to cart
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    // =============================================
    // UPDATE QUANTITY
    // =============================================
    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        String cartItemIdStr = request.getParameter("cartItemId");
        String quantityStr   = request.getParameter("quantity");

        try {
            int cartItemId = Integer.parseInt(cartItemIdStr);
            int quantity   = Integer.parseInt(quantityStr);

            if (quantity < 1) quantity = 1;

            cartDAO.updateCartItemQuantity(cartItemId, quantity);

        } catch (NumberFormatException e) {
            // ignore
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // =============================================
    // REMOVE ITEM
    // =============================================
    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        String cartItemIdStr = request.getParameter("cartItemId");

        try {
            int cartItemId = Integer.parseInt(cartItemIdStr);
            cartDAO.removeItemFromCart(cartItemId);

            // Update cart count in session
            int userId = (int) session.getAttribute("userId");
            Cart cart  = cartDAO.getCartByUserId(userId);
            if (cart != null) {
                int itemCount = cartDAO.getCartItemCount(cart.getCartId());
                session.setAttribute("cartCount", itemCount);
            }

        } catch (NumberFormatException e) {
            // ignore
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}