<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.CartItem" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal shipping = (BigDecimal) request.getAttribute("shipping");
    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
    String error = (String) request.getAttribute("error");

    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (shipping == null) shipping = BigDecimal.ZERO;
    if (grandTotal == null) grandTotal = BigDecimal.ZERO;

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.8">
    <style>
        body {
            background-color: var(--bg);
        }

        .checkout-wrapper {
            padding: 3.5rem 0 6rem;
            position: relative;
        }

        .checkout-page-title {
            font-family: var(--font-heading);
            font-size: clamp(2rem, 4vw, 2.8rem);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.01em;
            line-height: 1.1;
            color: var(--heading);
            background: var(--heading-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 2rem;
        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr 390px;
            gap: 2.5rem;
            align-items: start;
        }

        @media (max-width: 960px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
        }

        .checkout-section {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            padding: 2.2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-soft);
        }

        .checkout-section-title {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.01em;
            line-height: 1.1;
            margin-bottom: 1.75rem;
            display: flex;
            align-items: center;
            gap: 0.65rem;
            color: var(--heading);
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--divider);
        }

        .checkout-input {
            width: 100%;
            background: var(--color-surface-container-low);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-md);
            padding: 0.85rem 1rem;
            color: var(--color-on-surface);
            font-family: var(--font-body);
            font-size: 14px;
            outline: none;
            transition: all 200ms ease;
            opacity: 1;
        }

        .checkout-input:focus {
            border-color: rgba(255, 255, 255, 0.35);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.06);
            color: #ffffff;
        }

        .checkout-input::placeholder {
            color: rgba(184, 190, 199, 0.38);
            opacity: 1;
        }

        /* Payment Methods */
        .payment-method-card {
            border: 1px solid var(--surface-border);
            border-radius: 12px;
            padding: 1.1rem 1.35rem;
            margin-bottom: 0.9rem;
            cursor: pointer;
            transition: all 200ms ease;
            display: flex;
            align-items: center;
            gap: 1rem;
            background-color: var(--pill-inactive-bg);
            user-select: none;
        }

        .payment-method-card:hover {
            background-color: #1e222d;
            border-color: rgba(255, 255, 255, 0.14);
            transform: translateY(-1px);
        }

        .payment-method-card input[type="radio"] {
            accent-color: var(--btn-bg);
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .payment-method-card:has(input[type="radio"]:checked) {
            border-color: var(--btn-bg);
            background: #1c202a;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.5);
        }

        .payment-method-label {
            flex: 1;
            font-size: 14px;
            color: #ffffff;
            cursor: pointer;
        }

        /* Summary Card */
        .summary-card {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            padding: 2.2rem;
            box-shadow: var(--shadow-soft);
        }

        .summary-card-title {
            font-family: var(--font-heading);
            font-size: 1.25rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.01em;
            line-height: 1.1;
            color: var(--heading);
            margin-bottom: 1.5rem;
        }

        .summary-item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.9rem;
            font-size: 14px;
            padding-bottom: 0.8rem;
            border-bottom: 1px solid var(--divider);
        }

        .summary-calc-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 14px;
            color: var(--text);
        }

        .summary-calc-row.total {
            font-family: var(--font-heading);
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--price);
            border-top: 1px solid var(--divider);
            padding-top: 1.25rem;
            margin-top: 1.25rem;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container checkout-wrapper">
    <h1 class="checkout-page-title">Secure Checkout</h1>

    <% if (error != null) { %>
        <div class="alert-box alert-box-error" style="margin-bottom: 2rem;">
            <span class="material-symbols-outlined">warning</span>
            <span><%= error %></span>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkout-form">
        <div class="checkout-layout">

            <div>
                <!-- 1. Shipping Address Section -->
                <div class="checkout-section">
                    <div class="checkout-section-title">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem;">local_shipping</span>
                        <span>1. Shipping Address</span>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; margin-bottom: 1.25rem;">
                        <div>
                            <label class="form-label" for="fullName">Recipient Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="checkout-input" value="<%= sessionUser != null ? sessionUser.getName() : "" %>" placeholder="Your full name" required>
                        </div>
                        <div>
                            <label class="form-label" for="phone">Contact Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="checkout-input" placeholder="+91 98765 43210" required>
                        </div>
                    </div>

                    <div style="margin-bottom: 1.25rem;">
                        <label class="form-label" for="street">Street Address & Flat / House No.</label>
                        <input type="text" id="street" name="street" class="checkout-input" placeholder="e.g. 42, Green Avenue, Anna Nagar" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1.25rem;">
                        <div>
                            <label class="form-label" for="city">City</label>
                            <input type="text" id="city" name="city" class="checkout-input" placeholder="Chennai" required>
                        </div>
                        <div>
                            <label class="form-label" for="state">State</label>
                            <input type="text" id="state" name="state" class="checkout-input" placeholder="Tamil Nadu" required>
                        </div>
                        <div>
                            <label class="form-label" for="pincode">PIN Code</label>
                            <input type="text" id="pincode" name="pincode" class="checkout-input" placeholder="600025" required>
                        </div>
                    </div>
                </div>

                <!-- 2. Payment Method Section -->
                <div class="checkout-section">
                    <div class="checkout-section-title">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem;">credit_card</span>
                        <span>2. Mock Payment Confirmation</span>
                    </div>

                    <label class="payment-method-card" for="pay-card">
                        <input type="radio" id="pay-card" name="paymentMethod" value="CARD" checked>
                        <div class="payment-method-label">
                            <strong>Mock Credit / Debit Card</strong> (Instant simulated confirmation)
                        </div>
                    </label>

                    <label class="payment-method-card" for="pay-upi">
                        <input type="radio" id="pay-upi" name="paymentMethod" value="UPI">
                        <div class="payment-method-label">
                            <strong>Mock UPI / QR</strong> (GPay / PhonePe / Paytm mock)
                        </div>
                    </label>

                    <label class="payment-method-card" for="pay-cod">
                        <input type="radio" id="pay-cod" name="paymentMethod" value="COD">
                        <div class="payment-method-label">
                            <strong>Cash on Delivery (COD)</strong> (Pay on physical delivery)
                        </div>
                    </label>

                </div>
            </div>

            <!-- Right: Order Summary -->
            <div class="summary-card">
                <h2 class="summary-card-title">Order Items (<%= cartItems != null ? cartItems.size() : 0 %>)</h2>

                <div style="max-height: 280px; overflow-y: auto; margin-bottom: 1.5rem; padding-right: 0.5rem;">
                    <% if (cartItems != null) { %>
                        <% for (CartItem item : cartItems) {
                            Product p = item.getProduct();
                        %>
                            <div class="summary-item-row">
                                <div style="flex: 1; padding-right: 0.5rem;">
                                    <div style="font-weight: 700; color: #ffffff;"><%= p != null ? p.getName() : "Item" %></div>
                                    <div style="font-size: 0.8rem; color: var(--color-on-surface-variant); margin-top: 0.15rem;">Qty: <%= item.getQuantity() %></div>
                                </div>
                                <div style="font-weight: 700; color: #ffffff;">
                                    <%= currencyFormat.format(item.getItemTotal()) %>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>

                <div style="border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 1.2rem;">
                    <div class="summary-calc-row">
                        <span>Subtotal</span>
                        <span style="font-weight: 700; color: #ffffff;"><%= currencyFormat.format(subtotal) %></span>
                    </div>

                    <div class="summary-calc-row">
                        <span>Shipping</span>
                        <span style="font-weight: 700;">
                            <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                                <span style="color: #C8B196;">FREE</span>
                            <% } else { %>
                                <span style="color: #ffffff;"><%= currencyFormat.format(shipping) %></span>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-calc-row total">
                        <span>Total Payable</span>
                        <span><%= currencyFormat.format(grandTotal) %></span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-pill" style="width: 100%; padding: 1rem; font-size: 1rem; margin-top: 1.8rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                    <span class="material-symbols-outlined" style="font-size: 1.2rem;">verified_user</span>
                    <span>Confirm & Place Order</span>
                </button>
            </div>
        </div>
    </form>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
