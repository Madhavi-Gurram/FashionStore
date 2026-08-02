<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Admin Panel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

<div class="admin-layout">

    <%-- SIDEBAR --%>
    <aside class="admin-sidebar">
        <div class="admin-brand">
            Fashion<span>Store</span>
            <div class="admin-brand-sub">Admin Panel</div>
        </div>
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin?action=dashboard"
               class="admin-nav-item">
                📊 Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=products"
               class="admin-nav-item active">
                👕 Products
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=orders"
               class="admin-nav-item">
                📦 Orders
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=users"
               class="admin-nav-item">
                👥 Users
            </a>
            <a href="${pageContext.request.contextPath}/home"
               class="admin-nav-item">
                🏠 View Store
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=logout"
               class="admin-nav-item admin-nav-logout">
                🚪 Logout
            </a>
        </nav>
    </aside>

    <%-- MAIN CONTENT --%>
    <main class="admin-main">

        <%-- TOPBAR --%>
        <div class="admin-topbar">
            <h1 class="admin-page-title">Add New Product</h1>
            <div class="admin-topbar-right">
                <a href="${pageContext.request.contextPath}/admin?action=products"
                   class="btn-admin-cancel">
                    ← Back to Products
                </a>
            </div>
        </div>

        <%-- ERROR --%>
        <c:if test="${not empty error}">
            <div class="admin-alert admin-alert-error">
                ⚠️ ${error}
            </div>
        </c:if>

        <%-- ADD PRODUCT FORM --%>
        <div class="admin-section">
            <div class="admin-form-card">

                <form action="${pageContext.request.contextPath}/admin"
      				method="post"
      				enctype="multipart/form-data"
     				class="admin-form"
      				onsubmit="return validateForm()">

                    <input type="hidden" name="action" value="addProduct"/>

                    <%-- NAME & PRICE --%>
                    <div class="admin-form-row">
                        <div class="form-group">
                            <label>Product Name *</label>
                            <input type="text"
                                   id="name"
                                   name="name"
                                   placeholder="Enter product name"
                                   required/>
                            <span class="field-error" id="nameError"></span>
                        </div>
                        <div class="form-group">
                            <label>Price (₹) *</label>
                            <input type="number"
                                   id="price"
                                   name="price"
                                   placeholder="Enter price"
                                   min="0"
                                   step="0.01"
                                   required/>
                            <span class="field-error" id="priceError"></span>
                        </div>
                    </div>

                    <%-- CATEGORY & STATUS --%>
                    <div class="admin-form-row">
                        <div class="form-group">
                            <label>Category *</label>
                            <select id="categoryId" name="categoryId" required>
                                <option value="">-- Select Category --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                            <span class="field-error" id="categoryError"></span>
                        </div>
                        <div class="form-group">
                            <label>Status *</label>
                            <select id="isActive" name="isActive">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                    </div>

                    <%-- IMAGE URL --%>
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="text"
                               name="imageUrl"
                               placeholder="e.g. assets/images/product.jpg"/>
                        <small style="color:var(--text-light);font-size:12px;">
                            Leave empty to use default placeholder image
                        </small>
                    </div>

                    <%-- DESCRIPTION --%>
                    <div class="form-group">
                        <label>Description *</label>
                        <textarea id="description"
                                  name="description"
                                  placeholder="Enter product description"
                                  rows="4"
                                  required></textarea>
                        <span class="field-error" id="descError"></span>
                    </div>

                    <%-- FORM ACTIONS --%>
                    <div class="admin-form-actions">
                        <button type="submit" class="btn-admin-save">
                            ➕ Add Product
                        </button>
                        <a href="${pageContext.request.contextPath}/admin?action=products"
                           class="btn-admin-cancel">
                            Cancel
                        </a>
                    </div>

                </form>
            </div>
        </div>

    </main>
</div>

<script>
    function showError(fieldId, errorId, message) {
        const field = document.getElementById(fieldId);
        if (field) field.style.borderColor = '#EF4444';
        document.getElementById(errorId).textContent = message;
    }

    function clearError(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        if (field) field.style.borderColor = '';
        document.getElementById(errorId).textContent = '';
    }

    function validateForm() {
        let isValid = true;

        clearError('name',        'nameError');
        clearError('price',       'priceError');
        clearError('categoryId',  'categoryError');
        clearError('description', 'descError');

        // Name
        const name = document.getElementById('name').value.trim();
        if (name === '') {
            showError('name', 'nameError', '⚠️ Product name is required.');
            isValid = false;
        } else if (name.length < 3) {
            showError('name', 'nameError', '⚠️ Name must be at least 3 characters.');
            isValid = false;
        }

        // Price
        const price = document.getElementById('price').value;
        if (price === '' || price <= 0) {
            showError('price', 'priceError', '⚠️ Enter a valid price.');
            isValid = false;
        }

        // Category
        const category = document.getElementById('categoryId').value;
        if (category === '') {
            showError('categoryId', 'categoryError', '⚠️ Please select a category.');
            isValid = false;
        }

        // Description
        const desc = document.getElementById('description').value.trim();
        if (desc === '') {
            showError('description', 'descError', '⚠️ Description is required.');
            isValid = false;
        } else if (desc.length < 10) {
            showError('description', 'descError',
                      '⚠️ Description must be at least 10 characters.');
            isValid = false;
        }

        return isValid;
    }
</script>

</body>
</html>