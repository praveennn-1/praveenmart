<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.math.BigDecimal" %>
            <%@ page import="java.text.NumberFormat" %>
                <%@ page import="java.util.Locale" %>
                    <%@ page import="com.praveen.praveenmart.model.CartItem" %>
                        <%@ page import="com.praveen.praveenmart.model.Product" %>
                            <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
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

                                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en",
                                    "IN"));
                                    %>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Shopping Cart - PraveenMart</title>
                                        <link rel="stylesheet"
                                            href="<%= request.getContextPath() %>/css/theme.css?v=5.8">
                                        <style>
                                            body {
                                                background-color: var(--bg);
                                            }

                                            .cart-wrapper {
                                                padding: 3.5rem 0 6rem;
                                                position: relative;
                                            }

                                            .cart-page-title {
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

                                            .cart-layout {
                                                display: grid;
                                                grid-template-columns: 1fr 380px;
                                                gap: 2.5rem;
                                                align-items: start;
                                            }

                                            @media (max-width: 960px) {
                                                .cart-layout {
                                                    grid-template-columns: 1fr;
                                                }
                                            }

                                            .cart-table-card {
                                                background-color: var(--surface);
                                                border: 1px solid var(--surface-border);
                                                border-radius: 16px;
                                                padding: 2rem;
                                                box-shadow: var(--shadow-soft);
                                            }

                                            .cart-header-row {
                                                display: flex;
                                                justify-content: space-between;
                                                align-items: center;
                                                margin-bottom: 1.25rem;
                                                padding-bottom: 1rem;
                                                border-bottom: 1px solid var(--divider);
                                            }

                                            .cart-items-count {
                                                font-size: 12px;
                                                font-weight: 400;
                                                color: var(--muted);
                                                text-transform: uppercase;
                                                letter-spacing: 0.05em;
                                            }

                                            .cart-item-row {
                                                display: grid;
                                                grid-template-columns: 88px 1fr auto auto auto;
                                                gap: 1.5rem;
                                                align-items: center;
                                                padding: 1.5rem 0;
                                                border-bottom: 1px solid var(--divider);
                                            }

                                            .cart-item-row:last-child {
                                                border-bottom: none;
                                                padding-bottom: 0.5rem;
                                            }

                                            @media (max-width: 640px) {
                                                .cart-item-row {
                                                    grid-template-columns: 72px 1fr;
                                                    gap: 1rem;
                                                }

                                                .cart-item-row>div:nth-child(3),
                                                .cart-item-row>div:nth-child(4),
                                                .cart-item-row>div:nth-child(5) {
                                                    grid-column: 2 / -1;
                                                }
                                            }

                                            .cart-item-thumb {
                                                width: 88px;
                                                height: 88px;
                                                border-radius: 12px;
                                                overflow: hidden;
                                                background-color: var(--bg-alt);
                                                border: 1px solid var(--surface-border);
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
                                                font-size: 12px;
                                                font-weight: 400;
                                                text-transform: uppercase;
                                                letter-spacing: 0.05em;
                                                color: var(--muted);
                                            }

                                            .cart-item-name {
                                                font-family: var(--font-heading);
                                                font-size: 1.05rem;
                                                font-weight: 700;
                                                color: #ffffff;
                                                text-decoration: none;
                                                transition: color 200ms ease;
                                            }

                                            .cart-item-name:hover {
                                                color: var(--heading);
                                            }

                                            .cart-item-unit-price {
                                                font-size: 14px;
                                                color: var(--text);
                                            }

                                            /* Stepper in Cart */
                                            .cart-qty-form {
                                                display: inline-flex;
                                                align-items: center;
                                                border: 1px solid var(--pill-border);
                                                border-radius: var(--radius-pill);
                                                background: var(--pill-inactive-bg);
                                                overflow: hidden;
                                                height: 36px;
                                            }

                                            .cart-qty-btn {
                                                background: transparent;
                                                border: none;
                                                width: 32px;
                                                height: 100%;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                font-size: 1rem;
                                                font-weight: 700;
                                                color: #ffffff;
                                                cursor: pointer;
                                                transition: background-color 0.15s ease;
                                                user-select: none;
                                                padding: 0;
                                            }

                                            .cart-qty-btn:hover {
                                                background: rgba(255, 255, 255, 0.14);
                                            }

                                            .cart-qty-input {
                                                width: 32px;
                                                border: none;
                                                background: transparent;
                                                text-align: center;
                                                font-size: 0.88rem;
                                                font-weight: 700;
                                                color: #ffffff;
                                                -moz-appearance: textfield;
                                                padding: 0;
                                                outline: none;
                                            }

                                            .cart-qty-input::-webkit-outer-spin-button,
                                            .cart-qty-input::-webkit-inner-spin-button {
                                                -webkit-appearance: none;
                                                margin: 0;
                                            }

                                            .cart-item-total-price {
                                                font-family: var(--font-heading);
                                                font-weight: 700;
                                                font-size: 1.15rem;
                                                color: var(--price);
                                                text-align: right;
                                                min-width: 90px;
                                            }

                                            .cart-item-del-btn {
                                                width: 34px;
                                                height: 34px;
                                                border-radius: 8px;
                                                background: rgba(248, 113, 113, 0.08);
                                                border: 1px solid rgba(248, 113, 113, 0.2);
                                                color: #a10d0d;
                                                display: inline-flex;
                                                align-items: center;
                                                justify-content: center;
                                                cursor: pointer;
                                                transition: all 200ms ease;
                                            }

                                            .cart-item-del-btn:hover {
                                                background: rgba(248, 113, 113, 0.2);
                                                border-color: rgba(248, 113, 113, 0.4);
                                                transform: translateY(-1px);
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
                                                color: var(--heading);
                                                margin-bottom: 1.75rem;
                                            }

                                            .summary-row {
                                                display: flex;
                                                align-items: center;
                                                justify-content: space-between;
                                                margin-bottom: 1.1rem;
                                                font-size: 14px;
                                                color: var(--text);
                                            }

                                            .summary-row.total {
                                                font-family: var(--font-heading);
                                                font-size: 1.35rem;
                                                font-weight: 700;
                                                color: var(--price);
                                                border-top: 1px solid var(--divider);
                                                padding-top: 1.25rem;
                                                margin-top: 1.25rem;
                                            }


                                            /* Empty Cart State */
                                            .empty-cart-card {
                                                background: var(--surface);
                                                border: 1px solid var(--surface-border);
                                                border-radius: 16px;
                                                text-align: center;
                                                padding: 5rem 2rem;
                                                box-shadow: var(--shadow-soft);
                                            }
                                        </style>
                                    </head>

                                    <body>

                                        <%@ include file="/includes/header.jspf" %>

                                            <main class="container cart-wrapper">
                                                <h1 class="cart-page-title">Your Shopping Cart</h1>

                                                <% if (cartMessage !=null) { %>
                                                    <div class="alert-box alert-box-success"
                                                        style="margin-bottom: 2rem;">
                                                        <span class="material-symbols-outlined">check_circle</span>
                                                        <span>
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

                                                                        <!-- Left: Cart Items List -->
                                                                        <div class="cart-table-card">
                                                                            <div class="cart-header-row">
                                                                                <span class="cart-items-count">Cart
                                                                                    Items (<%= cartItems.size() %>
                                                                                        )</span>
                                                                                <a href="<%= request.getContextPath() %>/cart/clear"
                                                                                    class="btn btn-outlined btn-pill"
                                                                                    style="padding: 0.35rem 0.85rem; font-size: 0.78rem;"
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

                                                                                    <!-- Thumbnail -->
                                                                                    <div class="cart-item-thumb">
                                                                                        <% String cImg=(p !=null) ?
                                                                                            p.getImageUrl() : null; if
                                                                                            (cImg !=null &&
                                                                                            !cImg.isBlank()) { if
                                                                                            (!cImg.startsWith("http://")
                                                                                            &&
                                                                                            !cImg.startsWith("https://"))
                                                                                            { if (!cImg.startsWith("/"))
                                                                                            { cImg="/" + cImg; }
                                                                                            cImg=request.getContextPath()
                                                                                            + cImg; } %>
                                                                                            <img src="<%= cImg %>"
                                                                                                alt="<%= p.getName() %>"
                                                                                                onerror="this.src='https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80'">
                                                                                            <% } else { %>
                                                                                                <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80"
                                                                                                    alt="Product Thumbnail">
                                                                                                <% } %>
                                                                                    </div>

                                                                                    <!-- Product Info -->
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

                                                                                    <!-- Quantity Stepper Form -->
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

                                                                                    <!-- Subtotal -->
                                                                                    <div class="cart-item-total-price">
                                                                                        <%= currencyFormat.format(item.getItemTotal())
                                                                                            %>
                                                                                    </div>

                                                                                    <!-- Remove Button -->
                                                                                    <div>
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

                                                                        <!-- Right: Order Summary -->
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
                                                                                            style="color: #C8B196;">FREE</span>
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
                                                                                        class="btn btn-primary btn-pill"
                                                                                        style="width: 100%; padding: 0.95rem; font-size: 1rem; margin-top: 1.75rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                                                                                        <span>Proceed to Checkout</span>
                                                                                        <span
                                                                                            class="material-symbols-outlined"
                                                                                            style="font-size: 1.1rem;">arrow_forward</span>
                                                                                    </a>

                                                                                    <div
                                                                                        style="text-align: center; margin-top: 1.25rem;">
                                                                                        <a href="<%= request.getContextPath() %>/products"
                                                                                            style="font-size: 0.88rem; color: var(--color-on-surface-variant); text-decoration: none; transition: color 0.2s ease;">
                                                                                            ← Continue Shopping
                                                                                        </a>
                                                                                    </div>
                                                                        </div>
                                                                    </div>
                                                                    <% } else { %>

                                                                        <!-- Empty Cart -->
                                                                        <div class="empty-cart-card">
                                                                            <span class="material-symbols-outlined"
                                                                                style="font-size: 4.5rem; color: var(--color-outline); margin-bottom: 1.2rem;">shopping_bag</span>
                                                                            <h2
                                                                                style="font-size: 2rem; margin-bottom: 0.5rem; color: #ffffff;">
                                                                                Your Cart is Empty</h2>
                                                                            <p
                                                                                style="color: var(--color-on-surface-variant); max-width: 440px; margin: 0 auto 2rem; font-size: 1rem;">
                                                                                Looks like you haven't added any items
                                                                                to your cart yet. Explore our curated
                                                                                collections!
                                                                            </p>
                                                                            <a href="<%= request.getContextPath() %>/products"
                                                                                class="btn btn-primary btn-pill"
                                                                                style="padding: 0.85rem 2.2rem; font-size: 0.95rem; display: inline-flex; align-items: center; gap: 0.4rem;">
                                                                                <span>Explore Catalog</span>
                                                                                <span class="material-symbols-outlined"
                                                                                    style="font-size: 1.1rem;">arrow_forward</span>
                                                                            </a>
                                                                        </div>
                                                                        <% } %>
                                            </main>

                                            <%@ include file="/includes/footer.jspf" %>

                                                <script>
                                                    // Live quantity update on click
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
                                                                    form.submit();
                                                                }
                                                            });

                                                            plusBtn.addEventListener('click', function () {
                                                                let val = parseInt(input.value) || 1;
                                                                let max = parseInt(input.getAttribute('max')) || 999;
                                                                if (val < max) {
                                                                    input.value = val + 1;
                                                                    form.submit();
                                                                }
                                                            });
                                                        });
                                                    });
                                                </script>

                                    </body>

                                    </html>