<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <div class="page-header">
            <h2 class="page-title">My Cart</h2>
            <p class="page-subtitle">${itemCount} item(s) in your cart</p>
        </div>

        <c:choose>
            <c:when test="${not empty enrichedItems}">

                <div class="cart-layout">

                    <%-- CART ITEMS --%>
                    <div class="cart-items-section">

                        <c:forEach var="entry" items="${enrichedItems}">
                            <div class="cart-item-card">

                                <%-- PRODUCT IMAGE --%>
                                <div class="cart-item-img-wrap">
                                    <img src="${pageContext.request.contextPath}/${entry.product.imageUrl}"
                                         alt="${entry.product.name}"
                                         class="cart-item-img"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                </div>

                                <%-- PRODUCT INFO --%>
                                <div class="cart-item-info">
                                    <div class="cart-item-name">${entry.product.name}</div>
                                    <div class="cart-item-size">
                                        Size: <strong>${entry.variant.size}</strong>
                                    </div>
                                    <div class="cart-item-price">
                                        ₹<fmt:formatNumber value="${entry.product.price}"
                                          pattern="#,##0.00"/>
                                    </div>
                                </div>

                                <%-- QUANTITY CONTROL --%>
                                <div class="cart-item-qty">
                                    <form action="${pageContext.request.contextPath}/cart"
                                          method="post" class="qty-form">
                                        <input type="hidden" name="action" value="update"/>
                                        <input type="hidden" name="cartItemId"
                                               value="${entry.cartItem.cartItemId}"/>
                                        <div class="qty-control">
                                            <button type="submit" name="quantity"
                                                    value="${entry.cartItem.quantity - 1}"
                                                    class="qty-btn"
                                                    ${entry.cartItem.quantity <= 1 ? 'disabled' : ''}>
                                                −
                                            </button>
                                            <span class="qty-value">${entry.cartItem.quantity}</span>
                                            <button type="submit" name="quantity"
                                                    value="${entry.cartItem.quantity + 1}"
                                                    class="qty-btn">
                                                +
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <%-- SUBTOTAL --%>
                                <div class="cart-item-subtotal">
                                    ₹<fmt:formatNumber value="${entry.subtotal}"
                                      pattern="#,##0.00"/>
                                </div>

                                <%-- REMOVE BUTTON --%>
                                <div class="cart-item-remove">
                                    <a href="${pageContext.request.contextPath}/cart?action=remove&cartItemId=${entry.cartItem.cartItemId}"
                                       class="btn-remove"
                                       onclick="return confirm('Remove this item from cart?')">
                                        ✕
                                    </a>
                                </div>

                            </div>
                        </c:forEach>

                        <%-- CONTINUE SHOPPING --%>
                        <div class="cart-continue">
                            <a href="${pageContext.request.contextPath}/products"
                               class="btn-continue">
                                ← Continue Shopping
                            </a>
                        </div>

                    </div>

                    <%-- ORDER SUMMARY --%>
                    <div class="cart-summary">

                        <div class="summary-card">
                            <h3 class="summary-title">Order Summary</h3>

                            <div class="summary-row">
                                <span>Subtotal (${itemCount} items)</span>
                                <span>₹<fmt:formatNumber value="${cartTotal}"
                                      pattern="#,##0.00"/></span>
                            </div>

                            <div class="summary-row">
                                <span>Shipping</span>
                                <span class="${cartTotal >= 999 ? 'free-shipping' : ''}">
                                    <c:choose>
                                        <c:when test="${cartTotal >= 999}">FREE</c:when>
                                        <c:otherwise>₹99.00</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <c:if test="${cartTotal < 999}">
                                <div class="shipping-notice">
                                    Add ₹<fmt:formatNumber value="${999 - cartTotal}"
                                          pattern="#,##0.00"/> more for free shipping!
                                </div>
                            </c:if>

                            <div class="summary-divider"></div>

                            <div class="summary-row summary-total">
                                <span>Total</span>
                                <span>
                                    ₹<fmt:formatNumber
                                      value="${cartTotal >= 999 ? cartTotal : cartTotal + 99}"
                                      pattern="#,##0.00"/>
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/orders?action=checkoutPage"
                               class="btn-checkout">
                                Proceed to Checkout →
                            </a>

                            <div class="summary-secure">
                                🔒 Secure Checkout
                            </div>
                        </div>

                    </div>

                </div>

            </c:when>
            <c:otherwise>

                <%-- EMPTY CART --%>
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h3>Your cart is empty!</h3>
                    <p>Looks like you haven't added anything yet.</p>
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