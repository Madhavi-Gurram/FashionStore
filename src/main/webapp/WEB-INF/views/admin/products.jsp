<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Admin Panel</title>
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
            <h1 class="admin-page-title">Products</h1>
            <div class="admin-topbar-right">
                <a href="${pageContext.request.contextPath}/admin?action=addProductPage"
                   class="quick-action-btn">
                    ➕ Add New Product
                </a>
            </div>
        </div>

        <%-- ALERTS --%>
        <c:if test="${param.success == 'added'}">
            <div class="admin-alert admin-alert-success">
                ✅ Product added successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="admin-alert admin-alert-success">
                ✅ Product updated successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="admin-alert admin-alert-success">
                ✅ Product deleted successfully!
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="admin-alert admin-alert-error">
                ⚠️ ${error}
            </div>
        </c:if>

        <%-- PRODUCTS TABLE --%>
        <div class="admin-section">
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td>${product.productId}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                                 alt="${product.name}"
                                                 class="admin-product-img"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                        </td>
                                        <td>
                                            <strong>${product.name}</strong>
                                            <div style="font-size:12px;color:var(--text-light);
                                                 margin-top:3px;max-width:200px;overflow:hidden;
                                                 text-overflow:ellipsis;white-space:nowrap;">
                                                ${product.description}
                                            </div>
                                        </td>
                                        <td>
                                            <c:forEach var="cat" items="${categories}">
                                                <c:if test="${cat.categoryId == product.categoryId}">
                                                    ${cat.categoryName}
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            ₹<fmt:formatNumber value="${product.price}"
                                              pattern="#,##0.00"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.active}">
                                                    <span class="badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display:flex;gap:8px;">
                                                <a href="${pageContext.request.contextPath}/admin?action=editProductPage&id=${product.productId}"
                                                   class="btn-edit">
                                                    ✏️ Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin?action=deleteProduct&id=${product.productId}"
                                                   class="btn-delete"
                                                   onclick="return confirm('Delete this product?')">
                                                    🗑️ Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="table-empty">
                                        No products found
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

</body>
</html>