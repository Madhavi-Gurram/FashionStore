
package com.fashionstore.dao;

import com.fashionstore.model.Category;
import java.util.List;

public interface CategoryDAO {

    // Get all categories
    List<Category> getAllCategories();

    // Get category by ID
    Category getCategoryById(int categoryId);
    
    List<Category> getSubCategories(int parentId);
    List<Category> getParentCategories();
}
