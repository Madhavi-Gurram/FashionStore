<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css">
    <style>
        .wishlist-wrapper {
            max-width: 1100px;
            margin: 0 auto;
            padding: 32px 24px 60px;
        }
        .wishlist-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .wishlist-count {
            font-size: 13px;
            color: var(--text-light);
            background: var(--primary-bg);
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: 600;
            color: var(--primary);
        }
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 24px;
        }
        .wishlist-card {
            background: var(--white);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(14,116,144,0.08);
            border: 1.5px solid var(--border);
            overflow: hidden;
            transition: all 0.2s;
            position: relative;
        }
        .wishlist-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(14,116,144,0.15);
            border-color: var(--primary-light);
        }
        .wishlist-card-img-wrap {
            position: relative;
            overflow: hidden;
        }
        .wishlist-card-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            background: var(--primary-bg);
            transition: transform 0.3s;
        }
        .wishlist-card:hover .wishlist-card-img {
            transform: scale(1.04);
        }
        .remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: rgba(255,255,255,0.95);
            border: none;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.2s;
            text-decoration: none;
            color: #DC2626;
        }
        .remove-btn:hover {
            background: #DC2626;
            color: var(--white);
            transform: scale(1.1);
        }
        .wishlist-card-body {
            padding: 14px 16px 16px;
        }
        .wishlist-card-category {
            font-size: 11px;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .wishlist-card-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .wishlist-card-price {
            font-size: 16px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 14px;
        }
        .wishlist-card-actions {
            display: flex;
            gap: 8px;
        }
        .btn-view-product {
            flex: 1;
            padding: 9px 12px;
            background: var(--navy);
            color: var(--white);
            border: none;
            border-radius: var(--radius-lg);
            font-size: 12px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: background 0.2s;
            display: block;
        }
        .btn-view-product:hover { background: var(--primary); }
        .btn-remove-wishlist {
            padding: 9px 12px;
            background: #FEF2F2;
            color: #DC2626;
            border: 1.5px solid #FECACA;
            border-radius: var(--radius-lg);
            font-size: 12px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.2s;
            display: block;
            white-space: nowrap;
        }
        .btn-remove-wishlist:hover {
            background: #DC2626;
            color: var(--white);
            border-color: #DC2626;
        }
        .wishlist-added-date {
            font-size: 11px;
            color: var(--text-light);
            margin-top: 8px;
            text-align: right;
        }
        .empty-wishlist {
            text-align: center;
            padding: 80px 20px;
            background: var(--white);
            border-radius: 14px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .empty-wishlist-icon { font-size: 64px; margin-bottom: 16px; }
        .empty-wishlist h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 8px;
        }
        .empty-wishlist p {
            font-size: 14px;
            color: var(--text-light);
            margin-bottom: 24px;
        }
        .btn-browse {
            display: inline-block;
            padding: 12px 32px;
            background: var(--navy);
            color: var(--white);
            border-radius: var(--radius-lg);
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s;
        }
        .btn-browse:hover { background: var(--primary); }
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 16px;
        }
        .alert-success {
            background: #D1FAE5;
            color: #065F46;
            border: 1px solid #A7F3D0;
        }
        .alert-error {
            background: #FEE2E2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="wishlist-wrapper">

        <%-- PAGE HEADER --%>
        <div class="wishlist-header">
            <div>
                <h2 class="page-title">❤️ My Wishlist</h2>
                <p class="page-subtitle">Products you love, saved for later</p>
            </div>
            <c:if test="${not empty wishlistProducts}">
                <span class="wishlist-count">
                    ${wishlistCount} item(s) saved
                </span>
            </c:if>
        </div>

        <%-- ALERTS --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <%-- WISHLIST GRID --%>
        <c:choose>
            <c:when test="${not empty wishlistProducts}">
                <div class="wishlist-grid">
                    <c:forEach var="product" items="${wishlistProducts}">
                        <div class="wishlist-card">

                            <%-- PRODUCT IMAGE --%>
                            <div class="wishlist-card-img-wrap">
                                <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}">
                                    <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                         alt="${product.name}"
                                         class="wishlist-card-img"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                </a>

                                <%-- REMOVE BUTTON ON IMAGE --%>
                                <a href="${pageContext.request.contextPath}/wishlist?action=remove&productId=${product.productId}"
                                   class="remove-btn"
                                   title="Remove from Wishlist">
                                    ✕
                                </a>
                            </div>

                            <%-- PRODUCT BODY --%>
                            <div class="wishlist-card-body">
                                <div class="wishlist-card-category">
                                    <c:forEach var="cat" items="${categories}">
                                        <c:if test="${cat.categoryId == product.categoryId}">
                                            ${cat.categoryName}
                                        </c:if>
                                    </c:forEach>
                                </div>
                                <div class="wishlist-card-name">
                                    ${product.name}
                                </div>
                                <div class="wishlist-card-price">
                                    ₹<fmt:formatNumber value="${product.price}"
                                      pattern="#,##0.00"/>
                                </div>

                                <%-- ACTION BUTTONS --%>
                                <div class="wishlist-card-actions">
                                    <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}"
                                       class="btn-view-product">
                                        View Product →
                                    </a>
                                    <a href="${pageContext.request.contextPath}/wishlist?action=remove&productId=${product.productId}"
                                       class="btn-remove-wishlist">
                                        🗑️ Remove
                                    </a>
                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <div class="empty-wishlist">
                    <div class="empty-wishlist-icon">🤍</div>
                    <h3>Your wishlist is empty</h3>
                    <p>Save your favourite products here and shop them later!</p>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn-browse">Browse Products →</a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>