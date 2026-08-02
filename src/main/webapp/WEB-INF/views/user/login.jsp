<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="auth-wrapper">
        <div class="auth-card">

            <%-- LOGO --%>
            <div class="auth-logo">
                <a href="${pageContext.request.contextPath}/home">
                    Fashion<span>Store</span>
                </a>
            </div>

            <h2 class="auth-title">Welcome Back!</h2>
            <p class="auth-subtitle">Login to your account to continue shopping</p>

            <%-- SERVER SIDE ERROR --%>
            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠️ ${error}</div>
            </c:if>

            <%-- SERVER SIDE SUCCESS --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">✅ ${success}</div>
            </c:if>

            <%-- SUCCESS AFTER REGISTRATION --%>
            <c:if test="${param.success == 'registered'}">
                <div class="alert alert-success">
                    ✅ Account created successfully! Please login.
                </div>
            </c:if>

            <%-- LOGIN FORM --%>
            <form action="${pageContext.request.contextPath}/user"
                  method="post"
                  class="auth-form"
                  id="loginForm"
                  onsubmit="return validateLoginForm()">

                <input type="hidden" name="action" value="login"/>

                <%-- EMAIL --%>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="${not empty param.email ? param.email : ''}"/>
                    <span class="field-error" id="emailError"></span>
                </div>

                <%-- PASSWORD --%>
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-password-wrap">
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"/>
                        <button type="button"
                                class="toggle-password"
                                onclick="togglePassword('password')">👁</button>
                    </div>
                    <span class="field-error" id="passwordError"></span>
                </div>

                <button type="submit" class="btn-auth">Login</button>

            </form>

            <%-- DIVIDER --%>
            <div class="auth-divider">
                <span>Don't have an account?</span>
            </div>

            <%-- REGISTER LINK --%>
            <a href="${pageContext.request.contextPath}/user?action=registerPage"
               class="btn-auth-outline">
                Create New Account
            </a>

        </div>
    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

    <script>
        // =============================================
        // TOGGLE PASSWORD VISIBILITY
        // =============================================
        function togglePassword(fieldId) {
            const input = document.getElementById(fieldId);
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        // =============================================
        // SHOW / CLEAR FIELD ERROR
        // =============================================
        function showError(fieldId, errorId, message) {
            document.getElementById(fieldId).style.borderColor = '#EF4444';
            document.getElementById(errorId).textContent = message;
        }

        function clearError(fieldId, errorId) {
            document.getElementById(fieldId).style.borderColor = '';
            document.getElementById(errorId).textContent = '';
        }

        // =============================================
        // MAIN FORM VALIDATION
        // =============================================
        function validateLoginForm() {
            let isValid = true;

            // Clear all errors first
            clearError('email',    'emailError');
            clearError('password', 'passwordError');

            // Email validation
            const email = document.getElementById('email').value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email === '') {
                showError('email', 'emailError', '⚠️ Email is required.');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                showError('email', 'emailError', '⚠️ Enter a valid email address.');
                isValid = false;
            }

            // Password validation
            const password = document.getElementById('password').value;
            if (password === '') {
                showError('password', 'passwordError', '⚠️ Password is required.');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'passwordError',
                          '⚠️ Password must be at least 6 characters.');
                isValid = false;
            }

            return isValid;
        }

        // =============================================
        // REAL TIME VALIDATION ON BLUR
        // =============================================
        document.getElementById('email').addEventListener('blur', function() {
            const val = this.value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (val === '') {
                showError('email', 'emailError', '⚠️ Email is required.');
            } else if (!emailRegex.test(val)) {
                showError('email', 'emailError', '⚠️ Enter a valid email address.');
            } else {
                clearError('email', 'emailError');
            }
        });

        document.getElementById('password').addEventListener('blur', function() {
            const val = this.value;
            if (val === '') {
                showError('password', 'passwordError', '⚠️ Password is required.');
            } else if (val.length < 6) {
                showError('password', 'passwordError',
                          '⚠️ Password must be at least 6 characters.');
            } else {
                clearError('password', 'passwordError');
            }
        });
    </script>

</body>
</html>