<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
    <style>
        .orders-wrapper {
            max-width: 860px;
            margin: 0 auto;
            padding: 32px 24px 60px;
        }
        .order-card {
            background: var(--white);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(14,116,144,0.10);
            border: 1.5px solid var(--border);
            overflow: hidden;
            margin-bottom: 20px;
            transition: box-shadow 0.2s;
        }
        .order-card:hover {
            box-shadow: 0 6px 24px rgba(14,116,144,0.15);
        }
        .order-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            background: linear-gradient(135deg, #EFF9FB, #E0F2FE);
            border-bottom: 1.5px solid var(--border);
        }
        .order-card-id {
            font-size: 15px;
            font-weight: 700;
            color: var(--navy);
        }
        .order-card-date {
            font-size: 12px;
            color: var(--text-light);
            margin-top: 2px;
        }
        .order-status-badge {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-placed      { background: #DBEAFE; color: #1D4ED8; }
        .status-processing  { background: #FEF3C7; color: #92400E; }
        .status-shipped     { background: #E0E7FF; color: #4338CA; }
        .status-delivered   { background: #D1FAE5; color: #065F46; }
        .status-cancelled   { background: #FEE2E2; color: #991B1B; }

        .order-card-body {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 20px;
        }
        .order-first-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 10px;
            background: var(--primary-bg);
            flex-shrink: 0;
            border: 1px solid var(--border);
        }
        .order-card-info {
            flex: 1;
            min-width: 0;
        }
        .order-card-items {
            font-size: 14px;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .order-card-amount {
            font-size: 18px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 3px;
        }
        .order-card-meta {
            font-size: 12px;
            color: var(--text-light);
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        .order-card-tracking {
            font-family: monospace;
            color: var(--primary);
            font-weight: 600;
            font-size: 12px;
        }
        .order-card-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex-shrink: 0;
        }
        .btn-view-order {
            padding: 9px 20px;
            background: var(--navy);
            color: var(--white);
            border-radius: var(--radius-lg);
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s;
            text-align: center;
            display: block;
            white-space: nowrap;
        }
        .btn-view-order:hover { background: var(--primary); }
        .btn-track-order {
            padding: 9px 20px;
            background: var(--primary-bg);
            color: var(--primary);
            border: 1.5px solid var(--primary);
            border-radius: var(--radius-lg);
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            text-align: center;
            display: block;
            white-space: nowrap;
        }
        .btn-track-order:hover {
            background: var(--primary);
            color: var(--white);
        }
        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            background: var(--white);
            border-radius: 14px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .empty-orders-icon { font-size: 56px; margin-bottom: 16px; }
        .empty-orders h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 8px;
        }
        .empty-orders p {
            font-size: 14px;
            color: var(--text-light);
            margin-bottom: 24px;
        }
        .btn-start-shopping {
            display: inline-block;
            padding: 12px 28px;
            background: var(--navy);
            color: var(--white);
            border-radius: var(--radius-lg);
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s;
        }
        .btn-start-shopping:hover { background: var(--primary); }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="orders-wrapper">

        <%-- PAGE HEADER --%>
        <div class="page-header">
            <h2 class="page-title">My Orders</h2>
            <p class="page-subtitle">Track and manage your orders</p>
        </div>

        <%-- ALERTS --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <%-- ORDERS LIST --%>
        <c:choose>
            <c:when test="${not empty enrichedOrders}">
                <div class="orders-list">
                    <c:forEach var="entry" items="${enrichedOrders}">

                        <div class="order-card">

                            <%-- ORDER HEADER --%>
                            <div class="order-card-header">
                                <div>
                                    <div class="order-card-id">
                                        Order #${entry.order.orderId}
                                    </div>
                                    <div class="order-card-date">
                                        🗓️ ${entry.order.orderDate}
                                    </div>
                                </div>

                                <%-- STATUS BADGE --%>
                                <c:choose>
                                    <c:when test="${entry.order.orderStatus == 'Placed'}">
                                        <span class="order-status-badge status-placed">
                                            📋 Placed
                                        </span>
                                    </c:when>
                                    <c:when test="${entry.order.orderStatus == 'Processing'}">
                                        <span class="order-status-badge status-processing">
                                            ⚙️ Processing
                                        </span>
                                    </c:when>
                                    <c:when test="${entry.order.orderStatus == 'Shipped'}">
                                        <span class="order-status-badge status-shipped">
                                            🚚 Shipped
                                        </span>
                                    </c:when>
                                    <c:when test="${entry.order.orderStatus == 'Delivered'}">
                                        <span class="order-status-badge status-delivered">
                                            ✅ Delivered
                                        </span>
                                    </c:when>
                                    <c:when test="${entry.order.orderStatus == 'Cancelled'}">
                                        <span class="order-status-badge status-cancelled">
                                            ❌ Cancelled
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="order-status-badge status-placed">
                                            ${entry.order.orderStatus}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- ORDER BODY --%>
                            <div class="order-card-body">

                                <%-- PRODUCT IMAGE --%>
                                <c:if test="${not empty entry.firstProduct}">
                                    <img src="${pageContext.request.contextPath}/${entry.firstProduct.imageUrl}"
                                         alt="${entry.firstProduct.name}"
                                         class="order-first-img"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                </c:if>

                                <%-- ORDER INFO --%>
                                <div class="order-card-info">
                                    <div class="order-card-items">
                                        <c:if test="${not empty entry.firstProduct}">
                                            ${entry.firstProduct.name}
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${entry.itemCount > 1}">
                                                + ${entry.itemCount - 1} more item(s)
                                            </c:when>
                                            <c:otherwise>
                                                · 1 item
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="order-card-amount">
                                        ₹<fmt:formatNumber
                                          value="${entry.order.totalAmount}"
                                          pattern="#,##0.00"/>
                                    </div>
                                    <div class="order-card-meta">
                                        <span>💳 ${entry.order.paymentMethod}</span>
                                        <c:if test="${not empty entry.order.trackingNumber}">
                                            <span>·</span>
                                            <span class="order-card-tracking">
                                                🔖 ${entry.order.trackingNumber}
                                            </span>
                                        </c:if>
                                    </div>
                                </div>

                                <%-- ACTION BUTTONS --%>
                                <div class="order-card-actions">
                                    <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=${entry.order.orderId}"
                                       class="btn-view-order">
                                        View Details →
                                    </a>
                                    <c:if test="${entry.order.orderStatus != 'Cancelled'}">
                                        <a href="${pageContext.request.contextPath}/orders?action=track&orderId=${entry.order.orderId}"
                                           class="btn-track-order">
                                            📍 Track Order
                                        </a>
                                    </c:if>
                                </div>

                            </div>
                        </div>

                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <div class="empty-orders">
                    <div class="empty-orders-icon">📦</div>
                    <h3>No orders yet</h3>
                    <p>You haven't placed any orders yet. Start shopping!</p>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn-start-shopping">Start Shopping →</a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>