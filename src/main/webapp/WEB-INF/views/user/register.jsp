<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">
    <style>
        .auth-form .form-group { margin: 0; gap: 3px; }
        .auth-form { gap: 7px; }
        .field-error { min-height: 0; font-size: 11px; }
        .auth-card { padding: 24px 32px; }
        .auth-title { font-size: 18px; margin-bottom: 2px; }
        .auth-subtitle { font-size: 12px; margin-bottom: 14px; }
        .auth-logo { margin-bottom: 8px; }
        .password-strength { margin-top: 3px; }
        .strength-bar { height: 3px; }
        .auth-divider { margin: 10px 0 8px; }
        .form-group input,
        .form-group textarea,
        .form-group select {
            padding: 8px 12px;
            font-size: 13px;
        }
        .form-group textarea {
            min-height: 55px;
            rows: 2;
        }
        .form-group label { font-size: 12px; }
        .btn-auth { padding: 10px; margin-top: 4px; }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="auth-wrapper">
        <div class="auth-card">

            <div class="auth-logo">
                <a href="${pageContext.request.contextPath}/home">
                    Fashion<span>Store</span>
                </a>
            </div>

            <h2 class="auth-title">Create Account</h2>
            <p class="auth-subtitle">Join FashionStore and start shopping today</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠️ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user"
                  method="post"
                  class="auth-form"
                  id="registerForm"
                  onsubmit="return validateRegisterForm()">

                <input type="hidden" name="action" value="register"/>

                <%-- FULL NAME --%>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           placeholder="Enter your full name"
                           value="${not empty param.fullName ? param.fullName : ''}"/>
                    <span class="field-error" id="nameError"></span>
                </div>

                <%-- EMAIL --%>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="${not empty param.email ? param.email : ''}"/>
                    <span class="field-error" id="emailError"></span>
                </div>

                <%-- PHONE --%>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           placeholder="Enter 10 digit phone number"
                           value="${not empty param.phone ? param.phone : ''}"
                           maxlength="10"/>
                    <span class="field-error" id="phoneError"></span>
                </div>

                <%-- ADDRESS --%>
                <div class="form-group">
                    <label>Address</label>
                    <textarea id="address"
                              name="address"
                              placeholder="Enter your full address"
                              rows="2">${not empty param.address ? param.address : ''}</textarea>
                    <span class="field-error" id="addressError"></span>
                </div>

                <%-- PASSWORD --%>
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-password-wrap">
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Min 6 characters"
                               oninput="checkPasswordStrength(this.value)"/>
                        <button type="button"
                                class="toggle-password"
                                onclick="togglePassword('password')">👁</button>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <span class="strength-label" id="strengthLabel"></span>
                    </div>
                    <span class="field-error" id="passwordError"></span>
                </div>

                <%-- CONFIRM PASSWORD --%>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="input-password-wrap">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Re-enter your password"
                               oninput="checkPasswordMatch()"/>
                        <button type="button"
                                class="toggle-password"
                                onclick="togglePassword('confirmPassword')">👁</button>
                    </div>
                    <span class="field-error" id="confirmError"></span>
                </div>

                <button type="submit" class="btn-auth">
                    Create Account
                </button>

            </form>

            <div class="auth-divider">
                <span>Already have an account?</span>
            </div>

            <a href="${pageContext.request.contextPath}/user?action=loginPage"
               class="btn-auth-outline">
                Login to Your Account
            </a>

        </div>
    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

    <script>
        function togglePassword(fieldId) {
            const input = document.getElementById(fieldId);
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        function checkPasswordStrength(password) {
            const fill  = document.getElementById('strengthFill');
            const label = document.getElementById('strengthLabel');
            let strength = 0;
            if (password.length >= 6)            strength++;
            if (password.length >= 10)           strength++;
            if (/[A-Z]/.test(password))          strength++;
            if (/[0-9]/.test(password))          strength++;
            if (/[^A-Za-z0-9]/.test(password))  strength++;
            const levels = [
                { label: '',            color: '',        width: '0%'   },
                { label: 'Very Weak',   color: '#EF4444', width: '20%'  },
                { label: 'Weak',        color: '#F97316', width: '40%'  },
                { label: 'Fair',        color: '#F59E0B', width: '60%'  },
                { label: 'Strong',      color: '#10B981', width: '80%'  },
                { label: 'Very Strong', color: '#059669', width: '100%' }
            ];
            const level = levels[strength];
            fill.style.width           = level.width;
            fill.style.backgroundColor = level.color;
            label.textContent          = level.label;
            label.style.color          = level.color;
        }

        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirm  = document.getElementById('confirmPassword').value;
            const error    = document.getElementById('confirmError');
            if (confirm === '') { error.textContent = ''; return; }
            if (password !== confirm) {
                error.textContent = '❌ Passwords do not match!';
                error.style.color = 'var(--error)';
            } else {
                error.textContent = '✅ Passwords match!';
                error.style.color = 'var(--success)';
            }
        }

        function showError(fieldId, errorId, message) {
            const f = document.getElementById(fieldId);
            if (f) f.style.borderColor = '#EF4444';
            document.getElementById(errorId).textContent = message;
        }

        function clearError(fieldId, errorId) {
            const f = document.getElementById(fieldId);
            if (f) f.style.borderColor = '';
            document.getElementById(errorId).textContent = '';
        }

        function validateRegisterForm() {
            let isValid = true;
            clearError('fullName',        'nameError');
            clearError('email',           'emailError');
            clearError('phone',           'phoneError');
            clearError('address',         'addressError');
            clearError('password',        'passwordError');
            clearError('confirmPassword', 'confirmError');

            const fullName = document.getElementById('fullName').value.trim();
            if (fullName === '') {
                showError('fullName', 'nameError', '⚠️ Full name is required.');
                isValid = false;
            } else if (fullName.length < 3) {
                showError('fullName', 'nameError',
                          '⚠️ Name must be at least 3 characters.');
                isValid = false;
            }

            const email = document.getElementById('email').value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email === '') {
                showError('email', 'emailError', '⚠️ Email is required.');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                showError('email', 'emailError', '⚠️ Enter a valid email address.');
                isValid = false;
            }

            const phone = document.getElementById('phone').value.trim();
            const phoneRegex = /^[6-9]\d{9}$/;
            if (phone === '') {
                showError('phone', 'phoneError', '⚠️ Phone number is required.');
                isValid = false;
            } else if (!phoneRegex.test(phone)) {
                showError('phone', 'phoneError',
                          '⚠️ Enter valid 10 digit mobile number.');
                isValid = false;
            }

            const address = document.getElementById('address').value.trim();
            if (address === '') {
                showError('address', 'addressError', '⚠️ Address is required.');
                isValid = false;
            }

            const password = document.getElementById('password').value;
            if (password === '') {
                showError('password', 'passwordError', '⚠️ Password is required.');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'passwordError',
                          '⚠️ Password must be at least 6 characters.');
                isValid = false;
            }

            const confirmPassword = document.getElementById('confirmPassword').value;
            if (confirmPassword === '') {
                showError('confirmPassword', 'confirmError',
                          '⚠️ Please confirm your password.');
                isValid = false;
            } else if (password !== confirmPassword) {
                showError('confirmPassword', 'confirmError',
                          '⚠️ Passwords do not match!');
                isValid = false;
            }

            return isValid;
        }

        document.getElementById('phone').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>

</body>
</html>