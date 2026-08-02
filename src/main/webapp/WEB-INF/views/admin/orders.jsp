<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders - Admin Panel</title>
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
               class="admin-nav-item active">
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
            <h1 class="admin-page-title">Orders</h1>
            <div class="admin-topbar-right">
                <span class="admin-welcome">
                    Total: ${orders.size()} orders
                </span>
            </div>
        </div>

        <%-- ALERTS --%>
        <c:if test="${param.success == 'updated'}">
            <div class="admin-alert admin-alert-success">
                ✅ Order status updated successfully!
            </div>
        </c:if>

        <%-- ORDERS TABLE --%>
        <div class="admin-section">
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Phone</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Update</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orders}">
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>
                                            <strong>#${order.orderId}</strong>
                                        </td>
                                        <td>
                                            <div>${order.deliveryName}</div>
                                            <div style="font-size:12px;
                                                 color:var(--text-light);">
                                                ${order.deliveryCity},
                                                ${order.deliveryState}
                                            </div>
                                        </td>
                                        <td>${order.deliveryPhone}</td>
                                        <td>
                                            <strong>
                                                ₹<fmt:formatNumber
                                                  value="${order.totalAmount}"
                                                  pattern="#,##0.00"/>
                                            </strong>
                                        </td>
                                        <td>${order.paymentMethod}</td>
                                        <td>
                                            <div style="font-size:13px;">
                                                ${order.orderDate}
                                            </div>
                                        </td>
                                        <td>
                                            <span class="order-status-badge
                                                status-${order.orderStatus.toLowerCase().replace(' ','-')}">
                                                ${order.orderStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin"
                                                  method="post"
                                                  style="display:flex;gap:8px;align-items:center;">
                                                <input type="hidden"
                                                       name="action"
                                                       value="updateOrderStatus"/>
                                                <input type="hidden"
                                                       name="orderId"
                                                       value="${order.orderId}"/>
                                                <select name="status"
                                                        class="status-select">
                                                    <option value="Placed"
                                                        ${'Placed' == order.orderStatus
                                                            ? 'selected' : ''}>
                                                        Placed
                                                    </option>
                                                    <option value="Processing"
                                                        ${'Processing' == order.orderStatus
                                                            ? 'selected' : ''}>
                                                        Processing
                                                    </option>
                                                    <option value="Shipped"
                                                        ${'Shipped' == order.orderStatus
                                                            ? 'selected' : ''}>
                                                        Shipped
                                                    </option>
                                                    <option value="Delivered"
                                                        ${'Delivered' == order.orderStatus
                                                            ? 'selected' : ''}>
                                                        Delivered
                                                    </option>
                                                    <option value="Cancelled"
                                                        ${'Cancelled' == order.orderStatus
                                                            ? 'selected' : ''}>
                                                        Cancelled
                                                    </option>
                                                </select>
                                                <button type="submit"
                                                        class="btn-edit">
                                                    Update
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="table-empty">
                                        No orders found
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