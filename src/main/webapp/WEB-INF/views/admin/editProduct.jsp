<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Admin Panel</title>
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
            <h1 class="admin-page-title">Edit Product</h1>
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

        <%-- EDIT PRODUCT FORM --%>
        <div class="admin-section">
            <div class="admin-form-card">

                <form action="${pageContext.request.contextPath}/admin"
                      method="post"
                      enctype="multipart/form-data"
                      class="admin-form"
                      onsubmit="return validateForm()">

                    <%-- HIDDEN FIELDS --%>
                    <input type="hidden" name="action" value="editProduct"/>
                    <input type="hidden" name="productId"
                           value="${product.productId}"/>
                    <input type="hidden" name="existingImageUrl"
                           value="${product.imageUrl}"/>

                    <%-- NAME & PRICE --%>
                    <div class="admin-form-row">
                        <div class="form-group">
                            <label>Product Name *</label>
                            <input type="text"
                                   id="name"
                                   name="name"
                                   value="${product.name}"
                                   placeholder="Enter product name"
                                   required/>
                            <span class="field-error" id="nameError"></span>
                        </div>
                        <div class="form-group">
                            <label>Price (₹) *</label>
                            <input type="number"
                                   id="price"
                                   name="price"
                                   value="${product.price}"
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
                                    <option value="${cat.categoryId}"
                                        ${cat.categoryId == product.categoryId
                                            ? 'selected' : ''}>
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                            <span class="field-error" id="categoryError"></span>
                        </div>
                        <div class="form-group">
                            <label>Status *</label>
                            <select id="isActive" name="isActive">
                                <option value="true"
                                    ${product.active ? 'selected' : ''}>
                                    Active
                                </option>
                                <option value="false"
                                    ${!product.active ? 'selected' : ''}>
                                    Inactive
                                </option>
                            </select>
                        </div>
                    </div>

                    <%-- CURRENT IMAGE PREVIEW --%>
                    <div class="form-group">
                        <label>Current Image</label>
                        <c:choose>
                            <c:when test="${not empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                     alt="Current Image"
                                     id="currentImgPreview"
                                     style="width:120px;height:120px;
                                            object-fit:cover;
                                            border-radius:var(--radius-sm);
                                            border:2px solid var(--border);
                                            margin-bottom:8px;
                                            display:block;"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                            </c:when>
                            <c:otherwise>
                                <div style="width:120px;height:120px;
                                     background:var(--primary-bg);
                                     border-radius:var(--radius-sm);
                                     border:2px dashed var(--border);
                                     display:flex;align-items:center;
                                     justify-content:center;
                                     font-size:32px;margin-bottom:8px;">
                                    🖼️
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- UPLOAD NEW IMAGE --%>
                    <div class="form-group">
                        <label>Upload New Image (optional)</label>
                        <input type="file"
                               name="productImage"
                               id="productImage"
                               accept="image/*"
                               onchange="previewImage(this)"
                               style="padding:8px;
                                      border:1.5px solid var(--border);
                                      border-radius:var(--radius-sm);
                                      width:100%;
                                      box-sizing:border-box;
                                      font-family:'Poppins',sans-serif;
                                      font-size:13px;"/>
                        <small style="color:var(--text-light);font-size:12px;
                               margin-top:4px;display:block;">
                            Leave empty to keep current image.
                            Supported: JPG, PNG, WEBP, GIF (max 10MB)
                        </small>

                        <%-- NEW IMAGE PREVIEW --%>
                        <img id="newImgPreview"
                             src=""
                             alt="New Image Preview"
                             style="display:none;width:120px;height:120px;
                                    object-fit:cover;margin-top:10px;
                                    border-radius:var(--radius-sm);
                                    border:2px solid var(--primary);"/>
                    </div>

                    <%-- DESCRIPTION --%>
                    <div class="form-group">
                        <label>Description *</label>
                        <textarea id="description"
                                  name="description"
                                  placeholder="Enter product description"
                                  rows="4"
                                  required>${product.description}</textarea>
                        <span class="field-error" id="descError"></span>
                    </div>

                    <%-- PRODUCT INFO --%>
                    <div style="background:var(--primary-bg);
                         padding:14px 18px;
                         border-radius:var(--radius-sm);
                         font-size:13px;
                         color:var(--text-light);
                         border:1px solid var(--border);">
                        <strong style="color:var(--navy);">
                            Product ID:
                        </strong> #${product.productId}
                        &nbsp;|&nbsp;
                        <strong style="color:var(--navy);">
                            Created:
                        </strong> ${product.createdAt}
                    </div>

                    <%-- FORM ACTIONS --%>
                    <div class="admin-form-actions">
                        <button type="submit" class="btn-admin-save">
                            💾 Save Changes
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
    // =============================================
    // PREVIEW NEW IMAGE BEFORE UPLOAD
    // =============================================
    function previewImage(input) {
        const preview = document.getElementById('newImgPreview');
        const current = document.getElementById('currentImgPreview');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                if (current) current.style.opacity = '0.4';
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.style.display = 'none';
            if (current) current.style.opacity = '1';
        }
    }

    // =============================================
    // FORM VALIDATION
    // =============================================
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
            showError('name', 'nameError',
                      '⚠️ Name must be at least 3 characters.');
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
            showError('categoryId', 'categoryError',
                      '⚠️ Please select a category.');
            isValid = false;
        }

        // Description
        const desc = document.getElementById('description').value.trim();
        if (desc === '') {
            showError('description', 'descError',
                      '⚠️ Description is required.');
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