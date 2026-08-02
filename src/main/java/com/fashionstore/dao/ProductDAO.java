
package com.fashionstore.dao;

import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;
import java.util.List;

public interface ProductDAO {

    // Get all active products
    List<Product> getAllProducts();

    // Get product by ID
    Product getProductById(int productId);

    // Get products by category
    List<Product> getProductsByCategory(int categoryId);

    // Search products by name keyword
    List<Product> searchProducts(String keyword);

    // Filter products by price range
    List<Product> filterByPriceRange(double minPrice, double maxPrice);

    // Filter products by category and price range
    List<Product> filterProducts(int categoryId, double minPrice, double maxPrice);

    // Get all variants of a product
    List<ProductVariant> getVariantsByProductId(int productId);

    // Get specific variant by ID
    ProductVariant getVariantById(int variantId);

    // Check stock availability
    boolean isStockAvailable(int variantId, int quantity);

    // Update stock after order placed
    boolean updateStock(int variantId, int quantity);
}
