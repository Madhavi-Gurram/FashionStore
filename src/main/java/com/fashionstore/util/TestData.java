
package com.fashionstore.util;

import com.fashionstore.daoimpl.CategoryDAOImpl;
import com.fashionstore.daoimpl.ProductDAOImpl;
import com.fashionstore.daoimpl.UserDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;
import com.fashionstore.model.User;

import java.util.List;

public class TestData {

    public static void main(String[] args) {

        CategoryDAOImpl categoryDAO = new CategoryDAOImpl();
        ProductDAOImpl productDAO = new ProductDAOImpl();
        UserDAOImpl userDAO = new UserDAOImpl();

        // =============================================
        // 1. TEST ALL CATEGORIES
        // =============================================
        System.out.println("========== CATEGORIES ==========");
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category c : categories) {
            System.out.println(c.getCategoryId() + " | " +
                               c.getCategoryName() + " | " +
                               c.getDescription());
        }

        // =============================================
        // 2. TEST ALL PRODUCTS
        // =============================================
        System.out.println("\n========== PRODUCTS ==========");
        List<Product> products = productDAO.getAllProducts();
        for (Product p : products) {
            System.out.println(p.getProductId() + " | " +
                               p.getName() + " | " +
                               p.getPrice() + " | " +
                               p.getCategoryId());
        }

        // =============================================
        // 3. TEST PRODUCTS BY CATEGORY
        // =============================================
        System.out.println("\n========== TOPS (Category 1) ==========");
        List<Product> tops = productDAO.getProductsByCategory(1);
        for (Product p : tops) {
            System.out.println(p.getName() + " | Rs." + p.getPrice());
        }

        // =============================================
        // 4. TEST SEARCH PRODUCTS
        // =============================================
        System.out.println("\n========== SEARCH: 'kurti' ==========");
        List<Product> searched = productDAO.searchProducts("kurti");
        for (Product p : searched) {
            System.out.println(p.getName() + " | Rs." + p.getPrice());
        }

        // =============================================
        // 5. TEST FILTER BY PRICE RANGE
        // =============================================
        System.out.println("\n========== PRICE RANGE: 500 - 1000 ==========");
        List<Product> filtered = productDAO.filterByPriceRange(500, 1000);
        for (Product p : filtered) {
            System.out.println(p.getName() + " | Rs." + p.getPrice());
        }

        // =============================================
        // 6. TEST VARIANTS OF PRODUCT
        // =============================================
        System.out.println("\n========== VARIANTS OF PRODUCT 1 ==========");
        List<ProductVariant> variants = productDAO.getVariantsByProductId(1);
        for (ProductVariant pv : variants) {
            System.out.println("Size: " + pv.getSize() + " | Stock: " + pv.getStock());
        }

        // =============================================
        // 7. TEST USER BY EMAIL
        // =============================================
        System.out.println("\n========== USER BY EMAIL ==========");
        User user = userDAO.getUserByEmail("madhavi@gmail.com");
        if (user != null) {
            System.out.println("Found: " + user.getFullName() + " | " + user.getEmail());
        } else {
            System.out.println("User not found!");
        }

        // =============================================
        // 8. TEST EMAIL EXISTS
        // =============================================
        System.out.println("\n========== EMAIL EXISTS CHECK ==========");
        boolean exists = userDAO.isEmailExists("madhavi@gmail.com");
        System.out.println("madhavi@gmail.com exists: " + exists);

        boolean notExists = userDAO.isEmailExists("unknown@gmail.com");
        System.out.println("unknown@gmail.com exists: " + notExists);
    }
}
