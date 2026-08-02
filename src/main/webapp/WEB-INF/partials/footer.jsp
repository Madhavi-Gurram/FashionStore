<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
    <div class="footer-container">

        <!-- Brand Section -->
        <div class="footer-brand">
            <h2 class="footer-logo">Fashion<span class="logo-highlight">Store</span></h2>
            <p class="footer-tagline">Your one-stop destination for trendy fashion for men, women and kids.</p>
        </div>

        <!-- Quick Links -->
        <div class="footer-links">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/products">All Products</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=1">Tops</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=2">Bottoms</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=3">Dresses</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=4">Ethnic Wear</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=5">Accessories</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=6">Men's Wear</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=7">Kids Wear</a></li>
            </ul>
        </div>

        <!-- Account Links -->
        <div class="footer-links">
            <h4>My Account</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/user?action=loginPage">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/user?action=registerPage">Register</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">My Cart</a></li>
                <li><a href="${pageContext.request.contextPath}/orders">My Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/user?action=profile">My Profile</a></li>
            </ul>
        </div>

        <!-- Contact Info -->
        <div class="footer-contact">
            <h4>Contact Us</h4>
            <p>📧 support@fashionstore.com</p>
            <p>📞 +91 98765 43210</p>
            <p>📍 Bengaluru, Karnataka, India</p>
            <div class="footer-social">
                <a href="#" class="social-link">Instagram</a>
                <a href="#" class="social-link">Facebook</a>
                <a href="#" class="social-link">Twitter</a>
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        <p>&copy; 2026 FashionStore. All rights reserved.</p>
    </div>
</footer>