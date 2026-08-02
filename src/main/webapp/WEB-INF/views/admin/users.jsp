<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - Admin Panel</title>
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
               class="admin-nav-item">
                👕 Products
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=orders"
               class="admin-nav-item">
                📦 Orders
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=users"
               class="admin-nav-item active">
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
            <h1 class="admin-page-title">Users</h1>
            <div class="admin-topbar-right">
                <span class="admin-welcome">
                    Total: ${users.size()} users
                </span>
            </div>
        </div>

        <%-- USERS TABLE --%>
        <div class="admin-section">
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>User</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Joined</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty users}">
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.userId}</td>
                                        <td>
                                            <div class="user-info">
                                                <div class="user-avatar">👤</div>
                                                <div>
                                                    <div class="user-name">
                                                        ${user.fullName}
                                                    </div>
                                                    <div class="user-email">
                                                        ${user.email}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty user.phone}">
                                                    ${user.phone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:var(--text-light);">
                                                        Not provided
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="max-width:200px;overflow:hidden;
                                                 text-overflow:ellipsis;white-space:nowrap;
                                                 font-size:13px;color:var(--text-light);">
                                                <c:choose>
                                                    <c:when test="${not empty user.address}">
                                                        ${user.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Not provided
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-size:13px;
                                                 color:var(--text-light);">
                                                ${user.createdAt}
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="table-empty">
                                        No users found
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