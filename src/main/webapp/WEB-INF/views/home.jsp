<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FashionStore - Your Style Destination</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <%-- HERO SECTION --%>
    <section class="hero-section">

        <div class="hero-content">
            <span class="hero-badge">✨ New Collection 2026</span>
            <h1 class="hero-title">
                Fashion For <span>Everyone</span>
            </h1>
            <p class="hero-subtitle">
                Shop the latest trends for men, women and kids —
                from casual everyday wear to stunning ethnic collections.
                Style that speaks for you.
            </p>

            <div class="hero-quick-nav">
                <a href="${pageContext.request.contextPath}/products?category=2"
                   class="quick-nav-btn">MEN</a>
                <a href="${pageContext.request.contextPath}/products?category=1"
                   class="quick-nav-btn">WOMEN</a>
                <a href="${pageContext.request.contextPath}/products?category=3"
                   class="quick-nav-btn">KIDS</a>
            </div>

            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/products"
                   class="btn-hero-primary">Shop All →</a>
                <a href="${pageContext.request.contextPath}/products?category=4"
                   class="btn-hero-outline">Ethnic Wear</a>
            </div>
        </div>

        <div class="hero-right-wrap">
            <div class="hero-family-img">
                <img src="${pageContext.request.contextPath}/assets/images/hero-family.jpg"
                     alt="Fashion Family"
                     onerror="this.parentElement.classList.add('no-img')"/>
                <div class="hero-img-placeholder">
                    <span>👨‍👩‍👧‍👦</span>
                    <p>Fashion For Everyone</p>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/products?category=2"
               class="hero-float-card card-1">
                <div class="float-card-tag">MEN • PREMIUM</div>
                <div class="float-card-emoji">👔</div>
                <div class="float-card-name">Men's Formal Shirt</div>
                <div class="float-card-price">₹999</div>
            </a>

            <a href="${pageContext.request.contextPath}/products?category=1"
               class="hero-float-card card-2">
                <div class="float-card-tag">WOMEN • NEW</div>
                <div class="float-card-emoji">👗</div>
                <div class="float-card-name">Casual Maxi Dress</div>
                <div class="float-card-price">₹1,099</div>
            </a>

            <a href="${pageContext.request.contextPath}/products?category=3"
               class="hero-float-card card-3">
                <div class="float-card-tag">KIDS • TRENDING</div>
                <div class="float-card-emoji">👶</div>
                <div class="float-card-name">Kids Tracksuit</div>
                <div class="float-card-price">₹799</div>
            </a>
        </div>
    </section>

    <%-- MARQUEE BAR --%>
    <div class="marquee-bar">
        <div class="marquee-track">
            <span>FREE SHIPPING ♦</span>
            <span>EXCLUSIVE DROPS ♦</span>
            <span>PREMIUM QUALITY ♦</span>
            <span>LIMITED EDITION ♦</span>
            <span>TRENDING NOW ♦</span>
            <span>NEW ARRIVALS ♦</span>
            <span>FASHION SALE ♦</span>
            <span>FREE RETURNS ♦</span>
            <span>FREE SHIPPING ♦</span>
            <span>EXCLUSIVE DROPS ♦</span>
            <span>PREMIUM QUALITY ♦</span>
            <span>LIMITED EDITION ♦</span>
            <span>TRENDING NOW ♦</span>
            <span>NEW ARRIVALS ♦</span>
            <span>FASHION SALE ♦</span>
            <span>FREE RETURNS ♦</span>
        </div>
    </div>

    <%-- STATS BAR --%>
    <div class="stats-bar">
        <div class="stat-item">
            <span class="stat-number">500+</span>
            <span class="stat-label">Products</span>
        </div>
        <div class="stat-item">
            <span class="stat-number">5</span>
            <span class="stat-label">Categories</span>
        </div>
        <div class="stat-item">
            <span class="stat-number">10K+</span>
            <span class="stat-label">Happy Customers</span>
        </div>
        <div class="stat-item">
            <span class="stat-number">Free</span>
            <span class="stat-label">Shipping Above ₹999</span>
        </div>
    </div>

    <%-- SHOP BY CATEGORY --%>
    <section class="home-section">
        <div class="section-header">
            <div>
                <h2 class="section-title">Shop by <span>Category</span></h2>
                <p class="section-subtitle">Find exactly what you're looking for</p>
            </div>
            <a href="${pageContext.request.contextPath}/products"
               class="section-link">View All →</a>
        </div>

        <div class="category-grid">

            <%-- Women --%>
            <a href="${pageContext.request.contextPath}/products?category=1"
               class="category-card">
                <span class="category-card-icon">👩</span>
                <div class="category-card-name">Women</div>
                <div class="category-card-count">T-shirts, shirts, blouses and more</div>
            </a>

            <%-- Men --%>
            <a href="${pageContext.request.contextPath}/products?category=2"
               class="category-card">
                <span class="category-card-icon">👔</span>
                <div class="category-card-name">Men</div>
                <div class="category-card-count">Jeans, trousers, skirts and more</div>
            </a>

            <%-- Kids --%>
            <a href="${pageContext.request.contextPath}/products?category=3"
               class="category-card">
                <span class="category-card-icon">👶</span>
                <div class="category-card-name">Kids</div>
                <div class="category-card-count">Casual and formal dresses</div>
            </a>

            <%-- Ethnic Wear --%>
            <a href="${pageContext.request.contextPath}/products?category=4"
               class="category-card">
                <span class="category-card-icon">🥻</span>
                <div class="category-card-name">Ethnic Wear</div>
                <div class="category-card-count">Kurtis, sarees, lehengas and more</div>
            </a>

            <%-- Accessories --%>
            <a href="${pageContext.request.contextPath}/products?category=5"
               class="category-card">
                <span class="category-card-icon">👜</span>
                <div class="category-card-name">Accessories</div>
                <div class="category-card-count">Bags, belts, scarves and more</div>
            </a>

        </div>
    </section>

    <%-- FEATURED PRODUCTS --%>
    <section class="home-section" style="padding-top: 0;">
        <div class="section-header">
            <div>
                <h2 class="section-title">Featured <span>Products</span></h2>
                <p class="section-subtitle">Handpicked styles just for you</p>
            </div>
            <a href="${pageContext.request.contextPath}/products"
               class="section-link">View All →</a>
        </div>

        <div class="featured-grid">
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach var="product" items="${featuredProducts}">
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}"
                           class="product-card">
                            <div class="product-card-img-wrap">
                                <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                                     alt="${product.name}"
                                     class="product-card-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                <span class="product-card-badge">New</span>
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
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">🛍️</div>
                        <h3>No products available</h3>
                        <p>Check back soon for new arrivals!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <%-- PROMO BANNERS --%>
    <section class="promo-section">
        <div class="promo-grid">
            <a href="${pageContext.request.contextPath}/products?category=4"
               class="promo-card promo-card-1">
                <div class="promo-tag">New Arrivals</div>
                <div class="promo-title">Ethnic Wear<br/>Collection</div>
                <div class="promo-subtitle">Kurtis, Palazzo Sets & more</div>
                <span class="promo-link">Shop Now →</span>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=2"
               class="promo-card promo-card-2">
                <div class="promo-tag">Trending Now</div>
                <div class="promo-title">Men's Fashion<br/>Collection</div>
                <div class="promo-subtitle">Shirts, Kurtas & more for men</div>
                <span class="promo-link">Explore →</span>
            </a>
        </div>
    </section>

    <%-- WHY CHOOSE US --%>
    <section class="features-section">
        <div class="section-header">
            <div>
                <h2 class="section-title">Why Choose <span>FashionStore?</span></h2>
                <p class="section-subtitle">We make shopping easy, fast and fun</p>
            </div>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🚚</div>
                <div class="feature-title">Free Shipping</div>
                <div class="feature-desc">
                    Free delivery on all orders above ₹999.
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">↩️</div>
                <div class="feature-title">Easy Returns</div>
                <div class="feature-desc">
                    Return within 7 days, no questions asked.
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <div class="feature-title">Secure Payments</div>
                <div class="feature-desc">
                    Your payment info is always safe.
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🎧</div>
                <div class="feature-title">24/7 Support</div>
                <div class="feature-desc">
                    Our support team is always here to help.
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

</body>
</html>