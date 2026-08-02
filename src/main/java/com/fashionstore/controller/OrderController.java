package com.fashionstore.controller;

import com.fashionstore.daoimpl.CartDAOImpl;
import com.fashionstore.daoimpl.OrderDAOImpl;
import com.fashionstore.daoimpl.ProductDAOImpl;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/orders")
public class OrderController extends HttpServlet {

    private OrderDAOImpl orderDAO;
    private CartDAOImpl cartDAO;
    private ProductDAOImpl productDAO;

    @Override
    public void init() {
        orderDAO   = new OrderDAOImpl();
        cartDAO    = new CartDAOImpl();
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "history";

        switch (action) {

            case "checkoutPage":
                handleCheckoutPage(request, response);
                break;

            case "history":
                handleOrderHistory(request, response);
                break;

            case "detail":
                handleOrderDetail(request, response);
                break;

            default:
                handleOrderHistory(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "placeOrder":
                handlePlaceOrder(request, response);
                break;
            default:
                handleOrderHistory(request, response);
                break;
        }
    }

    // =============================================
    // CHECKOUT PAGE
    // =============================================
    private void handleCheckoutPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        User user  = (User) session.getAttribute("user");
        int userId = user.getUserId();

        Cart cart = cartDAO.getCartByUserId(userId);

        if (cart == null || cartDAO.getCartItemCount(cart.getCartId()) == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItems(cart.getCartId());

        // Enrich cart items with product info
        List<java.util.Map<String, Object>> enrichedItems = new ArrayList<>();
        for (CartItem item : cartItems) {
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            Product product = productDAO.getProductById(item.getProductId());
            com.fashionstore.model.ProductVariant variant =
                productDAO.getVariantById(item.getVariantId());
            map.put("cartItem", item);
            map.put("product",  product);
            map.put("variant",  variant);
            map.put("subtotal", product.getPrice() * item.getQuantity());
            enrichedItems.add(map);
        }

        double cartTotal = cartDAO.getCartTotal(cart.getCartId());
        double shipping  = cartTotal >= 999 ? 0 : 99;
        double grandTotal = cartTotal + shipping;

        request.setAttribute("enrichedItems", enrichedItems);
        request.setAttribute("cartTotal",     cartTotal);
        request.setAttribute("shipping",      shipping);
        request.setAttribute("grandTotal",    grandTotal);
        request.setAttribute("user",          user);

        request.getRequestDispatcher("/WEB-INF/views/order/checkout.jsp")
               .forward(request, response);
    }

    // =============================================
    // PLACE ORDER
    // =============================================
    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        User user  = (User) session.getAttribute("user");
        int userId = user.getUserId();

        // Get delivery details from form
        String deliveryName    = request.getParameter("deliveryName");
        String deliveryPhone   = request.getParameter("deliveryPhone");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String deliveryCity    = request.getParameter("deliveryCity");
        String deliveryState   = request.getParameter("deliveryState");
        String deliveryPincode = request.getParameter("deliveryPincode");
        String paymentMethod   = request.getParameter("paymentMethod");

        // Validate
        if (deliveryName == null || deliveryName.trim().isEmpty() ||
            deliveryPhone == null || deliveryPhone.trim().isEmpty() ||
            deliveryAddress == null || deliveryAddress.trim().isEmpty() ||
            deliveryCity == null || deliveryCity.trim().isEmpty() ||
            deliveryState == null || deliveryState.trim().isEmpty() ||
            deliveryPincode == null || deliveryPincode.trim().isEmpty() ||
            paymentMethod == null || paymentMethod.trim().isEmpty()) {

            request.setAttribute("error", "All delivery details are required.");
            handleCheckoutPage(request, response);
            return;
        }

        // Get cart
        Cart cart = cartDAO.getCartByUserId(userId);

        if (cart == null || cartDAO.getCartItemCount(cart.getCartId()) == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItems(cart.getCartId());
        double cartTotal  = cartDAO.getCartTotal(cart.getCartId());
        double shipping   = cartTotal >= 999 ? 0 : 99;
        double grandTotal = cartTotal + shipping;

        // Build Order object
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(grandTotal);
        order.setPaymentMethod(paymentMethod.trim());
        order.setOrderStatus("Placed");
        order.setDeliveryName(deliveryName.trim());
        order.setDeliveryPhone(deliveryPhone.trim());
        order.setDeliveryAddress(deliveryAddress.trim());
        order.setDeliveryCity(deliveryCity.trim());
        order.setDeliveryState(deliveryState.trim());
        order.setDeliveryPincode(deliveryPincode.trim());

        // Place order — get generated order ID
        int orderId = orderDAO.placeOrder(order);

        if (orderId == -1) {
            request.setAttribute("error", "Order placement failed. Please try again.");
            handleCheckoutPage(request, response);
            return;
        }

        // Build order items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            Product product = productDAO.getProductById(cartItem.getProductId());
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setProductId(cartItem.getProductId());
            orderItem.setVariantId(cartItem.getVariantId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(product.getPrice());
            orderItems.add(orderItem);
        }

        // Save order items
        orderDAO.addOrderItems(orderItems);

        // Update stock for each item
        for (CartItem cartItem : cartItems) {
            productDAO.updateStock(cartItem.getVariantId(), cartItem.getQuantity());
        }

        // Clear cart
        cartDAO.clearCart(cart.getCartId());

        // Update cart count in session
        session.setAttribute("cartCount", 0);

        // Redirect to success page
        response.sendRedirect(request.getContextPath()
            + "/orders?action=detail&orderId=" + orderId + "&success=true");
    }

    // =============================================
    // ORDER DETAIL / SUCCESS PAGE
    // =============================================
    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        String success    = request.getParameter("success");

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);

            // Enrich with product info
            List<java.util.Map<String, Object>> enrichedItems = new ArrayList<>();
            for (OrderItem item : orderItems) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                Product product = productDAO.getProductById(item.getProductId());
                com.fashionstore.model.ProductVariant variant =
                    productDAO.getVariantById(item.getVariantId());
                map.put("orderItem", item);
                map.put("product",   product);
                map.put("variant",   variant);
                map.put("subtotal",  item.getPrice() * item.getQuantity());
                enrichedItems.add(map);
            }

            request.setAttribute("order",         order);
            request.setAttribute("enrichedItems", enrichedItems);
            request.setAttribute("isSuccess",     "true".equals(success));

            request.getRequestDispatcher("/WEB-INF/views/order/orderSuccess.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    // =============================================
    // ORDER HISTORY
    // =============================================
    private void handleOrderHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        List<Order> orders = orderDAO.getOrdersByUserId(userId);

        // Enrich with first item info for preview
        List<java.util.Map<String, Object>> enrichedOrders = new ArrayList<>();
        for (Order order : orders) {
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            List<OrderItem> items = orderDAO.getOrderItems(order.getOrderId());
            map.put("order",     order);
            map.put("itemCount", items.size());
            if (!items.isEmpty()) {
                Product firstProduct =
                    productDAO.getProductById(items.get(0).getProductId());
                map.put("firstProduct", firstProduct);
            }
            enrichedOrders.add(map);
        }

        request.setAttribute("enrichedOrders", enrichedOrders);
        request.getRequestDispatcher("/WEB-INF/views/order/orderHistory.jsp")
               .forward(request, response);
    }
}
