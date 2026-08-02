package com.fashionstore.controller;

import com.fashionstore.daoimpl.CategoryDAOImpl;
import com.fashionstore.daoimpl.ProductDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
@WebServlet("/products")
public class ProductController extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "list":
                handleProductList(request, response);
                break;

            case "detail":
                handleProductDetail(request, response);
                break;

            default:
                handleProductList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // =============================================
    // PRODUCT LIST — with search, filter, category, sort
    // =============================================
    private void handleProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all categories for sidebar and tabs
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Get parameters
        String search      = request.getParameter("search");
        String categoryStr = request.getParameter("category");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sortBy      = request.getParameter("sortBy");

        List<Product> products = null;

        // ── SEARCH ──────────────────────────────
        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProducts(search.trim());
            request.setAttribute("searchKeyword", search.trim());
        }

        // ── CATEGORY + PRICE FILTER ─────────────
        else if (categoryStr != null && !categoryStr.isEmpty()
                 && minPriceStr != null && !minPriceStr.isEmpty()
                 && maxPriceStr != null && !maxPriceStr.isEmpty()) {

            try {
                int categoryId  = Integer.parseInt(categoryStr);
                double minPrice = Double.parseDouble(minPriceStr);
                double maxPrice = Double.parseDouble(maxPriceStr);
                products = productDAO.filterProducts(categoryId, minPrice, maxPrice);
                request.setAttribute("selectedCategory", categoryId);
                request.setAttribute("minPrice", minPrice);
                request.setAttribute("maxPrice", maxPrice);
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }
        }

        // ── CATEGORY ONLY ────────────────────────
        else if (categoryStr != null && !categoryStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryStr);
                products = productDAO.getProductsByCategory(categoryId);
                request.setAttribute("selectedCategory", categoryId);
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }
        }

        // ── PRICE RANGE ONLY ────────────────────
        else if (minPriceStr != null && !minPriceStr.isEmpty()
                 && maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                double minPrice = Double.parseDouble(minPriceStr);
                double maxPrice = Double.parseDouble(maxPriceStr);
                products = productDAO.filterByPriceRange(minPrice, maxPrice);
                request.setAttribute("minPrice", minPrice);
                request.setAttribute("maxPrice", maxPrice);
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }
        }

        // ── ALL PRODUCTS (default) ───────────────
        else {
            products = productDAO.getAllProducts();
        }

        // ── SORT BY ──────────────────────────────
        if (sortBy != null && !sortBy.isEmpty() && products != null) {
            switch (sortBy) {
                case "price_asc":
                    products.sort((a, b) ->
                        Double.compare(a.getPrice(), b.getPrice()));
                    break;
                case "price_desc":
                    products.sort((a, b) ->
                        Double.compare(b.getPrice(), a.getPrice()));
                    break;
                case "name_asc":
                    products.sort((a, b) ->
                        a.getName().compareTo(b.getName()));
                    break;
                case "name_desc":
                    products.sort((a, b) ->
                        b.getName().compareTo(a.getName()));
                    break;
                default:
                    break;
            }
        }

        request.setAttribute("sortBy", sortBy);
        request.setAttribute("products", products);
        request.setAttribute("totalProducts", products != null ? products.size() : 0);

        request.getRequestDispatcher("/WEB-INF/views/product/productList.jsp")
               .forward(request, response);
    }

    // =============================================
    // PRODUCT DETAIL
    // =============================================
    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            // Get product
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Get variants
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);

            // Get categories
            List<Category> categories = categoryDAO.getAllCategories();

            // Get related products (same category)
            List<Product> relatedProducts = productDAO.getProductsByCategory(
                product.getCategoryId()
            );

            // Remove current product from related list
            relatedProducts.removeIf(p -> p.getProductId() == productId);

            // Limit to 4
            if (relatedProducts.size() > 4) {
                relatedProducts = relatedProducts.subList(0, 4);
            }

            request.setAttribute("product", product);
            request.setAttribute("variants", variants);
            request.setAttribute("categories", categories);
            request.setAttribute("relatedProducts", relatedProducts);

            request.getRequestDispatcher("/WEB-INF/views/product/productDetail.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}

