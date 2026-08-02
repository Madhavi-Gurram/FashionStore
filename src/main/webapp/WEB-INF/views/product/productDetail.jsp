<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <%-- BREADCRUMB --%>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span>›</span>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <span>›</span>
            <span>${product.name}</span>
        </div>

        <%-- ALERTS --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <%-- PRODUCT DETAIL LAYOUT --%>
        <div class="product-detail-layout">

            <%-- LEFT — IMAGE --%>
            <div class="product-detail-img-wrap">
                <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                     alt="${product.name}"
                     class="product-detail-img"
                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
            </div>

            <%-- RIGHT — INFO --%>
            <div class="product-detail-info">

                <%-- Category --%>
                <div class="product-detail-category">
                    <c:forEach var="cat" items="${categories}">
                        <c:if test="${cat.categoryId == product.categoryId}">
                            ${cat.categoryName}
                        </c:if>
                    </c:forEach>
                </div>

                <%-- Name --%>
                <h1 class="product-detail-name">${product.name}</h1>

                <%-- Price --%>
                <div class="product-detail-price">
                    ₹<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                </div>

                <%-- Description --%>
                <p class="product-detail-desc">${product.description}</p>

                <%-- FORM --%>
                <form action="${pageContext.request.contextPath}/cart"
                      method="post" id="addToCartForm">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="productId" value="${product.productId}"/>
                    <input type="hidden" name="variantId"
                           id="selectedVariantId" value=""/>

                    <%-- SIZE SELECTOR --%>
                    <div class="size-label">Select Size:</div>
                    <div class="size-options">
                        <c:forEach var="variant" items="${variants}">
                            <button type="button"
                                    class="size-btn ${variant.stock == 0 ? 'out-of-stock' : ''}"
                                    data-variant-id="${variant.variantId}"
                                    data-stock="${variant.stock}"
                                    ${variant.stock == 0 ? 'disabled' : ''}
                                    onclick="selectSize(this)">
                                ${variant.size}
                            </button>
                        </c:forEach>
                    </div>

                    <%-- STOCK INFO --%>
                    <div class="size-stock-info" id="stockInfo">
                        Please select a size
                    </div>

                    <%-- QUANTITY --%>
                    <div class="qty-section">
                        <label>Quantity:</label>
                        <div class="qty-control">
                            <button type="button" class="qty-btn"
                                    onclick="changeQty(-1)">−</button>
                            <span class="qty-value" id="qtyDisplay">1</span>
                            <button type="button" class="qty-btn"
                                    onclick="changeQty(1)">+</button>
                            <input type="hidden" name="quantity"
                                   id="qtyInput" value="1"/>
                        </div>
                    </div>

                    <%-- ACTION BUTTONS --%>
                    <div class="detail-actions">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <button type="submit" class="btn-add-cart">
                                    🛒 Add to Cart
                                </button>
                                <button type="submit" class="btn-buy-now"
                                        onclick="document.querySelector('[name=action]').value='buyNow'">
                                    ⚡ Buy Now
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/user?action=loginPage"
                                   class="btn-add-cart" style="text-align:center;">
                                    Login to Add to Cart
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </form>

                <%-- PRODUCT META --%>
                <div class="product-meta">
                    <p>🚚 Free shipping on orders above ₹999</p>
                    <p>↩️ Easy 7-day returns</p>
                    <p>🔒 Secure payment</p>
                </div>

            </div>
        </div>

        <%-- RELATED PRODUCTS --%>
        <c:if test="${not empty relatedProducts}">
            <div class="related-section">
                <h2 class="section-title">You may also <span>like</span></h2>
                <div class="related-grid">
                    <c:forEach var="related" items="${relatedProducts}">
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${related.productId}"
                           class="product-card">
                            <div class="product-card-img-wrap">
                                <img src="${pageContext.request.contextPath}/${related.imageUrl}"
                                     alt="${related.name}"
                                     class="product-card-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                            </div>
                            <div class="product-card-body">
                                <div class="product-card-name">${related.name}</div>
                                <div class="product-card-price">
                                    ₹<fmt:formatNumber value="${related.price}"
                                      pattern="#,##0.00"/>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

    <script>
        let currentStock = 0;

        function selectSize(btn) {
            document.querySelectorAll('.size-btn').forEach(b => {
                b.classList.remove('selected');
            });
            btn.classList.add('selected');
            document.getElementById('selectedVariantId').value = btn.dataset.variantId;
            currentStock = parseInt(btn.dataset.stock);
            const stockInfo = document.getElementById('stockInfo');
            if (currentStock > 10) {
                stockInfo.innerHTML = '✅ <span>In Stock</span> (' + currentStock + ' available)';
            } else if (currentStock > 0) {
                stockInfo.innerHTML = '⚠️ Only <span>' + currentStock + ' left</span> in stock!';
            } else {
                stockInfo.innerHTML = '❌ Out of Stock';
            }
            document.getElementById('qtyDisplay').textContent = '1';
            document.getElementById('qtyInput').value = '1';
        }

        function changeQty(change) {
            let qty = parseInt(document.getElementById('qtyInput').value);
            qty += change;
            if (qty < 1) qty = 1;
            if (currentStock > 0 && qty > currentStock) qty = currentStock;
            document.getElementById('qtyDisplay').textContent = qty;
            document.getElementById('qtyInput').value = qty;
        }

        document.getElementById('addToCartForm').addEventListener('submit', function(e) {
            const variantId = document.getElementById('selectedVariantId').value;
            if (!variantId) {
                e.preventDefault();
                alert('Please select a size before adding to cart!');
            }
        });
    </script>

</body>
</html>