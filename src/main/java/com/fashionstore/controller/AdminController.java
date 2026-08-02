package com.fashionstore.controller;

import com.fashionstore.daoimpl.AdminDAOImpl;
import com.fashionstore.daoimpl.CategoryDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Order;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize       = 1024 * 1024 * 10,  // 10MB
    maxRequestSize    = 1024 * 1024 * 15   // 15MB
)
public class AdminController extends HttpServlet {

    private AdminDAOImpl adminDAO;
    private CategoryDAOImpl categoryDAO;

    @Override
    public void init() {
        adminDAO    = new AdminDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                handleDashboard(request, response);
                break;
            case "products":
                handleProducts(request, response);
                break;
            case "addProductPage":
                handleAddProductPage(request, response);
                break;
            case "editProductPage":
                handleEditProductPage(request, response);
                break;
            case "deleteProduct":
                handleDeleteProduct(request, response);
                break;
            case "orders":
                handleOrders(request, response);
                break;
            case "users":
                handleUsers(request, response);
                break;
            case "logout":
                handleAdminLogout(request, response);
                break;
            default:
                handleDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "addProduct":
                handleAddProduct(request, response);
                break;
            case "editProduct":
                handleEditProduct(request, response);
                break;
            case "updateOrderStatus":
                handleUpdateOrderStatus(request, response);
                break;
            default:
                handleDashboard(request, response);
                break;
        }
    }

    // =============================================
    // CHECK ADMIN SESSION
    // =============================================
    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() +
                "/user?action=loginPage");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    // =============================================
    // IMAGE UPLOAD HELPER
    // =============================================
    private String handleImageUpload(HttpServletRequest request,
                                     String existingImageUrl)
            throws IOException, ServletException {

        Part filePart = request.getPart("productImage");

        // No file uploaded — return existing
        if (filePart == null || filePart.getSize() == 0) {
            return existingImageUrl != null ? existingImageUrl
                                           : "assets/images/placeholder.jpg";
        }

        // Get original filename
        String fileName = Paths.get(
            filePart.getSubmittedFileName()).getFileName().toString();

        if (fileName == null || fileName.trim().isEmpty()) {
            return existingImageUrl != null ? existingImageUrl
                                           : "assets/images/placeholder.jpg";
        }

        // Validate file type
        String extension = fileName.substring(
            fileName.lastIndexOf('.') + 1).toLowerCase();

        if (!extension.equals("jpg") && !extension.equals("jpeg")
                && !extension.equals("png") && !extension.equals("webp")
                && !extension.equals("gif")) {
            return existingImageUrl != null ? existingImageUrl
                                           : "assets/images/placeholder.jpg";
        }

        // Generate unique filename
        String uniqueName = UUID.randomUUID().toString() + "." + extension;

        // Get upload directory path
        String uploadDir = getServletContext().getRealPath("")
            + File.separator + "assets"
            + File.separator + "images"
            + File.separator + "products";

        // Create directory if not exists
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        // Save file
        String filePath = uploadDir + File.separator + uniqueName;
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(filePath),
                       StandardCopyOption.REPLACE_EXISTING);
        }

        return "assets/images/products/" + uniqueName;
    }

    // =============================================
    // DASHBOARD
    // =============================================
 
    private void handleDashboard(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalProducts", adminDAO.getTotalProducts());
        request.setAttribute("totalOrders",   adminDAO.getTotalOrders());
        request.setAttribute("totalUsers",    adminDAO.getTotalUsers());
        request.setAttribute("totalRevenue",  adminDAO.getTotalRevenue()); // ← fixed
        request.setAttribute("recentOrders",  adminDAO.getRecentOrders(5));

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }

    // =============================================
    // PRODUCTS LIST
    // =============================================
    private void handleProducts(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("products",   adminDAO.getAllProductsForAdmin());
        request.setAttribute("categories", categoryDAO.getAllCategories());

        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp")
               .forward(request, response);
    }

    // =============================================
    // ADD PRODUCT PAGE
    // =============================================
    private void handleAddProductPage(HttpServletRequest request,
                                       HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/admin/addProduct.jsp")
               .forward(request, response);
    }

    // =============================================
    // ADD PRODUCT — POST
    // =============================================
    private void handleAddProduct(HttpServletRequest request,
                                   HttpServletResponse response)
            throws ServletException, IOException {

        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr    = request.getParameter("price");
        String categoryStr = request.getParameter("categoryId");
        String activeStr   = request.getParameter("isActive");

        // Validation
        if (name == null || name.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            categoryStr == null || categoryStr.trim().isEmpty()) {

            request.setAttribute("error", "Name, price and category are required.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/admin/addProduct.jsp")
                   .forward(request, response);
            return;
        }

        try {
            // Handle image upload
            String imageUrl = handleImageUpload(request, null);

            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPrice(Double.parseDouble(priceStr.trim()));
            product.setImageUrl(imageUrl);
            product.setCategoryId(Integer.parseInt(categoryStr.trim()));
            product.setActive(activeStr != null && activeStr.equals("true"));

            boolean added = adminDAO.addProduct(product);

            if (added) {
                response.sendRedirect(request.getContextPath() +
                    "/admin?action=products&success=added");
            } else {
                request.setAttribute("error", "Failed to add product. Try again.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/admin/addProduct.jsp")
                       .forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price or category.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/admin/addProduct.jsp")
                   .forward(request, response);
        }
    }

    // =============================================
    // EDIT PRODUCT PAGE
    // =============================================
    private void handleEditProductPage(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                "/admin?action=products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);
            List<Product> products = adminDAO.getAllProductsForAdmin();
            Product product = products.stream()
                .filter(p -> p.getProductId() == productId)
                .findFirst()
                .orElse(null);

            if (product == null) {
                response.sendRedirect(request.getContextPath() +
                    "/admin?action=products");
                return;
            }

            request.setAttribute("product",    product);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/admin/editProduct.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                "/admin?action=products");
        }
    }

    // =============================================
    // EDIT PRODUCT — POST
    // =============================================
    private void handleEditProduct(HttpServletRequest request,
                                    HttpServletResponse response)
            throws ServletException, IOException {

        String idStr       = request.getParameter("productId");
        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr    = request.getParameter("price");
        String existingImg = request.getParameter("existingImageUrl");
        String categoryStr = request.getParameter("categoryId");
        String activeStr   = request.getParameter("isActive");

        try {
            // Handle image upload — keep existing if no new image
            String imageUrl = handleImageUpload(request, existingImg);

            Product product = new Product();
            product.setProductId(Integer.parseInt(idStr));
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPrice(Double.parseDouble(priceStr.trim()));
            product.setImageUrl(imageUrl);
            product.setCategoryId(Integer.parseInt(categoryStr.trim()));
            product.setActive(activeStr != null && activeStr.equals("true"));

            boolean updated = adminDAO.updateProduct(product);

            if (updated) {
                response.sendRedirect(request.getContextPath() +
                    "/admin?action=products&success=updated");
            } else {
                request.setAttribute("error", "Failed to update product.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/admin/editProduct.jsp")
                       .forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data.");
            response.sendRedirect(request.getContextPath() +
                "/admin?action=products");
        }
    }

    // =============================================
    // DELETE PRODUCT
    // =============================================
    private void handleDeleteProduct(HttpServletRequest request,
                                      HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        try {
            int productId = Integer.parseInt(idStr);
            adminDAO.deleteProduct(productId);
            response.sendRedirect(request.getContextPath() +
                "/admin?action=products&success=deleted");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                "/admin?action=products");
        }
    }

    // =============================================
    // ORDERS
    // =============================================
    private void handleOrders(HttpServletRequest request,
                               HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = adminDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp")
               .forward(request, response);
    }

    // =============================================
    // UPDATE ORDER STATUS
    // =============================================
    private void handleUpdateOrderStatus(HttpServletRequest request,
                                          HttpServletResponse response)
            throws IOException {

        String orderIdStr = request.getParameter("orderId");
        String status     = request.getParameter("status");

        System.out.println("Updating order #" + orderIdStr + " → " + status);

        try {
            int orderId = Integer.parseInt(orderIdStr);
            if (status != null && !status.trim().isEmpty()) {
                boolean updated = adminDAO.updateOrderStatus(orderId, status.trim());
                System.out.println("Update result: " + updated);
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid orderId: " + orderIdStr);
        }

        response.sendRedirect(request.getContextPath() +
            "/admin?action=orders&success=updated");
    }

    // =============================================
    // USERS
    // =============================================
    private void handleUsers(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = adminDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
               .forward(request, response);
    }

    // =============================================
    // ADMIN LOGOUT
    // =============================================
    private void handleAdminLogout(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}