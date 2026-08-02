<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <%-- SUCCESS / ERROR ALERTS --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <div class="profile-wrapper">

            <%-- PROFILE HEADER --%>
            <div class="profile-header">
                <div class="profile-avatar">👤</div>
                <div class="profile-info">
                    <h2>${user.fullName}</h2>
                    <p>${user.email}</p>
                    <p style="color:var(--primary);font-size:12px;font-weight:600;">
                        <c:choose>
                            <c:when test="${user.admin}">
                                ⚙️ Admin Account
                            </c:when>
                            <c:otherwise>
                                🛍️ Customer Account
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <%-- PROFILE FORM CARD --%>
            <div class="profile-card">
                <h3>Edit Profile</h3>

                <form action="${pageContext.request.contextPath}/user"
                      method="post"
                      class="profile-form"
                      onsubmit="return validateProfileForm()">

                    <input type="hidden" name="action" value="updateProfile"/>

                    <div class="profile-form-row">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text"
                                   id="fullName"
                                   name="fullName"
                                   value="${user.fullName}"
                                   placeholder="Enter full name"
                                   required/>
                            <span class="field-error" id="nameError"></span>
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email"
                                   value="${user.email}"
                                   disabled
                                   style="background:var(--bg-light);
                                          cursor:not-allowed;"/>
                            <small style="font-size:11px;color:var(--text-light);">
                                Email cannot be changed
                            </small>
                        </div>
                    </div>

                    <div class="profile-form-row">
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="tel"
                                   id="phone"
                                   name="phone"
                                   value="${user.phone}"
                                   placeholder="Enter phone number"
                                   maxlength="10"/>
                            <span class="field-error" id="phoneError"></span>
                        </div>
                        <div class="form-group">
                            <label>Member Since</label>
                            <input type="text"
                                   value="${user.createdAt}"
                                   disabled
                                   style="background:var(--bg-light);
                                          cursor:not-allowed;"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Address</label>
                        <textarea id="address"
                                  name="address"
                                  rows="3"
                                  placeholder="Enter your address"
                                  required>${user.address}</textarea>
                        <span class="field-error" id="addressError"></span>
                    </div>

                    <button type="submit" class="btn-profile-save">
                        💾 Save Changes
                    </button>

                </form>
            </div>

            <%-- QUICK LINKS --%>
            <div class="profile-links">
                <a href="${pageContext.request.contextPath}/orders"
                   class="profile-link-btn">
                    📦 My Orders
                </a>
                <a href="${pageContext.request.contextPath}/cart"
                   class="profile-link-btn">
                    🛒 My Cart
                </a>
                <c:if test="${user.admin}">
                    <a href="${pageContext.request.contextPath}/admin"
                       class="profile-link-btn">
                        ⚙️ Admin Panel
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/user?action=logout"
                   class="profile-link-btn danger">
                    🚪 Logout
                </a>
            </div>

        </div>
    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

    <script>
        function showError(fieldId, errorId, message) {
            const field = document.getElementById(fieldId);
            if (field) field.style.borderColor = '#EF4444';
            document.getElementById(errorId).textContent = message;
        }

        function clearError(fieldId, errorId) {
            const field = document.getElementById(fieldId);
            if (field) field.style.borderColor = '';
            document.getElementById(errorId).textContent = '';
        }

        function validateProfileForm() {
            let isValid = true;

            clearError('fullName', 'nameError');
            clearError('phone',    'phoneError');
            clearError('address',  'addressError');

            // Full Name
            const name = document.getElementById('fullName').value.trim();
            if (name === '') {
                showError('fullName', 'nameError',
                          '⚠️ Full name is required.');
                isValid = false;
            } else if (name.length < 3) {
                showError('fullName', 'nameError',
                          '⚠️ Name must be at least 3 characters.');
                isValid = false;
            }

            // Phone — optional but validate if filled
            const phone = document.getElementById('phone').value.trim();
            if (phone !== '') {
                const phoneRegex = /^[6-9]\d{9}$/;
                if (!phoneRegex.test(phone)) {
                    showError('phone', 'phoneError',
                              '⚠️ Enter valid 10 digit mobile number.');
                    isValid = false;
                }
            }

            // Address
            const address = document.getElementById('address').value.trim();
            if (address === '') {
                showError('address', 'addressError',
                          '⚠️ Address is required.');
                isValid = false;
            }

            return isValid;
        }

        // Real time validation
        document.getElementById('fullName').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('fullName', 'nameError', '⚠️ Full name is required.');
            } else if (val.length < 3) {
                showError('fullName', 'nameError',
                          '⚠️ Name must be at least 3 characters.');
            } else {
                clearError('fullName', 'nameError');
            }
        });

        document.getElementById('phone').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val !== '') {
                const phoneRegex = /^[6-9]\d{9}$/;
                if (!phoneRegex.test(val)) {
                    showError('phone', 'phoneError',
                              '⚠️ Enter valid 10 digit mobile number.');
                } else {
                    clearError('phone', 'phoneError');
                }
            }
        });

        document.getElementById('address').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('address', 'addressError', '⚠️ Address is required.');
            } else {
                clearError('address', 'addressError');
            }
        });

        // Allow only numbers in phone
        document.getElementById('phone').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>

</body>
</html>