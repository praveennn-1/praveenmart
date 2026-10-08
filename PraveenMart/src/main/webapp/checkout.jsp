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
            background-color: #000000;
        }

        .checkout-wrapper {
            padding: 3rem 0 6rem;
            position: relative;
        }

        .checkout-page-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: -0.03em;
            line-height: 1.15;
            color: #FFFFFF;
            margin-bottom: 0.5rem;
        }

        .checkout-page-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #888888;
            margin-bottom: 2.5rem;
        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
            align-items: start;
        }

        @media (max-width: 960px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
        }

        .checkout-section {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
            margin-bottom: 1.5rem;
        }

        .checkout-section-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 1.15rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.65rem;
            color: #FFFFFF;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #1E1E22;
        }

        .checkout-input {
            width: 100%;
            height: 42px;
            background: #000000;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0 0.85rem;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            outline: none;
            transition: border-color 150ms ease, background 150ms ease;
            box-sizing: border-box;
        }

        .checkout-input:focus {
            border-color: #FFFFFF;
            background: #0A0A0A;
        }

        .checkout-input::placeholder {
            color: #52525B;
        }

        /* Payment Methods */
        .payment-method-card {
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0.95rem 1.15rem;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: all 150ms ease;
            display: flex;
            align-items: center;
            gap: 0.85rem;
            background-color: #000000;
            user-select: none;
        }

        .payment-method-card:hover {
            background-color: #0A0A0A;
            border-color: #3F3F46;
        }

        .payment-method-card input[type="radio"] {
            accent-color: #FFFFFF;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .payment-method-card:has(input[type="radio"]:checked) {
            border-color: #FFFFFF;
            background: #0C0C0C;
        }

        .payment-method-label {
            flex: 1;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #FFFFFF;
            cursor: pointer;
        }

        .payment-method-label span {
            color: #71717A;
            font-size: 0.78rem;
        }

        /* Summary Card */
        .summary-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
        }

        .summary-card-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 1.15rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #FFFFFF;
            margin-bottom: 1.5rem;
        }

        .summary-item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #1E1E22;
        }

        .summary-calc-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            color: #A1A1AA;
        }

        .summary-calc-row.total {
            font-size: 1.15rem;
            font-weight: 700;
            color: #FFFFFF;
            border-top: 1px solid #1E1E22;
            padding-top: 1rem;
            margin-top: 1rem;
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

                <div style="border-top: 1px solid #1E1E22; padding-top: 1.2rem;">
                    <div class="summary-calc-row">
                        <span>Subtotal</span>
                        <span style="font-weight: 700; color: #FFFFFF;"><%= currencyFormat.format(subtotal) %></span>
                    </div>

                    <div class="summary-calc-row">
                        <span>Shipping</span>
                        <span style="font-weight: 700;">
                            <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                                <span style="color: #A1A1AA;">FREE</span>
                            <% } else { %>
                                <span style="color: #FFFFFF;"><%= currencyFormat.format(shipping) %></span>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-calc-row total">
                        <span>Total Payable</span>
                        <span><%= currencyFormat.format(grandTotal) %></span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.85rem; font-size: 0.92rem; margin-top: 1.5rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                    <span class="material-symbols-outlined" style="font-size: 1.1rem;">verified_user</span>
                    <span>Confirm & Place Order</span>
                </button>
            </div>
        </div>
    </form>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
