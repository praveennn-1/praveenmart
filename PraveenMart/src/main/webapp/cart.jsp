<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.CartItem" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal shipping = (BigDecimal) request.getAttribute("shipping");
    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");

    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (shipping == null) shipping = BigDecimal.ZERO;
    if (grandTotal == null) grandTotal = BigDecimal.ZERO;

    String cartMessage = (String) session.getAttribute("cartMessage");
    String cartError = (String) session.getAttribute("cartError");
    session.removeAttribute("cartMessage");
    session.removeAttribute("cartError");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Shopping Cart - PraveenMart</title>
                                        <link rel="stylesheet"
                                            href="<%= request.getContextPath() %>/css/theme.css?v=6.3">
    <style>
        body {
            background-color: #000000;
        }

        .cart-wrapper {
            padding: 3rem 0 6rem;
            position: relative;
        }

        .cart-alert-animated {
            animation: cartAlertEntrance 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards,
                       cartAlertPulseGlow 3s ease-in-out infinite alternate !important;
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1), 0 0 0 1px rgba(255, 255, 255, 0.25) !important;
        }

        .cart-alert-animated .material-symbols-outlined {
            animation: checkIconPop 0.65s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s both !important;
        }

        @keyframes cartAlertPulseGlow {
            0% {
                box-shadow: 0 0 12px rgba(255, 255, 255, 0.08), 0 0 0 1px rgba(255, 255, 255, 0.2);
            }
            100% {
                box-shadow: 0 0 25px rgba(255, 255, 255, 0.18), 0 0 0 1px rgba(255, 255, 255, 0.4);
            }
        }

        .cart-page-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: -0.03em;
            line-height: 1.15;
            color: #FFFFFF;
            margin-bottom: 0.5rem;
        }

        .cart-page-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #888888;
            margin-bottom: 2.5rem;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
            align-items: start;
        }

        @media (max-width: 960px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
        }

        .cart-table-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
        }

        .cart-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.25rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #1E1E22;
        }

        .cart-items-count {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.78rem;
            font-weight: 600;
            color: #A1A1AA;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .cart-item-row {
            display: grid;
            grid-template-columns: 80px 1fr auto auto auto;
            gap: 1.25rem;
            align-items: center;
            padding: 1.25rem 0;
            border-bottom: 1px solid #1E1E22;
        }

        .cart-item-row:last-child {
            border-bottom: none;
            padding-bottom: 0.25rem;
        }

        @media (max-width: 640px) {
            .cart-item-row {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 0.75rem;
            }
        }

        .cart-item-thumb {
            width: 80px;
            height: 80px;
            border-radius: 4px;
            overflow: hidden;
            background-color: #000000;
            border: 1px solid #27272A;
            position: relative;
        }

        .cart-item-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .cart-item-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .cart-item-category {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #71717A;
        }

        .cart-item-name {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 0.98rem;
            font-weight: 600;
            color: #FFFFFF;
            text-decoration: none;
            transition: color 150ms ease;
        }

        .cart-item-name:hover {
            color: #A1A1AA;
        }

        .cart-item-unit-price {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.8rem;
            color: #71717A;
        }

        /* Stepper in Cart */
        .cart-qty-form {
            display: inline-flex;
            align-items: center;
            border: 1px solid #27272A;
            border-radius: 4px;
            background: #000000;
            overflow: hidden;
            height: 34px;
        }

        .cart-qty-btn {
            background: transparent;
            border: none;
            width: 30px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            font-weight: 600;
            color: #FFFFFF;
            cursor: pointer;
            transition: background-color 0.15s ease;
            user-select: none;
            padding: 0;
            font-family: var(--font-mono);
        }

        .cart-qty-btn:hover {
            background: #18181B;
        }

        .cart-qty-input {
            width: 32px;
            border: none;
            background: transparent;
            text-align: center;
            font-size: 0.82rem;
            font-weight: 600;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            -moz-appearance: textfield;
            appearance: textfield;
            padding: 0;
            outline: none;
        }

        .cart-qty-input::-webkit-outer-spin-button,
        .cart-qty-input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .cart-item-total-price {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-weight: 700;
            font-size: 1rem;
            color: #FFFFFF;
            text-align: right;
            min-width: 85px;
        }

        .cart-item-del-btn {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            background: #0C0C0C;
            border: 1px solid #27272A;
            color: #71717A;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 150ms ease;
        }

        .cart-item-del-btn:hover {
            background: #18181B;
            border-color: #EF4444;
            color: #EF4444;
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

        .summary-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.95rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            color: #A1A1AA;
        }

        .summary-row.total {
            font-size: 1.15rem;
            font-weight: 700;
            color: #FFFFFF;
            border-top: 1px solid #1E1E22;
            padding-top: 1rem;
            margin-top: 1rem;
        }

        /* Empty Cart State */
        .empty-cart-card {
            background: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            text-align: center;
            padding: 4.5rem 2rem;
        }

        /* Mobile Screen Responsiveness */
        @media (max-width: 640px) {
            .cart-wrapper {
                padding: 1.25rem 0 3.5rem;
            }
            .cart-page-title {
                font-size: 1.45rem;
                letter-spacing: -0.02em;
            }
            .cart-page-subtitle {
                font-size: 0.78rem;
                margin-bottom: 1.25rem;
            }
            .cart-table-card {
                padding: 1rem;
            }
            .cart-header-row {
                margin-bottom: 0.85rem;
                padding-bottom: 0.75rem;
            }
            .cart-item-row {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 0.75rem;
                padding: 1rem 0;
                width: 100%;
                box-sizing: border-box;
            }
            .cart-item-thumb {
                width: 56px;
                height: 56px;
                flex-shrink: 0;
            }
            .cart-item-info {
                flex: 1 1 180px;
                min-width: 0;
            }
            .cart-item-name {
                font-size: 0.88rem;
            }
            .cart-item-unit-price {
                font-size: 0.75rem;
            }
            .cart-item-row > div:nth-child(3) {
                margin-left: auto;
            }
            .cart-item-total-price {
                min-width: auto;
                font-size: 0.95rem;
            }
            .cart-qty-btn {
                width: 28px;
                height: 28px;
            }
            .cart-qty-input {
                width: 30px;
                height: 28px;
                font-size: 0.78rem;
            }
            .summary-card {
                padding: 1.15rem;
            }
            .summary-card-title {
                font-size: 1rem;
                margin-bottom: 1rem;
            }
            .empty-cart-card {
                padding: 2.5rem 1rem;
            }
        }
    </style>
                                    </head>

                                    <body>

                                        <%@ include file="/includes/header.jspf" %>

                                            <main class="container cart-wrapper">
                                                <h1 class="cart-page-title">Your Shopping Cart</h1>

                                                <% if (cartMessage !=null) { %>
                                                    <div class="alert-box alert-box-success cart-alert-animated"
                                                        style="margin-bottom: 2rem;">
                                                        <span class="material-symbols-outlined">check_circle</span>
                                                        <span style="font-weight: 600; letter-spacing: 0.02em;">
                                                            <%= cartMessage %>
                                                        </span>
                                                    </div>
                                                    <% } %>

                                                        <% if (cartError !=null) { %>
                                                            <div class="alert-box alert-box-error"
                                                                style="margin-bottom: 2rem;">
                                                                <span class="material-symbols-outlined">warning</span>
                                                                <span>
                                                                    <%= cartError %>
                                                                </span>
                                                            </div>
                                                            <% } %>

                                                                <% if (cartItems !=null && !cartItems.isEmpty()) { %>
                                                                    <div class="cart-layout">
                                                                        <div class="cart-table-card">
                                                                            <div class="cart-header-row">
                                                                                <span class="cart-items-count">Cart
                                                                                    Items (<%= cartItems.size() %>
                                                                                        )</span>
                                                                                <a href="<%= request.getContextPath() %>/cart/clear"
                                                                                    class="btn btn-outlined"
                                                                                    style="padding: 0.35rem 0.85rem; font-size: 0.78rem; border-radius: 4px; font-family: var(--font-mono);"
                                                                                    onclick="return confirm('Clear entire cart?');">
                                                                                    <span
                                                                                        class="material-symbols-outlined"
                                                                                        style="font-size: 0.95rem;">delete_sweep</span>
                                                                                    <span>Clear Cart</span>
                                                                                </a>
                                                                            </div>

                                                                            <% for (CartItem item : cartItems) { Product
                                                                                p=item.getProduct(); %>
                                                                                <div class="cart-item-row">
                                                                                    <div class="cart-item-thumb">
                                                                                        <%
                                                            String cImg = (p != null) ? p.getImageUrl() : null;
                                                            if (cImg != null && !cImg.isBlank() && !cImg.startsWith("http://") && !cImg.startsWith("https://")) {
                                                                cImg = request.getContextPath() + (cImg.startsWith("/") ? cImg : "/" + cImg);
                                                            }
                                                        %>
                                                        <% if (cImg != null && !cImg.isBlank()) { %>
                                                            <img src="<%= cImg %>" alt="<%= p.getName() %>"
                                                                onerror="this.onerror=null;this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22600%22%20height%3D%22600%22%20viewBox%3D%220%200%20600%20600%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23080808%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%2371717A%22%20font-family%3D%22monospace%22%20font-size%3D%2216%22%20text-anchor%3D%22middle%22%20dominant-baseline%3D%22middle%22%3E%5B%20ITEM%20%5D%3C%2Ftext%3E%3C%2Fsvg%3E'">
                                                        <% } else { %>
                                                            <img src="data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22600%22%20height%3D%22600%22%20viewBox%3D%220%200%20600%20600%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23080808%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%2371717A%22%20font-family%3D%22monospace%22%20font-size%3D%2216%22%20text-anchor%3D%22middle%22%20dominant-baseline%3D%22middle%22%3E%5B%20ITEM%20%5D%3C%2Ftext%3E%3C%2Fsvg%3E"
                                                                alt="Product Thumbnail">
                                                        <% } %>
                                                                                    </div>
                                                                                    <div class="cart-item-info">
                                                                                        <div class="cart-item-category">
                                                                                            <%= p !=null ?
                                                                                                p.getCategory() : "" %>
                                                                                        </div>
                                                                                        <a href="<%= request.getContextPath() %>/product-details?id=<%= item.getProductId() %>"
                                                                                            class="cart-item-name">
                                                                                            <%= p !=null ? p.getName()
                                                                                                : "Item #" +
                                                                                                item.getProductId() %>
                                                                                        </a>
                                                                                        <div
                                                                                            class="cart-item-unit-price">
                                                                                            Unit: <%= p !=null ?
                                                                                                currencyFormat.format(p.getPrice())
                                                                                                : "" %>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div>
                                                                                        <form
                                                                                            action="<%= request.getContextPath() %>/cart/update"
                                                                                            method="post"
                                                                                            class="cart-qty-form">
                                                                                            <input type="hidden"
                                                                                                name="cartItemId"
                                                                                                value="<%= item.getId() %>">
                                                                                            <button type="button"
                                                                                                class="cart-qty-btn cart-qty-minus">−</button>
                                                                                            <input type="number"
                                                                                                name="quantity"
                                                                                                value="<%= item.getQuantity() %>"
                                                                                                min="1"
                                                                                                max="<%= p != null ? p.getStockQty() : 99 %>"
                                                                                                class="cart-qty-input"
                                                                                                readonly>
                                                                                            <button type="button"
                                                                                                class="cart-qty-btn cart-qty-plus">+</button>
                                                                                        </form>
                                                                                    </div>
                                                                                    <div class="cart-item-total-price">
                                                                                        <%= currencyFormat.format(item.getItemTotal())
                                                                                            %>
                                                                                    </div>
                                                                                    <div style="display: flex; align-items: center; gap: 0.35rem;">
                                                                                        <form
                                                                                            action="<%= request.getContextPath() %>/cart/remove"
                                                                                            method="post">
                                                                                            <input type="hidden"
                                                                                                name="cartItemId"
                                                                                                value="<%= item.getId() %>">
                                                                                            <button type="submit"
                                                                                                class="cart-item-del-btn"
                                                                                                title="Remove Item">
                                                                                                <span
                                                                                                    class="material-symbols-outlined"
                                                                                                    style="font-size: 1.1rem;">delete</span>
                                                                                            </button>
                                                                                        </form>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>
                                                                        <div class="summary-card">
                                                                            <h2 class="summary-card-title">Order Summary
                                                                            </h2>

                                                                            <div class="summary-row">
                                                                                <span>Subtotal</span>
                                                                                <span
                                                                                    style="font-weight: 700; color: #ffffff;">
                                                                                    <%= currencyFormat.format(subtotal)
                                                                                        %>
                                                                                </span>
                                                                            </div>

                                                                            <div class="summary-row">
                                                                                <span>Shipping</span>
                                                                                <span style="font-weight: 700;">
                                                                                    <% if
                                                                                        (shipping.compareTo(BigDecimal.ZERO)==0)
                                                                                        { %>
                                                                                        <span
                                                                                            style="color: #FFFFFF;">FREE</span>
                                                                                        <% } else { %>
                                                                                            <span
                                                                                                style="color: #ffffff;">
                                                                                                <%= currencyFormat.format(shipping)
                                                                                                    %>
                                                                                            </span>
                                                                                            <% } %>
                                                                                </span>
                                                                            </div>


                                                                                    <div class="summary-row total">
                                                                                        <span>Grand Total</span>
                                                                                        <span>
                                                                                            <%= currencyFormat.format(grandTotal)
                                                                                                %>
                                                                                        </span>
                                                                                    </div>

                                                                                    <a href="<%= request.getContextPath() %>/checkout"
                                                                                        class="btn btn-primary"
                                                                                        style="width: 100%; padding: 0.85rem; font-size: 0.92rem; margin-top: 1.5rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                                                                                        <span>Proceed to Checkout</span>
                                                                                        <span
                                                                                            class="material-symbols-outlined"
                                                                                            style="font-size: 1.1rem;">arrow_forward</span>
                                                                                    </a>

                                                                                    <div
                                                                                        style="text-align: center; margin-top: 1.25rem;">
                                                                                        <a href="<%= request.getContextPath() %>/products"
                                                                                            style="font-size: 0.82rem; font-family: var(--font-mono); color: #71717A; text-decoration: none;">
                                                                                            ← Continue Shopping
                                                                                        </a>
                                                                                    </div>
                                                                        </div>
                                                                    </div>
                                                                    <% } else { %>
                                                                        <div class="empty-cart-card">
                                                                            <span class="material-symbols-outlined"
                                                                                style="font-size: 3.5rem; color: #3F3F46; margin-bottom: 1.2rem;">shopping_bag</span>
                                                                            <h2
                                                                                style="font-size: 1.6rem; font-weight: 700; margin-bottom: 0.5rem; color: #FFFFFF; letter-spacing: -0.02em;">
                                                                                Your Cart is Empty</h2>
                                                                            <p
                                                                                style="color: #888888; font-family: var(--font-mono); max-width: 440px; margin: 0 auto 2rem; font-size: 0.88rem;">
                                                                                Looks like you haven't added any items to your cart yet. Explore our curated collections.
                                                                            </p>
                                                                            <a href="<%= request.getContextPath() %>/products"
                                                                                class="btn btn-primary"
                                                                                style="padding: 0.75rem 2rem; font-size: 0.88rem; display: inline-flex; align-items: center; gap: 0.4rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                                                                                <span>Explore Catalog</span>
                                                                                <span class="material-symbols-outlined"
                                                                                    style="font-size: 1rem;">arrow_forward</span>
                                                                            </a>
                                                                        </div>
                                                                        <% } %>
                                            </main>

                                            <%@ include file="/includes/footer.jspf" %>

                                                <script>
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        document.querySelectorAll('.cart-qty-form').forEach(function (form) {
                                                            const minusBtn = form.querySelector('.cart-qty-minus');
                                                            const plusBtn = form.querySelector('.cart-qty-plus');
                                                            const input = form.querySelector('.cart-qty-input');

                                                            if (!minusBtn || !plusBtn || !input) return;

                                                            minusBtn.addEventListener('click', function () {
                                                                let val = parseInt(input.value) || 1;
                                                                let min = parseInt(input.getAttribute('min')) || 1;
                                                                if (val > min) {
                                                                    input.value = val - 1;
                                                                    sessionStorage.setItem('pm_scroll_' + window.location.pathname, window.scrollY.toString());
                                                                    form.submit();
                                                                }
                                                            });

                                                            plusBtn.addEventListener('click', function () {
                                                                let val = parseInt(input.value) || 1;
                                                                let max = parseInt(input.getAttribute('max')) || 999;
                                                                if (val < max) {
                                                                    input.value = val + 1;
                                                                    sessionStorage.setItem('pm_scroll_' + window.location.pathname, window.scrollY.toString());
                                                                    form.submit();
                                                                }
                                                            });
                                                        });
                                                    });
                                                </script>

                                    </body>

                                    </html>