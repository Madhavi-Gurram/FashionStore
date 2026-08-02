<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <%-- PAGE HEADER --%>
        <div class="page-header">
            <c:choose>
                <c:when test="${not empty searchKeyword}">
                    <h2 class="page-title">Search results for "${searchKeyword}"</h2>
                    <p class="page-subtitle">${totalProducts} products found</p>
                </c:when>
                <c:when test="${not empty selectedCategory}">
                    <c:forEach var="cat" items="${categories}">
                        <c:if test="${cat.categoryId == selectedCategory}">
                            <h2 class="page-title">${cat.categoryName}</h2>
                        </c:if>
                    </c:forEach>
                    <p class="page-subtitle">${totalProducts} products found</p>
                </c:when>
                <c:otherwise>
                    <h2 class="page-title">All Products</h2>
                    <p class="page-subtitle">${totalProducts} products available</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- CATEGORY TABS --%>
        <div class="category-tabs">
            <a href="${pageContext.request.contextPath}/products"
               class="category-tab ${empty selectedCategory && empty searchKeyword ? 'active' : ''}">
                All
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}"
                   class="category-tab ${selectedCategory == cat.categoryId ? 'active' : ''}">
                    ${cat.categoryName}
                </a>
            </c:forEach>
        </div>

        <%-- SHOP LAYOUT --%>
        <div class="shop-layout">

            <%-- FILTER SIDEBAR --%>
            <aside class="filter-sidebar">
                <div class="filter-title">🔍 Filter Products</div>

                <form action="${pageContext.request.contextPath}/products" method="get">

                    <%-- CATEGORY DROPDOWN --%>
                    <div class="filter-section">
                        <h5>Category</h5>
                        <select name="category" class="filter-select">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}"
                                    ${selectedCategory == cat.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <%-- PRICE RANGE --%>
                    <div class="filter-section">
                        <h5>Price Range (₹)</h5>
                        <input type="number" name="minPrice"
                               placeholder="Min Price"
                               value="${not empty minPrice ? minPrice : ''}"
                               min="0"/>
                        <input type="number" name="maxPrice"
                               placeholder="Max Price"
                               value="${not empty maxPrice ? maxPrice : ''}"
                               min="0"/>
                    </div>

                    <%-- SORT BY --%>
                    <div class="filter-section">
                        <h5>Sort By</h5>
                        <select name="sortBy" class="filter-select">
                            <option value="">Default</option>
                            <option value="price_asc"
                                ${'price_asc' == sortBy ? 'selected' : ''}>
                                Price: Low to High
                            </option>
                            <option value="price_desc"
                                ${'price_desc' == sortBy ? 'selected' : ''}>
                                Price: High to Low
                            </option>
                            <option value="name_asc"
                                ${'name_asc' == sortBy ? 'selected' : ''}>
                                Name: A to Z
                            </option>
                            <option value="name_desc"
                                ${'name_desc' == sortBy ? 'selected' : ''}>
                                Name: Z to A
                            </option>
                        </select>
                    </div>

                    <button type="submit" class="filter-btn">Apply Filter</button>
                    <a href="${pageContext.request.contextPath}/products"
                       class="filter-reset">Clear All</a>

                </form>

            </aside>

            <%-- PRODUCTS SECTION --%>
            <div class="products-section">

                <%-- TOOLBAR --%>
                <div class="products-toolbar">
                    <form action="${pageContext.request.contextPath}/products"
                          method="get" class="toolbar-search">
                        <input type="text" name="search"
                               placeholder="Search products..."
                               value="${not empty searchKeyword ? searchKeyword : ''}"/>
                        <button type="submit">Search</button>
                    </form>
                    <div class="toolbar-count">
                        Showing <strong>${totalProducts}</strong> products
                    </div>
                </div>

                <%-- PRODUCT CARDS --%>
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="product-grid">
                            <c:forEach var="product" items="${products}">
                                <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}"
                                   class="product-card">
                                    <div class="product-card-img-wrap">
                                        <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                             alt="${product.name}"
                                             class="product-card-img"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                        <c:if test="${product.price < 800}">
                                            <span class="product-card-badge">Best Value</span>
                                        </c:if>
                                    </div>
                                    <div class="product-card-body">
                                        <div class="product-card-category">
                                            <c:forEach var="cat" items="${categories}">
                                                <c:if test="${cat.categoryId == product.categoryId}">
                                                    ${cat.categoryName}
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="product-card-name">${product.name}</div>
                                        <div class="product-card-price">
                                            ₹<fmt:formatNumber value="${product.price}"
                                              pattern="#,##0.00"/>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">🛍️</div>
                            <h3>No products found</h3>
                            <c:choose>
                                <c:when test="${not empty searchKeyword}">
                                    <p>No results for "${searchKeyword}".
                                       Try a different keyword.</p>
                                </c:when>
                                <c:otherwise>
                                    <p>No products available right now.</p>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/products"
                               class="btn-primary">View All Products</a>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>