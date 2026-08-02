<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - FashionStore</title>
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
            <a href="${pageContext.request.contextPath}/admin"
               class="admin-nav-item active">
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
            <h1 class="admin-page-title">Dashboard</h1>
            <div class="admin-topbar-right">
                <span class="admin-welcome">
                    👤 Welcome, ${sessionScope.user.fullName}!
                </span>
            </div>
        </div>

        <%-- STAT CARDS --%>
        <div class="admin-stats-grid">

            <div class="stat-card stat-navy">
                <div class="stat-card-icon">👕</div>
                <div>
                    <div class="stat-card-value">${totalProducts}</div>
                    <div class="stat-card-label">Total Products</div>
                </div>
            </div>

            <div class="stat-card stat-teal">
                <div class="stat-card-icon">📦</div>
                <div>
                    <div class="stat-card-value">${totalOrders}</div>
                    <div class="stat-card-label">Total Orders</div>
                </div>
            </div>

            <div class="stat-card stat-cyan">
                <div class="stat-card-icon">👥</div>
                <div>
                    <div class="stat-card-value">${totalUsers}</div>
                    <div class="stat-card-label">Total Users</div>
                </div>
            </div>

            <div class="stat-card stat-green">
                <div class="stat-card-icon">💰</div>
                <div>
                    <div class="stat-card-value">
                        ₹<fmt:formatNumber value="${totalRevenue}"
                          pattern="#,##0"/>
                    </div>
                    <div class="stat-card-label">Total Revenue</div>
                </div>
            </div>

        </div>

        <%-- RECENT ORDERS --%>
        <div class="admin-section">
            <div class="admin-section-header">
                <div class="admin-section-title">📋 Recent Orders</div>
                <a href="${pageContext.request.contextPath}/admin?action=orders"
                   class="admin-view-all">View All →</a>
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentOrders}">
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr>
                                        <td><strong>#${order.orderId}</strong></td>
                                        <td>${order.deliveryName}</td>
                                        <td>
                                            <strong>
                                                ₹<fmt:formatNumber
                                                  value="${order.totalAmount}"
                                                  pattern="#,##0.00"/>
                                            </strong>
                                        </td>
                                        <td>${order.paymentMethod}</td>
                                        <td>
                                            <span class="order-status-badge
                                                status-${order.orderStatus.toLowerCase().replace(' ','-')}">
                                                ${order.orderStatus}
                                            </span>
                                        </td>
                                        <td style="font-size:13px;
                                                   color:var(--text-light);">
                                            ${order.orderDate}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="table-empty">
                                        No orders yet
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- QUICK ACTIONS --%>
        <div class="admin-section">
            <div class="admin-section-title">⚡ Quick Actions</div>

            <div style="display:grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 16px;
                        margin-top: 16px;">

                <a href="${pageContext.request.contextPath}/admin?action=addProductPage"
                   style="display:flex; align-items:center; gap:14px;
                          background:var(--white); padding:20px;
                          border-radius:12px; text-decoration:none;
                          border:1.5px solid var(--border);
                          transition: all 0.2s;
                          box-shadow: 0 1px 3px rgba(14,116,144,0.08);"
                   onmouseover="this.style.borderColor='var(--primary)';
                                this.style.transform='translateY(-3px)';
                                this.style.boxShadow='0 8px 24px rgba(14,116,144,0.16)'"
                   onmouseout="this.style.borderColor='var(--border)';
                               this.style.transform='translateY(0)';
                               this.style.boxShadow='0 1px 3px rgba(14,116,144,0.08)'">
                    <div style="font-size:28px;">➕</div>
                    <div>
                        <div style="font-size:14px; font-weight:700;
                                    color:#0F2447; margin-bottom:3px;">
                            Add New Product
                        </div>
                        <div style="font-size:12px; color:#64748B;">
                            Add a new product to store
                        </div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin?action=products"
                   style="display:flex; align-items:center; gap:14px;
                          background:var(--white); padding:20px;
                          border-radius:12px; text-decoration:none;
                          border:1.5px solid var(--border);
                          transition: all 0.2s;
                          box-shadow: 0 1px 3px rgba(14,116,144,0.08);"
                   onmouseover="this.style.borderColor='var(--primary)';
                                this.style.transform='translateY(-3px)';
                                this.style.boxShadow='0 8px 24px rgba(14,116,144,0.16)'"
                   onmouseout="this.style.borderColor='var(--border)';
                               this.style.transform='translateY(0)';
                               this.style.boxShadow='0 1px 3px rgba(14,116,144,0.08)'">
                    <div style="font-size:28px;">👕</div>
                    <div>
                        <div style="font-size:14px; font-weight:700;
                                    color:#0F2447; margin-bottom:3px;">
                            Manage Products
                        </div>
                        <div style="font-size:12px; color:#64748B;">
                            Edit or delete products
                        </div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin?action=orders"
                   style="display:flex; align-items:center; gap:14px;
                          background:var(--white); padding:20px;
                          border-radius:12px; text-decoration:none;
                          border:1.5px solid var(--border);
                          transition: all 0.2s;
                          box-shadow: 0 1px 3px rgba(14,116,144,0.08);"
                   onmouseover="this.style.borderColor='var(--primary)';
                                this.style.transform='translateY(-3px)';
                                this.style.boxShadow='0 8px 24px rgba(14,116,144,0.16)'"
                   onmouseout="this.style.borderColor='var(--border)';
                               this.style.transform='translateY(0)';
                               this.style.boxShadow='0 1px 3px rgba(14,116,144,0.08)'">
                    <div style="font-size:28px;">📦</div>
                    <div>
                        <div style="font-size:14px; font-weight:700;
                                    color:#0F2447; margin-bottom:3px;">
                            Manage Orders
                        </div>
                        <div style="font-size:12px; color:#64748B;">
                            Update order status
                        </div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin?action=users"
                   style="display:flex; align-items:center; gap:14px;
                          background:var(--white); padding:20px;
                          border-radius:12px; text-decoration:none;
                          border:1.5px solid var(--border);
                          transition: all 0.2s;
                          box-shadow: 0 1px 3px rgba(14,116,144,0.08);"
                   onmouseover="this.style.borderColor='var(--primary)';
                                this.style.transform='translateY(-3px)';
                                this.style.boxShadow='0 8px 24px rgba(14,116,144,0.16)'"
                   onmouseout="this.style.borderColor='var(--border)';
                               this.style.transform='translateY(0)';
                               this.style.boxShadow='0 1px 3px rgba(14,116,144,0.08)'">
                    <div style="font-size:28px;">👥</div>
                    <div>
                        <div style="font-size:14px; font-weight:700;
                                    color:#0F2447; margin-bottom:3px;">
                            View Users
                        </div>
                        <div style="font-size:12px; color:#64748B;">
                            See all registered users
                        </div>
                    </div>
                </a>

            </div>
        </div>

    </main>
</div>

</body>
</html>