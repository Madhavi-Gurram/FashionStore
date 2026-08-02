package com.fashionstore.controller;

import com.fashionstore.daoimpl.CategoryDAOImpl;
import com.fashionstore.daoimpl.ProductDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private ProductDAOImpl productDAO;
    private CategoryDAOImpl categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =============================================
        // 1. FETCH ALL CATEGORIES
        // =============================================
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // =============================================
        // 2. FETCH FEATURED PRODUCTS (all active)
        // =============================================
        List<Product> featuredProducts = productDAO.getAllProducts();

        // Limit to 8 products for home page display
        if (featuredProducts.size() > 8) {
            featuredProducts = featuredProducts.subList(0, 8);
        }
        request.setAttribute("featuredProducts", featuredProducts);

        // =============================================
        // 3. FETCH PRODUCTS BY CATEGORY FOR SECTIONS
        // =============================================

        // New Arrivals - Tops (category 1)
        List<Product> tops = productDAO.getProductsByCategory(1);
        if (tops.size() > 4) tops = tops.subList(0, 4);
        request.setAttribute("tops", tops);

        // Dresses (category 3)
        List<Product> dresses = productDAO.getProductsByCategory(3);
        if (dresses.size() > 4) dresses = dresses.subList(0, 4);
        request.setAttribute("dresses", dresses);

        // Ethnic Wear (category 4)
        List<Product> ethnicWear = productDAO.getProductsByCategory(4);
        if (ethnicWear.size() > 4) ethnicWear = ethnicWear.subList(0, 4);
        request.setAttribute("ethnicWear", ethnicWear);

        // =============================================
        // 4. CART COUNT FOR NAVBAR BADGE
        // =============================================
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("cartCount") == null) {
            session.setAttribute("cartCount", 0);
        }

        // =============================================
        // 5. FORWARD TO HOME JSP
        // =============================================
        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}