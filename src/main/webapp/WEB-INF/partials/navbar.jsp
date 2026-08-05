<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style>
    /* =============================================
       NAVBAR
       ============================================= */
    .navbar {
        background: var(--navy);
        padding: 0 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 68px;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 12px rgba(15,36,71,0.3);
    }

    /* LOGO */
    .navbar-logo {
        font-size: 20px;
        font-weight: 700;
        color: var(--white);
        text-decoration: none;
        flex-shrink: 0;
    }

    .navbar-logo span { color: #67E8F9; }

    /* SEARCH */
    .navbar-search {
        flex: 1;
        max-width: 480px;
        margin: 0 32px;
        display: flex;
        align-items: center;
        background: rgba(255,255,255,0.1);
        border-radius: 30px;
        padding: 0 16px;
        border: 1.5px solid rgba(255,255,255,0.15);
        transition: all 0.2s;
    }

    .navbar-search:focus-within {
        background: rgba(255,255,255,0.15);
        border-color: #67E8F9;
    }

    .navbar-search input {
        flex: 1;
        background: none;
        border: none;
        outline: none;
        color: var(--white);
        font-size: 13px;
        font-family: 'Poppins', sans-serif;
        padding: 10px 0;
    }

    .navbar-search input::placeholder { color: rgba(255,255,255,0.5); }

    .navbar-search button {
        background: none;
        border: none;
        cursor: pointer;
        color: rgba(255,255,255,0.7);
        font-size: 16px;
        padding: 0;
        display: flex;
        align-items: center;
        transition: color 0.2s;
    }

    .navbar-search button:hover { color: #67E8F9; }

    /* NAV LINKS */
    .navbar-links {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        gap: 5px;
        padding: 7px 12px;
        color: rgba(255,255,255,0.85);
        text-decoration: none;
        font-size: 13px;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.2s;
        position: relative;
        white-space: nowrap;
    }

    .nav-link:hover {
        color: var(--white);
        background: rgba(255,255,255,0.1);
    }

    .nav-link.active {
        color: #67E8F9;
        background: rgba(103,232,249,0.1);
    }

    /* BADGE */
    .nav-badge {
        background: #EF4444;
        color: var(--white);
        font-size: 10px;
        font-weight: 700;
        padding: 1px 5px;
        border-radius: 10px;
        min-width: 16px;
        text-align: center;
        line-height: 1.4;
    }

    .nav-badge-wishlist {
        background: #EC4899;
        color: var(--white);
        font-size: 10px;
        font-weight: 700;
        padding: 1px 5px;
        border-radius: 10px;
        min-width: 16px;
        text-align: center;
        line-height: 1.4;
    }

    /* ADMIN BUTTON */
    .btn-admin-nav {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 7px 14px;
        background: rgba(124,58,237,0.3);
        color: #C4B5FD;
        border: 1px solid rgba(124,58,237,0.4);
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
    }

    .btn-admin-nav:hover {
        background: rgba(124,58,237,0.5);
        color: var(--white);
    }

    /* USER DROPDOWN */
    .nav-user-wrap {
        position: relative;
    }

    .btn-nav-user {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 7px 14px;
        background: rgba(255,255,255,0.1);
        color: var(--white);
        border: 1px solid rgba(255,255,255,0.2);
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        font-family: 'Poppins', sans-serif;
    }

    .btn-nav-user:hover {
        background: rgba(255,255,255,0.18);
        border-color: rgba(255,255,255,0.3);
    }

    .user-dropdown {
        position: absolute;
        top: calc(100% + 10px);
        right: 0;
        background: var(--white);
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.15);
        min-width: 180px;
        display: none;
        z-index: 999;
        overflow: hidden;
        border: 1px solid var(--border);
    }

    .nav-user-wrap:hover .user-dropdown { display: block; }

    .dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 11px 16px;
        font-size: 13px;
        color: var(--navy);
        text-decoration: none;
        transition: background 0.15s;
        font-weight: 500;
    }

    .dropdown-item:hover { background: var(--primary-bg); }

    .dropdown-divider {
        height: 1px;
        background: var(--border);
        margin: 4px 0;
    }

    .dropdown-item.logout {
        color: #DC2626;
    }

    .dropdown-item.logout:hover { background: #FEF2F2; }

    /* LOGIN / REGISTER BUTTONS */
    .btn-nav-login {
        padding: 7px 16px;
        color: rgba(255,255,255,0.9);
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 20px;
        font-size: 13px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.2s;
    }

    .btn-nav-login:hover {
        background: rgba(255,255,255,0.1);
        color: var(--white);
    }

    .btn-nav-register {
        padding: 7px 16px;
        background: var(--primary);
        color: var(--white);
        border: none;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        transition: background 0.2s;
    }

    .btn-nav-register:hover { background: #0891B2; }
</style>
</head>
<body>
<nav class="navbar">

    <%-- LOGO --%>
    <a href="${pageContext.request.contextPath}/home"
       class="navbar-logo">
        Fashion<span>Store</span>
    </a>

    <%-- SEARCH --%>
    <form action="${pageContext.request.contextPath}/products"
          method="get"
          class="navbar-search">
        <input type="text"
               name="search"
               placeholder="Search for clothes, accessories..."/>
        <button type="submit">🔍</button>
    </form>

    <%-- NAV LINKS --%>
    <div class="navbar-links">

        <%-- HOME --%>
        <a href="${pageContext.request.contextPath}/home"
           class="nav-link">
            🏠 Home
        </a>

        <c:choose>
            <%-- LOGGED IN --%>
            <c:when test="${not empty sessionScope.user}">

                <%-- ADMIN BUTTON --%>
                <c:if test="${sessionScope.user.isAdmin()}">
                    <a href="${pageContext.request.contextPath}/admin"
                       class="btn-admin-nav">
                        ⚙️ Admin
                    </a>
                </c:if>

                <%-- ORDERS --%>
                <a href="${pageContext.request.contextPath}/orders"
                   class="nav-link">
                    📋 Orders
                </a>

                <%-- WISHLIST --%>
                <a href="${pageContext.request.contextPath}/wishlist"
                   class="nav-link">
                    ❤️ Wishlist
                    <c:if test="${not empty sessionScope.wishlistCount
                                  && sessionScope.wishlistCount > 0}">
                        <span class="nav-badge-wishlist">
                            ${sessionScope.wishlistCount}
                        </span>
                    </c:if>
                </a>

                <%-- CART --%>
                <a href="${pageContext.request.contextPath}/cart"
                   class="nav-link">
                    🛒 Cart
                    <c:if test="${not empty sessionScope.cartCount
                                  && sessionScope.cartCount > 0}">
                        <span class="nav-badge">
                            ${sessionScope.cartCount}
                        </span>
                    </c:if>
                </a>

                <%-- USER DROPDOWN --%>
                <div class="nav-user-wrap">
                    <button class="btn-nav-user">
                        👤 ${sessionScope.user.fullName}
                    </button>
                    <div class="user-dropdown">
                        <a href="${pageContext.request.contextPath}/user?action=profile"
                           class="dropdown-item">
                            👤 My Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/orders"
                           class="dropdown-item">
                            📋 My Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/wishlist"
                           class="dropdown-item">
                            ❤️ My Wishlist
                        </a>
                        <a href="${pageContext.request.contextPath}/cart"
                           class="dropdown-item">
                            🛒 My Cart
                        </a>
                        <div class="dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/user?action=logout"
                           class="dropdown-item logout">
                            🚪 Logout
                        </a>
                    </div>
                </div>

            </c:when>

            <%-- NOT LOGGED IN --%>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user?action=loginPage"
                   class="btn-nav-login">Login</a>
                <a href="${pageContext.request.contextPath}/user?action=registerPage"
                   class="btn-nav-register">Register</a>
            </c:otherwise>
        </c:choose>

    </div>
</nav>
</body>
</html>