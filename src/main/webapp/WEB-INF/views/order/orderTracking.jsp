<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <%-- BREADCRUMB --%>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span>›</span>
            <a href="${pageContext.request.contextPath}/orders">My Orders</a>
            <span>›</span>
            <span>Track Order #${order.orderId}</span>
        </div>

        <%-- PAGE HEADER --%>
        <div class="tracking-header">
            <div>
                <h2 class="page-title">Track Your Order</h2>
                <p class="page-subtitle">
                    Tracking Number:
                    <strong>${order.trackingNumber}</strong>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/orders"
               class="btn-back">← Back to Orders</a>
        </div>

        <div class="tracking-layout">

            <%-- LEFT — PROGRESS TRACKER --%>
            <div class="tracking-left">

                <%-- STATUS CARD --%>
                <div class="tracking-status-card">
                    <div class="tracking-status-icon">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'Placed'}">📋</c:when>
                            <c:when test="${order.orderStatus == 'Processing'}">⚙️</c:when>
                            <c:when test="${order.orderStatus == 'Shipped'}">🚚</c:when>
                            <c:when test="${order.orderStatus == 'Delivered'}">✅</c:when>
                            <c:when test="${order.orderStatus == 'Cancelled'}">❌</c:when>
                            <c:otherwise>📦</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="tracking-status-info">
                        <div class="tracking-status-label">Current Status</div>

                        <c:choose>
                            <c:when test="${order.orderStatus == 'Delivered'}">
                                <div class="tracking-status-value status-delivered">
                                    ${order.orderStatus}
                                </div>
                            </c:when>
                            <c:when test="${order.orderStatus == 'Cancelled'}">
                                <div class="tracking-status-value status-cancelled">
                                    ${order.orderStatus}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="tracking-status-value status-active">
                                    ${order.orderStatus}
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty order.estimatedDelivery
                                      && order.orderStatus != 'Delivered'
                                      && order.orderStatus != 'Cancelled'}">
                            <div class="tracking-eta">
                                📅 Estimated Delivery: ${order.estimatedDelivery}
                            </div>
                        </c:if>
                        <c:if test="${order.orderStatus == 'Delivered'
                                      && not empty order.deliveredAt}">
                            <div class="tracking-eta delivered">
                                ✅ Delivered on: ${order.deliveredAt}
                            </div>
                        </c:if>
                    </div>
                </div>

                <%-- PROGRESS TRACKER --%>
                <c:if test="${order.orderStatus != 'Cancelled'}">
                    <div class="progress-tracker">

                        <%-- STEP 1 — PLACED --%>
                        <div class="progress-step completed">
                            <div class="step-icon-wrap">
                                <div class="step-icon">✓</div>
                                <div class="step-line"></div>
                            </div>
                            <div class="step-info">
                                <div class="step-title">Order Placed</div>
                                <div class="step-desc">
                                    Your order has been placed successfully
                                </div>
                                <div class="step-time">
                                    <c:choose>
                                        <c:when test="${not empty order.placedAt}">
                                            ${order.placedAt}
                                        </c:when>
                                        <c:otherwise>${order.orderDate}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <%-- STEP 2 — PROCESSING --%>
                        <c:choose>
                            <c:when test="${order.orderStatus == 'Processing'
                                           || order.orderStatus == 'Shipped'
                                           || order.orderStatus == 'Delivered'}">
                                <div class="progress-step completed">
                            </c:when>
                            <c:otherwise>
                                <div class="progress-step pending">
                            </c:otherwise>
                        </c:choose>
                            <div class="step-icon-wrap">
                                <div class="step-icon">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Processing'
                                                       || order.orderStatus == 'Shipped'
                                                       || order.orderStatus == 'Delivered'}">
                                            ✓
                                        </c:when>
                                        <c:otherwise>2</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="step-line"></div>
                            </div>
                            <div class="step-info">
                                <div class="step-title">Processing</div>
                                <div class="step-desc">
                                    Your order is being prepared
                                </div>
                                <div class="step-time">
                                    <c:choose>
                                        <c:when test="${not empty order.processingAt}">
                                            ${order.processingAt}
                                        </c:when>
                                        <c:otherwise>Pending</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <%-- STEP 3 — SHIPPED --%>
                        <c:choose>
                            <c:when test="${order.orderStatus == 'Shipped'
                                           || order.orderStatus == 'Delivered'}">
                                <div class="progress-step completed">
                            </c:when>
                            <c:when test="${order.orderStatus == 'Processing'}">
                                <div class="progress-step active">
                            </c:when>
                            <c:otherwise>
                                <div class="progress-step pending">
                            </c:otherwise>
                        </c:choose>
                            <div class="step-icon-wrap">
                                <div class="step-icon">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Shipped'
                                                       || order.orderStatus == 'Delivered'}">
                                            ✓
                                        </c:when>
                                        <c:otherwise>3</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="step-line"></div>
                            </div>
                            <div class="step-info">
                                <div class="step-title">Shipped</div>
                                <div class="step-desc">
                                    Your order is on the way
                                </div>
                                <div class="step-time">
                                    <c:choose>
                                        <c:when test="${not empty order.shippedAt}">
                                            ${order.shippedAt}
                                        </c:when>
                                        <c:otherwise>Pending</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <%-- STEP 4 — DELIVERED --%>
                        <c:choose>
                            <c:when test="${order.orderStatus == 'Delivered'}">
                                <div class="progress-step completed">
                            </c:when>
                            <c:when test="${order.orderStatus == 'Shipped'}">
                                <div class="progress-step active">
                            </c:when>
                            <c:otherwise>
                                <div class="progress-step pending">
                            </c:otherwise>
                        </c:choose>
                            <div class="step-icon-wrap">
                                <div class="step-icon">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Delivered'}">
                                            ✓
                                        </c:when>
                                        <c:otherwise>4</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="step-info">
                                <div class="step-title">Delivered</div>
                                <div class="step-desc">
                                    Order delivered to your doorstep
                                </div>
                                <div class="step-time">
                                    <c:choose>
                                        <c:when test="${not empty order.deliveredAt}">
                                            ${order.deliveredAt}
                                        </c:when>
                                        <c:otherwise>
                                            Expected: ${order.estimatedDelivery}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                    </div>
                </c:if>

                <%-- CANCELLED STATE --%>
                <c:if test="${order.orderStatus == 'Cancelled'}">
                    <div class="cancelled-state">
                        <div class="cancelled-icon">❌</div>
                        <h3>Order Cancelled</h3>
                        <p>This order has been cancelled.</p>
                        <a href="${pageContext.request.contextPath}/products"
                           class="btn-shop-again">Shop Again →</a>
                    </div>
                </c:if>

            </div>

            <%-- RIGHT — ORDER DETAILS --%>
            <div class="tracking-right">

                <%-- ORDER INFO --%>
                <div class="tracking-card">
                    <div class="tracking-card-title">📦 Order Details</div>
                    <div class="tracking-info-row">
                        <span>Order ID</span>
                        <span><strong>#${order.orderId}</strong></span>
                    </div>
                    <div class="tracking-info-row">
                        <span>Tracking No.</span>
                        <span class="tracking-no">${order.trackingNumber}</span>
                    </div>
                    <div class="tracking-info-row">
                        <span>Order Date</span>
                        <span>${order.orderDate}</span>
                    </div>
                    <div class="tracking-info-row">
                        <span>Payment</span>
                        <span>${order.paymentMethod}</span>
                    </div>
                    <div class="tracking-info-row">
                        <span>Total Amount</span>
                        <span>
                            <strong>
                                ₹<fmt:formatNumber value="${order.totalAmount}"
                                  pattern="#,##0.00"/>
                            </strong>
                        </span>
                    </div>
                </div>

                <%-- DELIVERY ADDRESS --%>
                <div class="tracking-card">
                    <div class="tracking-card-title">📍 Delivery Address</div>
                    <div class="delivery-address">
                        <p><strong>${order.deliveryName}</strong></p>
                        <p>📞 ${order.deliveryPhone}</p>
                        <p>${order.deliveryAddress}</p>
                        <p>${order.deliveryCity}, ${order.deliveryState}</p>
                        <p>PIN: ${order.deliveryPincode}</p>
                    </div>
                </div>

                <%-- ORDER ITEMS --%>
                <div class="tracking-card">
                    <div class="tracking-card-title">🛍️ Items Ordered</div>
                    <div class="tracking-items">
                        <c:forEach var="entry" items="${enrichedItems}">
                            <div class="tracking-item">
                                <img src="${pageContext.request.contextPath}/${entry.product.imageUrl}"
                                     alt="${entry.product.name}"
                                     class="tracking-item-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                <div class="tracking-item-info">
                                    <div class="tracking-item-name">
                                        ${entry.product.name}
                                    </div>
                                    <div class="tracking-item-meta">
                                        Size: ${entry.variant.size} ×
                                        ${entry.orderItem.quantity}
                                    </div>
                                    <div class="tracking-item-price">
                                        ₹<fmt:formatNumber
                                          value="${entry.orderItem.price
                                                  * entry.orderItem.quantity}"
                                          pattern="#,##0.00"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <%-- ACTION BUTTONS --%>
                <div class="tracking-actions">
                    <a href="${pageContext.request.contextPath}/orders"
                       class="btn-track-back">← My Orders</a>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn-shop-more">Shop More →</a>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>