<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<nav class="navbar">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <span class="logo-text">Fashion<span class="logo-highlight">Store</span></span>
        </a>
    </div>

    <div class="nav-center">
        <form action="${pageContext.request.contextPath}/products" method="get" class="search-form">
            <div class="search-box">
                <input type="text" name="search" placeholder="Search for clothes, accessories..."
                       value="${param.search}" class="search-input"/>
                <button type="submit" class="search-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"/>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </button>
            </div>
        </form>
    </div>

   <div class="nav-right">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
        <%-- HOME LINK --%>
<a href="${pageContext.request.contextPath}/home" class="nav-link">
    🏠 <span>Home</span>
</a>

                <%-- ADMIN PANEL LINK — only for admin users --%>
                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin"
                       class="nav-link admin-link">
                        ⚙️ <span>Admin</span>
                    </a>
                </c:if>

                <%-- ORDERS --%>
                <a href="${pageContext.request.contextPath}/orders" class="nav-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                        <polyline points="10 9 9 9 8 9"/>
                    </svg>
                    <span>Orders</span>
                </a>

                <%-- CART --%>
                <a href="${pageContext.request.contextPath}/cart" class="nav-link cart-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="9" cy="21" r="1"/>
                        <circle cx="20" cy="21" r="1"/>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                    </svg>
                    <span>Cart</span>
                    <c:if test="${sessionScope.cartCount > 0}">
                        <span class="cart-badge">${sessionScope.cartCount}</span>
                    </c:if>
                </a>

                <%-- PROFILE DROPDOWN --%>
                <div class="nav-profile dropdown">
                    <button class="profile-btn" onclick="toggleDropdown()">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                             viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        <span>${sessionScope.user.fullName}</span>
                    </button>
                    <div class="dropdown-menu" id="profileDropdown">
                        <a href="${pageContext.request.contextPath}/user?action=profile">
                            👤 My Profile
                        </a>
                        <c:if test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/admin">
                                ⚙️ Admin Panel
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/user?action=logout">
                            🚪 Logout
                        </a>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <%-- NOT LOGGED IN --%>
                <a href="${pageContext.request.contextPath}/user?action=loginPage"
                   class="nav-link">Login</a>
                <a href="${pageContext.request.contextPath}/user?action=registerPage"
                   class="btn-primary-sm">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script>
    function toggleDropdown() {
        const menu = document.getElementById('profileDropdown');
        menu.classList.toggle('show');
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        const dropdown = document.querySelector('.nav-profile');
        if (dropdown && !dropdown.contains(e.target)) {
            const menu = document.getElementById('profileDropdown');
            if (menu) menu.classList.remove('show');
        }
    });
</script>