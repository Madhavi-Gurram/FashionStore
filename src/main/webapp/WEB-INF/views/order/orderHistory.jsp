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
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <div class="page-header">
            <h2 class="page-title">My Orders</h2>
            <p class="page-subtitle">Track and manage your orders</p>
        </div>

        <c:choose>
            <c:when test="${not empty enrichedOrders}">

                <div class="orders-list">
                    <c:forEach var="entry" items="${enrichedOrders}">

                        <div class="order-card">

                            <%-- ORDER CARD HEADER --%>
                            <div class="order-card-header">
                                <div class="order-card-left">
                                    <div class="order-card-id">
                                        Order #${entry.order.orderId}
                                    </div>
                                    <div class="order-card-date">
                                        ${entry.order.orderDate}
                                    </div>
                                </div>
                                <div class="order-card-right">
                                    <div class="order-status-badge
                                        status-${entry.order.orderStatus.toLowerCase().replace(' ','-')}">
                                        ${entry.order.orderStatus}
                                    </div>
                                </div>
                            </div>

                            <%-- ORDER CARD BODY --%>
                            <div class="order-card-body">

                                <%-- FIRST PRODUCT PREVIEW --%>
                                <c:if test="${not empty entry.firstProduct}">
                                    <div class="order-preview">
                                        <img src="${pageContext.request.contextPath}/${entry.firstProduct.imageUrl}"
                                             alt="${entry.firstProduct.name}"
                                             class="order-preview-img"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                        <div class="order-preview-info">
                                            <div class="order-preview-name">
                                                ${entry.firstProduct.name}
                                            </div>
                                            <div class="order-preview-count">
                                                <c:choose>
                                                    <c:when test="${entry.itemCount > 1}">
                                                        + ${entry.itemCount - 1} more item(s)
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${entry.itemCount} item
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <%-- ORDER AMOUNT AND ACTION --%>
                                <div class="order-card-footer">
                                    <div class="order-card-total">
                                        <span class="order-total-label">Total:</span>
                                        <span class="order-total-amount">
                                            ₹<fmt:formatNumber
                                              value="${entry.order.totalAmount}"
                                              pattern="#,##0.00"/>
                                        </span>
                                    </div>
                                    <div class="order-card-meta">
                                        <span class="order-payment-method">
                                            💳 ${entry.order.paymentMethod}
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=${entry.order.orderId}"
                                       class="btn-view-detail">
                                        View Details →
                                    </a>
                                </div>

                            </div>

                        </div>

                    </c:forEach>
                </div>

            </c:when>
            <c:otherwise>

                <%-- EMPTY ORDERS --%>
                <div class="empty-orders">
                    <div class="empty-orders-icon">📋</div>
                    <h3>No orders yet!</h3>
                    <p>You haven't placed any orders yet.
                       Start shopping to see your orders here.</p>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn-primary">
                        Start Shopping →
                    </a>
                </div>

            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>