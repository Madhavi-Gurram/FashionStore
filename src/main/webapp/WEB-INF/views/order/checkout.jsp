<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
</head>
<body>

    <jsp:include page="/WEB-INF/partials/navbar.jsp"/>

    <div class="page-container">

        <div class="page-header">
            <h2 class="page-title">Checkout</h2>
            <p class="page-subtitle">Complete your order</p>
        </div>

        <%-- ERROR --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/orders"
              method="post"
              class="checkout-layout"
              id="checkoutForm"
              onsubmit="return validateCheckoutForm()">

            <input type="hidden" name="action" value="placeOrder"/>

            <%-- LEFT — DELIVERY DETAILS --%>
            <div class="checkout-left">

                <%-- DELIVERY ADDRESS --%>
                <div class="checkout-card">
                    <h3 class="checkout-card-title">
                        📦 Delivery Details
                    </h3>

                    <%-- FULL NAME --%>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text"
                               id="deliveryName"
                               name="deliveryName"
                               placeholder="Enter full name"
                               value="${user.fullName}"/>
                        <span class="field-error" id="nameError"></span>
                    </div>

                    <div class="form-row">

                        <%-- PHONE --%>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="tel"
                                   id="deliveryPhone"
                                   name="deliveryPhone"
                                   placeholder="Enter 10 digit number"
                                   value="${user.phone}"
                                   maxlength="10"/>
                            <span class="field-error" id="phoneError"></span>
                        </div>

                        <%-- PINCODE --%>
                        <div class="form-group">
                            <label>Pincode</label>
                            <input type="text"
                                   id="deliveryPincode"
                                   name="deliveryPincode"
                                   placeholder="Enter 6 digit pincode"
                                   maxlength="6"/>
                            <span class="field-error" id="pincodeError"></span>
                        </div>

                    </div>

                    <%-- ADDRESS --%>
                    <div class="form-group">
                        <label>Address</label>
                        <textarea id="deliveryAddress"
                                  name="deliveryAddress"
                                  placeholder="House no, Street, Area"
                                  rows="3">${user.address}</textarea>
                        <span class="field-error" id="addressError"></span>
                    </div>

                    <div class="form-row">

                        <%-- CITY --%>
                        <div class="form-group">
                            <label>City</label>
                            <input type="text"
                                   id="deliveryCity"
                                   name="deliveryCity"
                                   placeholder="Enter city"/>
                            <span class="field-error" id="cityError"></span>
                        </div>

                        <%-- STATE --%>
                        <div class="form-group">
                            <label>State</label>
                            <input type="text"
                                   id="deliveryState"
                                   name="deliveryState"
                                   placeholder="Enter state"/>
                            <span class="field-error" id="stateError"></span>
                        </div>

                    </div>

                </div>

                <%-- PAYMENT METHOD --%>
                <div class="checkout-card">
                    <h3 class="checkout-card-title">
                        💳 Payment Method
                    </h3>

                    <div class="payment-options">

                        <label class="payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="Cash on Delivery"
                                   checked/>
                            <div class="payment-option-box">
                                <span class="payment-icon">💵</span>
                                <div>
                                    <div class="payment-name">Cash on Delivery</div>
                                    <div class="payment-desc">Pay when your order arrives</div>
                                </div>
                            </div>
                        </label>

                        <label class="payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="UPI"/>
                            <div class="payment-option-box">
                                <span class="payment-icon">📱</span>
                                <div>
                                    <div class="payment-name">UPI</div>
                                    <div class="payment-desc">Pay via UPI apps</div>
                                </div>
                            </div>
                        </label>

                        <label class="payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="Credit/Debit Card"/>
                            <div class="payment-option-box">
                                <span class="payment-icon">💳</span>
                                <div>
                                    <div class="payment-name">Credit / Debit Card</div>
                                    <div class="payment-desc">Visa, Mastercard, Rupay</div>
                                </div>
                            </div>
                        </label>

                        <label class="payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="Net Banking"/>
                            <div class="payment-option-box">
                                <span class="payment-icon">🏦</span>
                                <div>
                                    <div class="payment-name">Net Banking</div>
                                    <div class="payment-desc">All major banks supported</div>
                                </div>
                            </div>
                        </label>

                    </div>
                </div>

            </div>

            <%-- RIGHT — ORDER SUMMARY --%>
            <div class="checkout-right">

                <div class="summary-card">
                    <h3 class="summary-title">Order Summary</h3>

                    <%-- CART ITEMS --%>
                    <div class="checkout-items">
                        <c:forEach var="entry" items="${enrichedItems}">
                            <div class="checkout-item">
                                <img src="${pageContext.request.contextPath}/${entry.product.imageUrl}"
                                     alt="${entry.product.name}"
                                     class="checkout-item-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"/>
                                <div class="checkout-item-info">
                                    <div class="checkout-item-name">${entry.product.name}</div>
                                    <div class="checkout-item-meta">
                                        Size: ${entry.variant.size} ×
                                        ${entry.cartItem.quantity}
                                    </div>
                                </div>
                                <div class="checkout-item-price">
                                    ₹<fmt:formatNumber value="${entry.subtotal}"
                                      pattern="#,##0.00"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<fmt:formatNumber value="${cartTotal}"
                              pattern="#,##0.00"/></span>
                    </div>

                    <div class="summary-row">
                        <span>Shipping</span>
                        <span class="${shipping == 0 ? 'free-shipping' : ''}">
                            <c:choose>
                                <c:when test="${shipping == 0}">FREE</c:when>
                                <c:otherwise>
                                    ₹<fmt:formatNumber value="${shipping}"
                                      pattern="#,##0.00"/>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-row summary-total">
                        <span>Grand Total</span>
                        <span>₹<fmt:formatNumber value="${grandTotal}"
                              pattern="#,##0.00"/></span>
                    </div>

                    <button type="submit" class="btn-checkout">
                        Place Order →
                    </button>

                    <div class="summary-secure">
                        🔒 Your order is safe and secure
                    </div>

                </div>

            </div>

        </form>

    </div>

    <jsp:include page="/WEB-INF/partials/footer.jsp"/>

    <script>
        // =============================================
        // SHOW / CLEAR FIELD ERROR
        // =============================================
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

        // =============================================
        // MAIN CHECKOUT FORM VALIDATION
        // =============================================
        function validateCheckoutForm() {
            let isValid = true;

            // Clear all errors first
            clearError('deliveryName',    'nameError');
            clearError('deliveryPhone',   'phoneError');
            clearError('deliveryPincode', 'pincodeError');
            clearError('deliveryAddress', 'addressError');
            clearError('deliveryCity',    'cityError');
            clearError('deliveryState',   'stateError');

            // Full Name
            const name = document.getElementById('deliveryName').value.trim();
            if (name === '') {
                showError('deliveryName', 'nameError', '⚠️ Full name is required.');
                isValid = false;
            } else if (name.length < 3) {
                showError('deliveryName', 'nameError',
                          '⚠️ Name must be at least 3 characters.');
                isValid = false;
            }

            // Phone — 10 digits starting with 6-9
            const phone = document.getElementById('deliveryPhone').value.trim();
            const phoneRegex = /^[6-9]\d{9}$/;
            if (phone === '') {
                showError('deliveryPhone', 'phoneError',
                          '⚠️ Phone number is required.');
                isValid = false;
            } else if (!phoneRegex.test(phone)) {
                showError('deliveryPhone', 'phoneError',
                          '⚠️ Enter valid 10 digit Indian mobile number.');
                isValid = false;
            }

            // Pincode — exactly 6 digits
            const pincode = document.getElementById('deliveryPincode').value.trim();
            const pincodeRegex = /^[1-9][0-9]{5}$/;
            if (pincode === '') {
                showError('deliveryPincode', 'pincodeError',
                          '⚠️ Pincode is required.');
                isValid = false;
            } else if (!pincodeRegex.test(pincode)) {
                showError('deliveryPincode', 'pincodeError',
                          '⚠️ Enter valid 6 digit pincode.');
                isValid = false;
            }

            // Address
            const address = document.getElementById('deliveryAddress').value.trim();
            if (address === '') {
                showError('deliveryAddress', 'addressError',
                          '⚠️ Address is required.');
                isValid = false;
            } else if (address.length < 10) {
                showError('deliveryAddress', 'addressError',
                          '⚠️ Please enter a complete address.');
                isValid = false;
            }

            // City
            const city = document.getElementById('deliveryCity').value.trim();
            if (city === '') {
                showError('deliveryCity', 'cityError',
                          '⚠️ City is required.');
                isValid = false;
            }

            // State
            const state = document.getElementById('deliveryState').value.trim();
            if (state === '') {
                showError('deliveryState', 'stateError',
                          '⚠️ State is required.');
                isValid = false;
            }

            // Scroll to first error
            if (!isValid) {
                const firstError = document.querySelector('.field-error:not(:empty)');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }

            return isValid;
        }

        // =============================================
        // REAL TIME VALIDATION ON BLUR
        // =============================================
        document.getElementById('deliveryName').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('deliveryName', 'nameError', '⚠️ Full name is required.');
            } else if (val.length < 3) {
                showError('deliveryName', 'nameError',
                          '⚠️ Name must be at least 3 characters.');
            } else {
                clearError('deliveryName', 'nameError');
            }
        });

        document.getElementById('deliveryPhone').addEventListener('blur', function() {
            const val = this.value.trim();
            const phoneRegex = /^[6-9]\d{9}$/;
            if (val === '') {
                showError('deliveryPhone', 'phoneError',
                          '⚠️ Phone number is required.');
            } else if (!phoneRegex.test(val)) {
                showError('deliveryPhone', 'phoneError',
                          '⚠️ Enter valid 10 digit Indian mobile number.');
            } else {
                clearError('deliveryPhone', 'phoneError');
            }
        });

        document.getElementById('deliveryPincode').addEventListener('blur', function() {
            const val = this.value.trim();
            const pincodeRegex = /^[1-9][0-9]{5}$/;
            if (val === '') {
                showError('deliveryPincode', 'pincodeError',
                          '⚠️ Pincode is required.');
            } else if (!pincodeRegex.test(val)) {
                showError('deliveryPincode', 'pincodeError',
                          '⚠️ Enter valid 6 digit pincode.');
            } else {
                clearError('deliveryPincode', 'pincodeError');
            }
        });

        document.getElementById('deliveryAddress').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('deliveryAddress', 'addressError',
                          '⚠️ Address is required.');
            } else if (val.length < 10) {
                showError('deliveryAddress', 'addressError',
                          '⚠️ Please enter a complete address.');
            } else {
                clearError('deliveryAddress', 'addressError');
            }
        });

        document.getElementById('deliveryCity').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('deliveryCity', 'cityError', '⚠️ City is required.');
            } else {
                clearError('deliveryCity', 'cityError');
            }
        });

        document.getElementById('deliveryState').addEventListener('blur', function() {
            const val = this.value.trim();
            if (val === '') {
                showError('deliveryState', 'stateError', '⚠️ State is required.');
            } else {
                clearError('deliveryState', 'stateError');
            }
        });

        // Allow only numbers in phone and pincode fields
        document.getElementById('deliveryPhone').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        document.getElementById('deliveryPincode').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>

</body>
</html>