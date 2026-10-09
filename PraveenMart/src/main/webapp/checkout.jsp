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
    if (subtotal == null) subtotal = BigDecimal.ZERO;
    BigDecimal shipping = BigDecimal.ZERO;
    BigDecimal grandTotal = subtotal;
    String error = (String) request.getAttribute("error");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=6.2">
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

        /* Payment Method Options */
        .payment-method-card {
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 1rem 1.15rem;
            margin-bottom: 0.5rem;
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
            width: 18px;
            height: 18px;
            cursor: pointer;
            flex-shrink: 0;
        }

        .payment-method-card:has(input[type="radio"]:checked) {
            border-color: #FFFFFF;
            background: #0C0C0C;
        }

        .payment-method-label {
            flex: 1;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            color: #FFFFFF;
            cursor: pointer;
            line-height: 1.4;
        }

        .payment-method-label small {
            display: block;
            color: #71717A;
            font-size: 0.76rem;
            margin-top: 0.15rem;
        }

        /* Payment Detail Expandable Panel */
        .payment-detail-panel {
            overflow: hidden;
            max-height: 0;
            transition: max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1),
                        opacity 0.25s ease,
                        padding 0.25s ease;
            opacity: 0;
            background: #030303;
            border: 1px solid transparent;
            border-radius: 4px;
            margin-bottom: 0.75rem;
            padding: 0 1.25rem;
        }

        .payment-detail-panel.active {
            max-height: 800px;
            opacity: 1;
            padding: 1.35rem 1.25rem;
            border-color: #27272A;
        }

        .panel-label {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.72rem;
            color: #A1A1AA;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
            display: block;
        }

        .panel-input {
            width: 100%;
            height: 42px;
            background: #000000;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0 0.85rem;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.9rem;
            outline: none;
            box-sizing: border-box;
            transition: border-color 150ms ease, background 150ms ease;
        }

        .panel-input:focus {
            border-color: #FFFFFF;
            background: #0A0A0A;
        }

        .panel-input::placeholder {
            color: #3F3F46;
        }

        /* Mock Credit/Debit Card Visual Preview */
        .card-visual-preview {
            background: linear-gradient(135deg, #141414 0%, #202024 50%, #0d0d0f 100%);
            border: 1px solid #333338;
            border-radius: 12px;
            padding: 1.35rem 1.5rem;
            margin-bottom: 1.25rem;
            position: relative;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            overflow: hidden;
        }

        .card-visual-preview::after {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
            pointer-events: none;
        }

        .card-preview-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .card-chip-icon {
            width: 36px;
            height: 26px;
            background: linear-gradient(135deg, #e0aa3e 0%, #f7d070 50%, #b8860b 100%);
            border-radius: 4px;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.3);
            position: relative;
        }

        .card-chip-icon::after {
            content: '';
            position: absolute;
            top: 6px;
            left: 0;
            right: 0;
            height: 14px;
            border-top: 1px solid rgba(0,0,0,0.25);
            border-bottom: 1px solid rgba(0,0,0,0.25);
        }

        .card-brand-badge {
            font-family: var(--font-heading, sans-serif);
            font-size: 0.95rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            color: #FFFFFF;
            text-transform: uppercase;
        }

        .card-preview-number {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.25rem;
            letter-spacing: 0.18em;
            color: #FFFFFF;
            margin-bottom: 1.2rem;
            word-spacing: 0.25em;
        }

        .card-preview-bottom {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
        }

        .card-preview-holder .val {
            font-size: 0.85rem;
            color: #FFFFFF;
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        .card-preview-holder .lbl,
        .card-preview-expiry .lbl {
            font-size: 0.65rem;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 2px;
        }

        .card-preview-expiry .val {
            font-size: 0.85rem;
            color: #FFFFFF;
            font-weight: 600;
        }

        .quick-fill-btn {
            background: #111113;
            border: 1px solid #27272A;
            color: #A1A1AA;
            border-radius: 4px;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            padding: 0.35rem 0.65rem;
            cursor: pointer;
            transition: all 120ms ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .quick-fill-btn:hover {
            background: #1E1E22;
            color: #FFFFFF;
            border-color: #3F3F46;
        }

        /* UPI App Selector */
        .upi-app-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.6rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 600px) {
            .upi-app-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .upi-app-card {
            border: 1px solid #27272A;
            border-radius: 6px;
            padding: 0.75rem 0.5rem;
            background: #000000;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.4rem;
            transition: all 150ms ease;
            font-family: var(--font-mono);
            font-size: 0.75rem;
            color: #A1A1AA;
            user-select: none;
        }

        .upi-app-card:hover {
            border-color: #3F3F46;
            background: #0A0A0A;
            color: #FFFFFF;
        }

        .upi-app-card.active {
            border-color: #FFFFFF;
            background: #111113;
            color: #FFFFFF;
            box-shadow: 0 0 0 1px #FFFFFF;
        }

        .upi-app-logo {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.8rem;
        }

        .logo-gpay   { background: #1a73e8; color: #fff; }
        .logo-phonepe{ background: #5f259f; color: #fff; }
        .logo-paytm  { background: #00b9f5; color: #002e6e; }
        .logo-bhim   { background: #00796b; color: #fff; }

        .panel-divider {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin: 1.1rem 0;
            color: #52525B;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .panel-divider::before,
        .panel-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #1E1E22;
        }

        .upi-input-group {
            display: flex;
            gap: 0.5rem;
            align-items: stretch;
        }

        .upi-verify-action-btn {
            height: 42px;
            padding: 0 1.25rem;
            background: #FFFFFF;
            color: #000000;
            border: none;
            border-radius: 4px;
            font-family: var(--font-mono);
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
            transition: background 150ms ease;
            flex-shrink: 0;
        }

        .upi-verify-action-btn:hover {
            background: #E4E4E7;
        }

        .upi-status-msg {
            margin-top: 0.5rem;
            font-family: var(--font-mono);
            font-size: 0.78rem;
            min-height: 1.2em;
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .upi-status-msg.success {
            color: #FFFFFF;
        }

        .upi-status-msg.error {
            color: #EF4444;
        }

        .upi-qr-toggle-btn {
            background: transparent;
            border: 1px dashed #27272A;
            color: #A1A1AA;
            border-radius: 4px;
            padding: 0.55rem 0.85rem;
            font-family: var(--font-mono);
            font-size: 0.76rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            margin-top: 0.85rem;
            transition: all 120ms ease;
        }

        .upi-qr-toggle-btn:hover {
            border-color: #FFFFFF;
            color: #FFFFFF;
        }

        .qr-box {
            display: none;
            margin-top: 0.9rem;
            background: #000000;
            border: 1px solid #27272A;
            border-radius: 6px;
            padding: 1.25rem;
            text-align: center;
        }

        .qr-box.visible {
            display: block;
        }

        /* COD Notice */
        .cod-notice-card {
            background: #000000;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 1.15rem 1.25rem;
            display: flex;
            align-items: flex-start;
            gap: 0.85rem;
            font-family: var(--font-mono);
            font-size: 0.82rem;
            color: #A1A1AA;
            line-height: 1.5;
        }

        .security-badge {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            margin-top: 1rem;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            color: #52525B;
        }

        .security-badge .material-symbols-outlined {
            font-size: 0.95rem;
            color: #71717A;
        }

        /* Order Summary */
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

        .form-row-2col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
            margin-bottom: 1.25rem;
        }

        .form-row-3col {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1.25rem;
        }

        /* Mobile Screen Responsiveness */
        @media (max-width: 640px) {
            .checkout-wrapper {
                padding: 1.25rem 0 3.5rem;
                width: 100%;
                max-width: 100%;
                overflow-x: hidden;
                box-sizing: border-box;
            }
            .checkout-page-title {
                font-size: 1.45rem;
                letter-spacing: -0.02em;
            }
            .checkout-page-subtitle {
                font-size: 0.78rem;
                margin-bottom: 1.5rem;
            }
            .checkout-section {
                padding: 1.1rem;
                margin-bottom: 1rem;
                width: 100%;
                max-width: 100%;
                box-sizing: border-box;
            }
            .checkout-section-title {
                font-size: 1rem;
                margin-bottom: 1rem;
            }
            .checkout-input {
                height: 40px;
                font-size: 0.82rem;
            }
            .form-row-2col {
                grid-template-columns: 1fr;
                gap: 0.85rem;
                margin-bottom: 0.85rem;
            }
            .form-row-3col {
                grid-template-columns: 1fr;
                gap: 0.85rem;
            }
            .payment-method-card {
                padding: 0.75rem 0.85rem;
            }
            .payment-method-label {
                font-size: 0.82rem;
            }
            .payment-method-label small {
                font-size: 0.72rem;
            }
            .payment-detail-panel.active {
                padding: 1rem 0.85rem;
            }
            .card-visual-preview {
                padding: 1rem 1.1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
            }
            .card-preview-top {
                margin-bottom: 1.1rem;
            }
            .card-chip-icon {
                width: 28px;
                height: 20px;
            }
            .card-brand-badge {
                font-size: 0.8rem;
            }
            .card-preview-number {
                font-size: 0.96rem;
                letter-spacing: 0.12em;
                word-spacing: 0.12em;
                margin-bottom: 0.85rem;
            }
            .card-preview-holder .val,
            .card-preview-expiry .val {
                font-size: 0.75rem;
            }
            .panel-input {
                height: 40px;
                font-size: 0.84rem;
            }
            .upi-app-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 0.45rem;
            }
            .upi-app-card {
                padding: 0.55rem 0.35rem;
                font-size: 0.7rem;
            }
            .summary-card {
                padding: 1.15rem;
            }
            .summary-card-title {
                font-size: 1rem;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container checkout-wrapper">
    <h1 class="checkout-page-title">Secure Checkout</h1>
    <div class="checkout-page-subtitle">Complete your shipping &amp; simulated payment</div>

    <% if (error != null) { %>
        <div class="alert-box alert-box-error" style="margin-bottom: 2rem;">
            <span class="material-symbols-outlined">warning</span>
            <span><%= error %></span>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkout-form">
        <div class="checkout-layout">

            <div>
                <!-- ── 1. Shipping Address ───────────────────────────────── -->
                <div class="checkout-section">
                    <div class="checkout-section-title">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem;">local_shipping</span>
                        <span>1. Shipping Address</span>
                    </div>

                    <% 
                        boolean hasSavedAddress = (sessionUser != null && sessionUser.hasDefaultAddress());
                        String prefillName = (sessionUser != null && sessionUser.getRecipientName() != null && !sessionUser.getRecipientName().isBlank())
                                ? sessionUser.getRecipientName()
                                : (sessionUser != null && sessionUser.getName() != null ? sessionUser.getName() : "");
                        String prefillPhone = (sessionUser != null && sessionUser.getPhone() != null) ? sessionUser.getPhone() : "";
                        String prefillStreet = (sessionUser != null && sessionUser.getStreet() != null) ? sessionUser.getStreet() : "";
                        String prefillCity = (sessionUser != null && sessionUser.getCity() != null) ? sessionUser.getCity() : "";
                        String prefillState = (sessionUser != null && sessionUser.getState() != null) ? sessionUser.getState() : "";
                        String prefillPincode = (sessionUser != null && sessionUser.getPincode() != null) ? sessionUser.getPincode() : "";
                    %>

                    <div class="address-account-sync-banner" id="addressSyncBanner" style="display: flex; align-items: center; justify-content: space-between; gap: 0.75rem; flex-wrap: wrap; width: 100%; box-sizing: border-box; background: #0A0A0C; border: 1px solid #27272A; border-radius: 4px; padding: 0.8rem 1rem; margin-bottom: 1.25rem;">
                        <div style="display: flex; align-items: center; gap: 0.65rem;">
                            <span class="material-symbols-outlined" id="syncIcon" style="font-size: 1.2rem; color: <%= hasSavedAddress ? "#FFFFFF" : "#A1A1AA" %>;">
                                <%= hasSavedAddress ? "verified_user" : "bookmark_add" %>
                            </span>
                            <div style="font-family: var(--font-mono); font-size: 0.78rem; line-height: 1.4;">
                                <strong id="syncTitle" style="color: #FFFFFF;"><%= hasSavedAddress ? "Default Account Address Loaded" : "Automatic Account Address Sync" %></strong>
                                <span id="syncDesc" style="color: #888888; display: block;"><%= hasSavedAddress ? "Pre-filled from your account. Any details entered will automatically update your account default." : "Any address entered below will automatically be saved as default in your account." %></span>
                            </div>
                        </div>
                        <span id="saveStatusIndicator" style="font-family: var(--font-mono); font-size: 0.72rem; color: #FFFFFF; background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.25); padding: 2px 8px; border-radius: 3px; display: none;">Saved</span>
                    </div>

                    <div class="form-row-2col">
                        <div>
                            <label class="form-label" for="fullName">Recipient Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="checkout-input address-field"
                                   value="<%= prefillName %>"
                                   placeholder="Your full name" required>
                        </div>
                        <div>
                            <label class="form-label" for="phone">Contact Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="checkout-input address-field"
                                   value="<%= prefillPhone %>"
                                   placeholder="+91 98765 43210" required>
                        </div>
                    </div>

                    <div style="margin-bottom: 1.25rem;">
                        <label class="form-label" for="street">Street Address &amp; Flat / House No.</label>
                        <input type="text" id="street" name="street" class="checkout-input address-field"
                               value="<%= prefillStreet %>"
                               placeholder="e.g. 42, Green Avenue, Anna Nagar" required>
                    </div>

                    <div class="form-row-3col">
                        <div>
                            <label class="form-label" for="city">City</label>
                            <input type="text" id="city" name="city" class="checkout-input address-field"
                                   value="<%= prefillCity %>"
                                   placeholder="Chennai" required>
                        </div>
                        <div>
                            <label class="form-label" for="state">State</label>
                            <input type="text" id="state" name="state" class="checkout-input address-field"
                                   value="<%= prefillState %>"
                                   placeholder="Tamil Nadu" required>
                        </div>
                        <div>
                            <label class="form-label" for="pincode">PIN Code</label>
                            <input type="text" id="pincode" name="pincode" class="checkout-input address-field"
                                   value="<%= prefillPincode %>"
                                   placeholder="600025" required>
                        </div>
                    </div>
                </div>              </div>
                    </div>
                </div>

                <!-- ── 2. Payment Method ────────────────────────────────── -->
                <div class="checkout-section">
                    <div class="checkout-section-title">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem;">payments</span>
                        <span>2. Payment Method</span>
                    </div>

                    <!-- Option A: Credit / Debit Card -->
                    <label class="payment-method-card" for="pay-card">
                        <input type="radio" id="pay-card" name="paymentMethod" value="CARD" checked>
                        <div class="payment-method-label">
                            <strong>Mock Credit / Debit Card</strong>
                            <small>Visa, Mastercard, RuPay, Amex — Simulated instant confirmation</small>
                        </div>
                        <span class="material-symbols-outlined" style="color: #A1A1AA;">credit_card</span>
                    </label>

                    <!-- Card Detail Panel -->
                    <div class="payment-detail-panel active" id="panel-card">
                        <!-- Live Interactive Card Preview -->
                        <div class="card-visual-preview">
                            <div class="card-preview-top">
                                <div class="card-chip-icon"></div>
                                <div class="card-brand-badge" id="card-brand">CARD</div>
                            </div>
                            <div class="card-preview-number" id="prev-num">••••  ••••  ••••  ••••</div>
                            <div class="card-preview-bottom">
                                <div class="card-preview-holder">
                                    <div class="lbl">CARDHOLDER</div>
                                    <div class="val" id="prev-name"><%= sessionUser != null && sessionUser.getName() != null && !sessionUser.getName().isEmpty() ? sessionUser.getName().toUpperCase() : "YOUR NAME" %></div>
                                </div>
                                <div class="card-preview-expiry">
                                    <div class="lbl">EXPIRES</div>
                                    <div class="val" id="prev-exp">MM / YY</div>
                                </div>
                            </div>
                        </div>

                        <div style="margin-bottom: 0.85rem;">
                            <span class="panel-label" style="margin-bottom: 0;">Card Details</span>
                        </div>

                        <!-- Card Number -->
                        <div style="margin-bottom: 0.85rem;">
                            <label class="panel-label" for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber" class="panel-input"
                                   placeholder="4532 0123 4567 8910" maxlength="19" autocomplete="cc-number">
                        </div>

                        <!-- Cardholder Name -->
                        <div style="margin-bottom: 0.85rem;">
                            <label class="panel-label" for="cardName">Cardholder Name</label>
                            <input type="text" id="cardName" name="cardName" class="panel-input"
                                   placeholder="Full name as printed on card"
                                   value="<%= sessionUser != null && sessionUser.getName() != null ? sessionUser.getName() : "" %>"
                                   autocomplete="cc-name">
                        </div>

                        <!-- Expiry & CVV -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.85rem;">
                            <div>
                                <label class="panel-label" for="cardExpiry">Expiry Date</label>
                                <input type="text" id="cardExpiry" name="cardExpiry" class="panel-input"
                                       placeholder="MM / YY" maxlength="7" autocomplete="cc-exp">
                            </div>
                            <div>
                                <label class="panel-label" for="cardCvv">CVV / CVC</label>
                                <input type="password" id="cardCvv" name="cvv" class="panel-input"
                                       placeholder="•••" maxlength="3" autocomplete="cc-csc">
                            </div>
                        </div>

                    </div>

                    <!-- Option B: UPI / QR -->
                    <label class="payment-method-card" for="pay-upi">
                        <input type="radio" id="pay-upi" name="paymentMethod" value="UPI">
                        <div class="payment-method-label">
                            <strong>Mock UPI / QR Payment</strong>
                            <small>Google Pay, PhonePe, Paytm, or custom UPI ID</small>
                        </div>
                        <span class="material-symbols-outlined" style="color: #A1A1AA;">qr_code_scanner</span>
                    </label>

                    <!-- UPI Detail Panel -->
                    <div class="payment-detail-panel" id="panel-upi">
                        <!-- Step A: Continue with App -->
                        <div style="margin-bottom: 0.5rem;">
                            <span class="panel-label">Continue with App</span>
                            <div class="upi-app-grid">
                                <div class="upi-app-card" onclick="selectUpiApp(this, 'Google Pay', 'gpay', 'okhdfcbank')">
                                    <div class="upi-app-logo logo-gpay">G</div>
                                    <span>Google Pay</span>
                                </div>
                                <div class="upi-app-card" onclick="selectUpiApp(this, 'PhonePe', 'phonepe', 'ybl')">
                                    <div class="upi-app-logo logo-phonepe">Pe</div>
                                    <span>PhonePe</span>
                                </div>
                                <div class="upi-app-card" onclick="selectUpiApp(this, 'Paytm', 'paytm', 'paytm')">
                                    <div class="upi-app-logo logo-paytm">Py</div>
                                    <span>Paytm</span>
                                </div>
                                <div class="upi-app-card" onclick="selectUpiApp(this, 'BHIM UPI', 'bhim', 'upi')">
                                    <div class="upi-app-logo logo-bhim">B</div>
                                    <span>BHIM</span>
                                </div>
                            </div>
                        </div>

                        <div class="panel-divider">or enter upi id</div>

                        <!-- Step B: Custom UPI ID -->
                        <div>
                            <label class="panel-label" for="upiId">Your UPI ID / VPA</label>
                            <div class="upi-input-group">
                                <input type="text" id="upiId" name="upiId" class="panel-input"
                                       placeholder="e.g. <%= sessionUser != null && sessionUser.getEmail() != null ? sessionUser.getEmail().split("@")[0] : "buyer" %>@okaxis"
                                       oninput="handleUpiInput()">
                                <button type="button" class="upi-verify-action-btn" onclick="verifyUpiId()">Verify</button>
                            </div>
                            <div id="upi-status-msg" class="upi-status-msg"></div>
                        </div>

                        <!-- Quick Suffix Suggestions -->
                        <div style="display: flex; flex-wrap: wrap; gap: 0.4rem; margin-top: 0.65rem;">
                            <span style="font-family: var(--font-mono); font-size: 0.7rem; color: #71717A; align-self: center;">Quick:</span>
                            <button type="button" class="quick-fill-btn" onclick="applyUpiSuffix('@okaxis')">@okaxis</button>
                            <button type="button" class="quick-fill-btn" onclick="applyUpiSuffix('@okhdfcbank')">@okhdfcbank</button>
                            <button type="button" class="quick-fill-btn" onclick="applyUpiSuffix('@ybl')">@ybl</button>
                            <button type="button" class="quick-fill-btn" onclick="applyUpiSuffix('@paytm')">@paytm</button>
                        </div>

                        <!-- Simulated QR Code Toggle -->
                        <button type="button" class="upi-qr-toggle-btn" onclick="toggleQrCode()">
                            <span class="material-symbols-outlined" style="font-size: 1rem;">qr_code_2</span>
                            <span>Toggle Mock QR Code Scanner</span>
                        </button>

                        <div class="qr-box" id="qr-box">
                            <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #FFFFFF; margin-bottom: 0.75rem;">
                                Scan with any UPI app to pay <strong style="color: #FFFFFF;"><%= currencyFormat.format(grandTotal) %></strong>
                            </div>
                            <div style="display: inline-block; padding: 10px; background: #FFFFFF; border-radius: 8px;">
                                <svg width="140" height="140" viewBox="0 0 140 140" xmlns="http://www.w3.org/2000/svg">
                                    <!-- Stylized Mock QR Code -->
                                    <rect width="140" height="140" fill="#FFFFFF"/>
                                    <!-- Corner 1 -->
                                    <rect x="10" y="10" width="35" height="35" fill="#000000"/>
                                    <rect x="15" y="15" width="25" height="25" fill="#FFFFFF"/>
                                    <rect x="20" y="20" width="15" height="15" fill="#000000"/>
                                    <!-- Corner 2 -->
                                    <rect x="95" y="10" width="35" height="35" fill="#000000"/>
                                    <rect x="100" y="15" width="25" height="25" fill="#FFFFFF"/>
                                    <rect x="105" y="20" width="15" height="15" fill="#000000"/>
                                    <!-- Corner 3 -->
                                    <rect x="10" y="95" width="35" height="35" fill="#000000"/>
                                    <rect x="15" y="100" width="25" height="25" fill="#FFFFFF"/>
                                    <rect x="20" y="105" width="15" height="15" fill="#000000"/>
                                    <!-- Patterns -->
                                    <rect x="52" y="15" width="8" height="25" fill="#000000"/>
                                    <rect x="68" y="10" width="8" height="15" fill="#000000"/>
                                    <rect x="80" y="25" width="8" height="15" fill="#000000"/>
                                    <rect x="15" y="52" width="25" height="8" fill="#000000"/>
                                    <rect x="10" y="68" width="15" height="8" fill="#000000"/>
                                    <rect x="25" y="80" width="15" height="8" fill="#000000"/>
                                    <rect x="52" y="52" width="36" height="36" fill="#000000"/>
                                    <rect x="58" y="58" width="24" height="24" fill="#FFFFFF"/>
                                    <rect x="66" y="66" width="8" height="8" fill="#000000"/>
                                    <rect x="95" y="55" width="10" height="20" fill="#000000"/>
                                    <rect x="115" y="70" width="15" height="10" fill="#000000"/>
                                    <rect x="55" y="95" width="15" height="10" fill="#000000"/>
                                    <rect x="75" y="110" width="20" height="15" fill="#000000"/>
                                    <rect x="105" y="95" width="25" height="25" fill="#000000"/>
                                </svg>
                            </div>
                            <div style="font-family: var(--font-mono); font-size: 0.7rem; color: #71717A; margin-top: 0.65rem;">
                                Mock PraveenMart Merchant VPA: praveenmart@hdfcbank
                            </div>
                        </div>

                    </div>

                    <!-- Option C: Cash on Delivery -->
                    <label class="payment-method-card" for="pay-cod">
                        <input type="radio" id="pay-cod" name="paymentMethod" value="COD">
                        <div class="payment-method-label">
                            <strong>Cash on Delivery (COD)</strong>
                            <small>Pay in cash upon physical delivery at your doorstep</small>
                        </div>
                        <span class="material-symbols-outlined" style="color: #A1A1AA;">local_atm</span>
                    </label>

                    <!-- COD Detail Panel -->
                    <div class="payment-detail-panel" id="panel-cod">
                        <div class="cod-notice-card">
                            <span class="material-symbols-outlined" style="color: #FFFFFF; font-size: 1.25rem;">info</span>
                            <div>
                                <div>Pay with cash when your package arrives at your delivery address.</div>
                                <div style="font-size: 0.74rem; color: #71717A; margin-top: 0.25rem;">
                                    Please keep exact amount of <strong><%= currencyFormat.format(grandTotal) %></strong> ready for contactless handover.
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- ── Order Summary ──────────────────────────────────────── -->
            <div class="summary-card">
                <h2 class="summary-card-title">Order Items (<%= cartItems != null ? cartItems.size() : 0 %>)</h2>

                <div style="max-height: 280px; overflow-y: auto; margin-bottom: 1.5rem; padding-right: 0.5rem;">
                    <% if (cartItems != null) { %>
                        <% for (CartItem item : cartItems) {
                            Product p = item.getProduct();
                        %>
                            <div class="summary-item-row">
                                <div style="flex: 1; padding-right: 0.5rem;">
                                    <div style="font-weight: 700; color: #FFFFFF;"><%= p != null ? p.getName() : "Item" %></div>
                                    <div style="font-size: 0.8rem; color: #71717A; margin-top: 0.15rem;">Qty: <%= item.getQuantity() %></div>
                                </div>
                                <div style="font-weight: 700; color: #FFFFFF;">
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
                                <span style="color: #FFFFFF;">FREE</span>
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

                <button type="submit" class="btn btn-primary" id="place-order-btn"
                        style="width: 100%; padding: 0.85rem; font-size: 0.92rem; margin-top: 1.5rem;
                               display: flex; align-items: center; justify-content: center;
                               gap: 0.5rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                    <span class="material-symbols-outlined" style="font-size: 1.1rem;">verified_user</span>
                    <span id="place-order-btn-text">Confirm &amp; Place Order</span>
                </button>
            </div>

        </div>
    </form>
</main>

<%@ include file="/includes/footer.jspf" %>

<script>
// ── Payment Method Panel Switch ──────────────────────────────────────────────
const PANELS = {
    CARD: 'panel-card',
    UPI: 'panel-upi',
    COD: 'panel-cod'
};

document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        Object.values(PANELS).forEach(function(id) {
            var panel = document.getElementById(id);
            if (panel) panel.classList.remove('active');
        });
        var activePanel = document.getElementById(PANELS[this.value]);
        if (activePanel) activePanel.classList.add('active');

        // Update button text
        var btnText = document.getElementById('place-order-btn-text');
        if (this.value === 'CARD') {
            btnText.textContent = 'Pay with Card & Place Order';
        } else if (this.value === 'UPI') {
            btnText.textContent = 'Pay via UPI & Place Order';
        } else {
            btnText.textContent = 'Confirm COD & Place Order';
        }
    });
});

// ── Credit/Debit Card Live Interaction ───────────────────────────────────────
var cardNumInput = document.getElementById('cardNumber');
var cardNameInput = document.getElementById('cardName');
var cardExpInput = document.getElementById('cardExpiry');
var cardCvvInput = document.getElementById('cardCvv');

cardNumInput.addEventListener('input', function() {
    var raw = this.value.replace(/\D/g, '').substring(0, 16);
    // Format input with single space every 4 digits (e.g. 1111 2222 3333 4444 = 19 chars)
    var formatted = raw.match(/.{1,4}/g)?.join(' ') || '';
    this.value = formatted;

    // Update preview number
    var padded = raw.padEnd(16, '\u2022');
    var chunks = padded.match(/.{1,4}/g) || [];
    document.getElementById('prev-num').textContent = chunks.join('  ');

    // Brand detection
    var brand = document.getElementById('card-brand');
    if (/^4/.test(raw)) {
        brand.textContent = 'VISA';
    } else if (/^5[1-5]/.test(raw)) {
        brand.textContent = 'MASTERCARD';
    } else if (/^(60|65|81|82)/.test(raw)) {
        brand.textContent = 'RUPAY';
    } else if (/^3[47]/.test(raw)) {
        brand.textContent = 'AMEX';
    } else {
        brand.textContent = 'CARD';
    }
});

cardNameInput.addEventListener('input', function() {
    var val = this.value.trim().toUpperCase();
    document.getElementById('prev-name').textContent = val || 'YOUR NAME';
});

cardExpInput.addEventListener('input', function() {
    var raw = this.value.replace(/\D/g, '').substring(0, 4);
    if (raw.length > 2) {
        this.value = raw.slice(0, 2) + ' / ' + raw.slice(2);
    } else {
        this.value = raw;
    }
    document.getElementById('prev-exp').textContent = this.value || 'MM / YY';
});

cardCvvInput.addEventListener('input', function() {
    // Strictly digits only, max 3 digits
    this.value = this.value.replace(/\D/g, '').substring(0, 3);
});

// ── UPI App Selection & ID Verification ──────────────────────────────────────
var currentUserName = '<%= sessionUser != null && sessionUser.getEmail() != null ? sessionUser.getEmail().split("@")[0].replaceAll("[^a-zA-Z0-9]", "") : "buyer" %>';
if (!currentUserName) currentUserName = 'buyer';

function selectUpiApp(element, appName, appCode, defaultSuffix) {
    document.querySelectorAll('.upi-app-card').forEach(function(c) {
        c.classList.remove('active');
    });
    element.classList.add('active');

    var generatedUpi = currentUserName + '@' + defaultSuffix;
    var upiInput = document.getElementById('upiId');
    upiInput.value = generatedUpi;

    var statusEl = document.getElementById('upi-status-msg');
    statusEl.className = 'upi-status-msg success';
    statusEl.innerHTML = '<span class="material-symbols-outlined" style="font-size: 1rem;">check_circle</span> Selected ' + appName + ' (' + generatedUpi + ')';
}

function handleUpiInput() {
    document.querySelectorAll('.upi-app-card').forEach(function(c) {
        c.classList.remove('active');
    });
    var statusEl = document.getElementById('upi-status-msg');
    statusEl.textContent = '';
    statusEl.className = 'upi-status-msg';
}

function applyUpiSuffix(suffix) {
    var upiInput = document.getElementById('upiId');
    var val = upiInput.value.trim();
    if (!val) {
        upiInput.value = currentUserName + suffix;
    } else if (val.includes('@')) {
        upiInput.value = val.split('@')[0] + suffix;
    } else {
        upiInput.value = val + suffix;
    }
    verifyUpiId();
}

function verifyUpiId() {
    var val = document.getElementById('upiId').value.trim();
    var statusEl = document.getElementById('upi-status-msg');

    if (!val) {
        statusEl.className = 'upi-status-msg error';
        statusEl.innerHTML = '<span class="material-symbols-outlined" style="font-size: 1rem;">cancel</span> Please enter a UPI ID';
        return;
    }

    if (val.includes('@') && val.length >= 5) {
        statusEl.className = 'upi-status-msg success';
        statusEl.innerHTML = '<span class="material-symbols-outlined" style="font-size: 1rem;">check_circle</span> Verified: ' + val + ' (PraveenMart Mock Gate)';
    } else {
        statusEl.className = 'upi-status-msg error';
        statusEl.innerHTML = '<span class="material-symbols-outlined" style="font-size: 1rem;">cancel</span> Invalid UPI ID format. Must contain "@" (e.g. name@bank)';
    }
}

function toggleQrCode() {
    var qrBox = document.getElementById('qr-box');
    qrBox.classList.toggle('visible');
}

// ── Client-side Validation on Form Submit ────────────────────────────────────
document.getElementById('checkout-form').addEventListener('submit', function(e) {
    var selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
    if (!selectedMethod) return;

    var method = selectedMethod.value;

    if (method === 'CARD') {
        var num = cardNumInput.value.replace(/\D/g, '');
        var cvv = cardCvvInput.value.trim();

        if (num.length < 16) {
            e.preventDefault();
            alert('Please enter a full 16-digit card number.');
            cardNumInput.focus();
            return false;
        }

        if (cvv.length !== 3) {
            e.preventDefault();
            alert('Please enter a valid 3-digit CVV/CVC.');
            cardCvvInput.focus();
            return false;
        }
    } else if (method === 'UPI') {
        var upi = document.getElementById('upiId').value.trim();

        if (!upi || !upi.includes('@') || upi.length < 5) {
            e.preventDefault();
            alert('Please enter or select a valid UPI ID (e.g. buyer@okaxis) or choose an app above.');
            document.getElementById('upiId').focus();
            return false;
        }
    }
    // COD requires no extra checks
});

// ── Live Auto-Save Delivery Address as Account Default ──────────────────────
(function() {
    var saveTimeout = null;
    var addressFields = document.querySelectorAll('.address-field');
    var statusBadge = document.getElementById('saveStatusIndicator');
    var syncTitle = document.getElementById('syncTitle');
    var syncDesc = document.getElementById('syncDesc');
    var syncIcon = document.getElementById('syncIcon');

    function syncAddress() {
        var street = (document.getElementById('street') ? document.getElementById('street').value.trim() : '');
        if (!street) return;

        var fullName = (document.getElementById('fullName') ? document.getElementById('fullName').value.trim() : '');
        var phone = (document.getElementById('phone') ? document.getElementById('phone').value.trim() : '');
        var city = (document.getElementById('city') ? document.getElementById('city').value.trim() : '');
        var state = (document.getElementById('state') ? document.getElementById('state').value.trim() : '');
        var pincode = (document.getElementById('pincode') ? document.getElementById('pincode').value.trim() : '');

        var params = new URLSearchParams();
        params.append('fullName', fullName);
        params.append('phone', phone);
        params.append('street', street);
        params.append('city', city);
        params.append('state', state);
        params.append('pincode', pincode);

        fetch('<%= request.getContextPath() %>/checkout/save-address', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        }).then(function(res) {
            return res.json();
        }).then(function(data) {
            if (data && data.success) {
                if (statusBadge) {
                    statusBadge.style.display = 'inline-block';
                    statusBadge.textContent = '✓ Saved to Account';
                    setTimeout(function() {
                        statusBadge.style.display = 'none';
                    }, 4000);
                }
                if (syncTitle) syncTitle.textContent = 'Default Account Address Loaded';
                if (syncDesc) syncDesc.textContent = 'Address saved to your account default. Next time you checkout, it will load automatically.';
                if (syncIcon) {
                    syncIcon.textContent = 'verified_user';
                    syncIcon.style.color = '#FFFFFF';
                }
            }
        }).catch(function(err) {
            // Silently continue, standard form submit will also save on checkout
        });
    }

    addressFields.forEach(function(field) {
        field.addEventListener('blur', function() {
            syncAddress();
        });
        field.addEventListener('input', function() {
            clearTimeout(saveTimeout);
            saveTimeout = setTimeout(syncAddress, 1800);
        });
    });
})();
</script>

</body>
</html>
