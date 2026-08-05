package com.fashionstore.controller;

import com.fashionstore.daoimpl.CategoryDAOImpl;
import com.fashionstore.daoimpl.WishlistDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistController extends HttpServlet {

    private WishlistDAOImpl wishlistDAO;
    private CategoryDAOImpl categoryDAO;

    @Override
    public void init() {
        wishlistDAO = new WishlistDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() +
                "/user?action=loginPage");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "view";

        switch (action) {
            case "view":
                handleViewWishlist(request, response);
                break;
            case "add":
                handleAddToWishlist(request, response);
                break;
            case "remove":
                handleRemoveFromWishlist(request, response);
                break;
            default:
                handleViewWishlist(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // =============================================
    // VIEW WISHLIST
    // =============================================
    private void handleViewWishlist(HttpServletRequest request,
                                     HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        List<Product> wishlistProducts =
            wishlistDAO.getWishlistProducts(userId);
        int wishlistCount =
            wishlistDAO.getWishlistCount(userId);
        List<Category> categories =
            categoryDAO.getAllCategories();

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.setAttribute("wishlistCount",    wishlistCount);
        request.setAttribute("categories",       categories);

        // Update session count
        session.setAttribute("wishlistCount", wishlistCount);

        request.getRequestDispatcher(
            "/WEB-INF/views/wishlist/wishlist.jsp")
            .forward(request, response);
    }

    // =============================================
    // ADD TO WISHLIST
    // =============================================
    private void handleAddToWishlist(HttpServletRequest request,
                                      HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);

            // Check if already in wishlist
            if (wishlistDAO.isInWishlist(userId, productId)) {
                // Already exists — redirect back to product
                response.sendRedirect(request.getContextPath() +
                    "/products?action=detail&id=" + productId +
                    "&wishlist=exists");
                return;
            }

            boolean added = wishlistDAO.addToWishlist(userId, productId);

            if (added) {
                // Update session count
                int count = wishlistDAO.getWishlistCount(userId);
                session.setAttribute("wishlistCount", count);

                response.sendRedirect(request.getContextPath() +
                    "/products?action=detail&id=" + productId +
                    "&wishlist=added");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/products?action=detail&id=" + productId +
                    "&wishlist=error");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    // =============================================
    // REMOVE FROM WISHLIST
    // =============================================
    private void handleRemoveFromWishlist(HttpServletRequest request,
                                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        String productIdStr = request.getParameter("productId");
        String fromPage     = request.getParameter("from");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            wishlistDAO.removeFromWishlist(userId, productId);

            // Update session count
            int count = wishlistDAO.getWishlistCount(userId);
            session.setAttribute("wishlistCount", count);

            // If removed from product detail page
            if ("product".equals(fromPage)) {
                response.sendRedirect(request.getContextPath() +
                    "/products?action=detail&id=" + productId +
                    "&wishlist=removed");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/wishlist?success=removed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}