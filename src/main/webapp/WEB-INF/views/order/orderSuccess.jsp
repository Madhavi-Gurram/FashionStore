<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <%-- SUCCESS BANNER --%>
        <c:if test="${isSuccess}">
            <div class="order-success-banner">
                <div class="success-icon">✅</div>
                <h2>Order Placed Successfully!</h2>
                <p>Thank you for shopping with FashionStore.
                   Your order has been confirmed.</p>
            </div>
        </c:if>

        <%-- ORDER DETAIL CARD --%>
        <div class="order-detail-card">

            <%-- ORDER HEADER --%>
            <div class="order-detail-header">
                <div>
                    <div class="order-detail-id">
                        Order #${order.orderId}
                    </div>
                    <div class="order-detail-date">
                        Placed on: ${order.orderDate}
                    </div>
                </div>
                <div class="order-status-badge status-${order.orderStatus.toLowerCase().replace(' ','-')}">
                    ${order.orderStatus}
                </div>
            </div>

            <%-- ORDER ITEMS --%>
            <div class="order-items-section">
                <h4 class="order-section-title">Items Ordered</h4>

                <c:forEach var="entry" items="${enrichedItems}">
                    <div class="order-item-row">
                        <img src="${pageContext.request.contextPath}/${entry.product.imageUrl}"
                             alt="${entry.product.name}"
                             class="order-item-img"
                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                        <div class="order-item-info">
                            <div class="order-item-name">${entry.product.name}</div>
                            <div class="order-item-meta">
                                Size: <strong>${entry.variant.size}</strong> ×
                                ${entry.orderItem.quantity}
                            </div>
                            <div class="order-item-price">
                                ₹<fmt:formatNumber value="${entry.product.price}"
                                  pattern="#,##0.00"/> per item
                            </div>
                        </div>
                        <div class="order-item-subtotal">
                            ₹<fmt:formatNumber value="${entry.subtotal}"
                              pattern="#,##0.00"/>
                        </div>
                    </div>
                </c:forEach>

            </div>

            <%-- ORDER INFO GRID --%>
            <div class="order-info-grid">

                <%-- DELIVERY INFO --%>
                <div class="order-info-box">
                    <h4 class="order-section-title">📦 Delivery Address</h4>
                    <p><strong>${order.deliveryName}</strong></p>
                    <p>${order.deliveryAddress}</p>
                    <p>${order.deliveryCity}, ${order.deliveryState}</p>
                    <p>Pincode: ${order.deliveryPincode}</p>
                    <p>📞 ${order.deliveryPhone}</p>
                </div>

                <%-- PAYMENT INFO --%>
                <div class="order-info-box">
                    <h4 class="order-section-title">💳 Payment Details</h4>
                    <p>Method: <strong>${order.paymentMethod}</strong></p>
                    <p>Status:
                        <span class="payment-status-paid">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'Cash on Delivery'}">
                                    Pending (COD)
                                </c:when>
                                <c:otherwise>
                                    Paid
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </p>
                    <div class="order-total-summary">
                        <div class="summary-row">
                            <span>Total Amount</span>
                            <span>₹<fmt:formatNumber value="${order.totalAmount}"
                                  pattern="#,##0.00"/></span>
                        </div>
                    </div>
                </div>

            </div>

            <%-- ACTION BUTTONS --%>
            <div class="order-detail-actions">
                <a href="${pageContext.request.contextPath}/orders"
                   class="btn-view-orders">
                    📋 View All Orders
                </a>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn-continue-shop">
                    🛍️ Continue Shopping
                </a>
            </div>

        </div>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>