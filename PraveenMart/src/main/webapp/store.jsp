<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (selectedCategory == null) selectedCategory = "all";
    if (searchQuery == null) searchQuery = "";

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
    <title>PraveenMart - Premium Marketplace</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.8">
    <style>
        /* Hero & Catalog Controls */
        .store-hero {
            padding: 4.5rem 0 3rem;
            text-align: center;
            background: var(--hero-glow), var(--bg);
            border-bottom: 1px solid var(--divider);
        }

        .store-title {
            font-family: var(--font-heading);
            font-size: clamp(2.2rem, 5vw, 3.8rem);
            font-weight: 700;
            letter-spacing: 0.01em;
            text-transform: uppercase;
            line-height: 1.1;
            color: var(--heading);
            background: var(--heading-gradient);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            max-width: 900px;
            margin: 0 auto 1.2rem;
        }

        .store-subtitle {
            font-size: 15px;
            color: var(--text);
            max-width: 650px;
            margin: 0 auto 2.5rem;
            line-height: 1.6;
        }

        /* Search Bar */
        .store-search-wrapper {
            max-width: 580px;
            margin: 0 auto 2.5rem;
        }

        .store-search-bar {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: var(--pill-inactive-bg);
            border: 1px solid var(--pill-border);
            border-radius: var(--radius-pill);
            padding: 0.35rem 0.45rem 0.35rem 1.25rem;
            box-shadow: var(--shadow-soft);
            transition: border-color 200ms ease, background-color 200ms ease;
        }

        .store-search-bar:focus-within {
            border-color: rgba(207, 224, 232, 0.35);
            background: #1c202a;
        }

        .store-search-bar input {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #ffffff;
            font-size: 0.95rem;
            font-family: var(--font-body);
        }

        .store-search-bar input::placeholder {
            color: rgba(184, 190, 199, 0.38);
            opacity: 1;
        }

        /* Category Filter Pills */
        .category-pills-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.65rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .category-pill {
            padding: 0.55rem 1.35rem;
            border-radius: var(--radius-pill);
            font-size: 0.88rem;
            font-weight: 500;
            background: var(--pill-inactive-bg);
            color: var(--pill-inactive-text) !important;
            border: 1px solid var(--pill-border);
            text-decoration: none;
            transition: all 200ms ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .category-pill:hover {
            background: #20242e;
            color: #ffffff !important;
            border-color: rgba(255, 255, 255, 0.14);
            transform: translateY(-1px);
        }

        .category-pill.active {
            background: var(--pill-active-bg) !important;
            color: var(--pill-active-text) !important;
            border-color: #8FAFC2 !important;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2) !important;
        }

        /* Catalog Main Grid Area */
        .catalog-container {
            padding-top: 3.5rem;
            padding-bottom: 6rem;
            width: 100%;
            overflow-x: hidden;
        }

        .catalog-container .container {
            width: 100%;
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 1.25rem;
            box-sizing: border-box;
        }

        .catalog-meta-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 1.5rem;
            margin-bottom: 2.5rem;
            border-bottom: 1px solid var(--divider);
            flex-wrap: wrap;
            gap: 1rem;
        }

        .catalog-meta-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--heading);
            text-transform: uppercase;
            letter-spacing: 0.01em;
            line-height: 1.1;
        }

        .catalog-meta-count {
            font-size: 12px;
            color: var(--muted);
        }

        /* Products Grid: 4 columns strictly contained within the page width */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 1.15rem;
            width: 100%;
            box-sizing: border-box;
        }

        @media (max-width: 860px) {
            .products-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 1rem;
            }
        }

        @media (max-width: 500px) {
            .products-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }

        /* Product Card: Brushed Silver Platinum Metal with Micro-Texture & Holographic Shine */
        .product-card {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            padding: 0.95rem;
            display: flex;
            flex-direction: column;
            height: 480px;
            width: 100%;
            min-width: 0; /* Allows card to shrink within 4-column grid without pushing 4th card out */
            box-sizing: border-box;
            background: #3B3A38 !important;
            background-color: #3B3A38 !important;
            background-image: none !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            box-shadow:
                inset 0 1px 1px rgba(255, 255, 255, 0.12),
                0 14px 34px rgba(0, 0, 0, 0.42);
            transition: transform 260ms cubic-bezier(0.16, 1, 0.3, 1),
                        box-shadow 260ms cubic-bezier(0.16, 1, 0.3, 1),
                        border-color 260ms ease,
                        background 260ms ease;
            isolation: isolate;
        }

        /* Continuous subtle metallic glint along the top border */
        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10%;
            right: 10%;
            height: 1.5px;
            background: linear-gradient(90deg, transparent, #ffffff, #cbd5e1, #ffffff, transparent);
            pointer-events: none;
            z-index: 5;
            transition: all 300ms ease;
            box-shadow: 0 0 8px rgba(255, 255, 255, 0.6);
        }

        /* Holographic Metallic Shining Effect */
        .product-card::after {
            content: '';
            position: absolute;
            top: -60%;
            left: -80%;
            width: 250%;
            height: 220%;
            background: linear-gradient(
                115deg,
                transparent 15%,
                rgba(255, 255, 255, 0.04) 34%,
                rgba(226, 232, 240, 0.28) 44%,
                rgba(255, 255, 255, 0.68) 50%,
                rgba(203, 213, 225, 0.32) 54%,
                rgba(255, 255, 255, 0.04) 66%,
                transparent 85%
            );
            transform: translateX(-100%) rotate(25deg);
            transition: transform 0.85s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.35s ease;
            pointer-events: none;
            z-index: 20;
            opacity: 0;
        }

        .product-card:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 255, 255, 0.28) !important;
            background: #464542 !important;
            background-color: #464542 !important;
            background-image: none !important;
            box-shadow:
                inset 0 1px 1px rgba(255, 255, 255, 0.22),
                0 22px 46px rgba(0, 0, 0, 0.55),
                0 0 24px rgba(200, 177, 150, 0.16) !important;
        }

        .product-card:hover::before {
            left: 2%;
            right: 2%;
            background: linear-gradient(90deg, transparent, #ffffff, #e2e8f0, #ffffff, transparent);
            box-shadow: 0 0 12px rgba(255, 255, 255, 0.85);
        }

        .product-card:hover::after {
            opacity: 1;
            transform: translateX(100%) rotate(25deg);
        }

        /* Image area: Exactly 195px height and 100% width on all cards */
        .product-image-box {
            height: 195px;
            width: 100%;
            background-color: #08090b;
            border: 1px solid rgba(255, 255, 255, 0.06);
            position: relative;
            overflow: hidden;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        .product-image-box a {
            display: block;
            width: 100%;
            height: 100%;
        }

        .product-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 16px;
            display: block;
            transition: transform 0.45s ease;
        }

        .product-card:hover .product-image-box img {
            transform: scale(1.05);
        }

        .product-content {
            padding-top: 0.75rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
            min-width: 0;
            box-sizing: border-box;
        }

        /* 1. Category label (left) and rating (right) */
        .card-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.35rem;
            height: 26px;
            flex-shrink: 0;
            margin-bottom: 0.35rem;
            min-width: 0;
        }

        .card-category-pill {
            display: inline-flex;
            align-items: center;
            padding: 0.2rem 0.55rem;
            border-radius: 9999px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.14);
            font-size: 11px;
            font-weight: 600;
            color: #E2E8F0;
            letter-spacing: 0.02em;
            text-transform: capitalize;
            max-width: 105px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-rating-group {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 12px;
            font-weight: 700;
            color: #FFFFFF;
            line-height: 1;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .card-rating-star {
            color: #FFC107;
            font-size: 0.85rem;
            line-height: 1;
        }

        .card-rating-count {
            font-size: 11px;
            color: #8C96A5;
            font-weight: 400;
        }

        /* 2. Title: bold, white, single-line truncated */
        .product-card-title {
            font-family: var(--font-heading);
            font-size: 17px;
            font-weight: 700;
            color: #FFFFFF;
            height: 24px;
            line-height: 24px;
            margin-bottom: 0.25rem;
            text-decoration: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
            flex-shrink: 0;
            min-width: 0;
            transition: color 200ms ease;
        }

        .product-card-title:hover {
            color: var(--heading);
        }

        /* 3. Price & Delivery */
        .product-card-price {
            font-family: var(--font-heading);
            font-size: 23px;
            font-weight: 700;
            color: #FFFFFF;
            height: 26px;
            line-height: 26px;
            letter-spacing: -0.01em;
            margin-bottom: 0.15rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .product-price-meta {
            display: flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 11px;
            height: 18px;
            line-height: 18px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.6rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .product-mrp {
            color: #7C8390;
            white-space: nowrap;
        }

        .product-discount {
            color: #C8B196;
            font-weight: 700;
            white-space: nowrap;
        }

        .product-delivery-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.2rem;
            color: #C8B196;
            font-size: 11px;
            font-weight: 500;
            white-space: nowrap;
        }

        /* 4. Option Selector Section (Size or Quantity) */
        .card-options-section {
            margin-bottom: 0.75rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .card-options-label {
            font-size: 12px;
            font-weight: 600;
            color: #FFFFFF;
            height: 16px;
            line-height: 16px;
            margin-bottom: 0.35rem;
            white-space: nowrap;
        }

        .card-options-row {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            height: 36px;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .card-option-pill {
            flex: 1;
            min-width: 0;
            height: 36px;
            padding: 0;
            border-radius: 8px;
            background-color: #161922;
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: #FFFFFF;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 180ms ease;
            user-select: none;
            box-sizing: border-box;
        }

        .card-option-pill:hover {
            border-color: rgba(255, 255, 255, 0.35);
            background-color: #1E2330;
        }

        .card-option-pill.active {
            background: linear-gradient(135deg, #FFFFFF 0%, #E2E8F0 45%, #94A3B8 100%) !important;
            color: #0F172A !important;
            border-color: #F1F5F9 !important;
            box-shadow: 0 2px 8px rgba(255, 255, 255, 0.25);
        }

        /* 5. Bottom Action Row: Wide Buy Now Button + Cart Icon Button */
        .card-action-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            width: 100%;
            height: 44px;
            margin-top: auto;
            flex-shrink: 0;
            min-width: 0;
            box-sizing: border-box;
        }

        .btn-card-buy-now {
            flex: 1;
            min-width: 0;
            height: 44px;
            background: linear-gradient(135deg, #FFFFFF 0%, #E2E8F0 35%, #CBD5E1 70%, #94A3B8 100%) !important;
            color: #0F172A !important;
            font-weight: 700;
            border-radius: 9999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            cursor: pointer;
            border: 1px solid rgba(255, 255, 255, 0.6);
            transition: background 200ms ease, transform 150ms ease, box-shadow 200ms ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.35), inset 0 1px 1px #ffffff !important;
            letter-spacing: 0.01em;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-card-buy-now:hover:not(:disabled) {
            background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 45%, #E2E8F0 100%) !important;
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.45), 0 0 14px rgba(226, 232, 240, 0.4) !important;
        }

        .btn-card-buy-now:active:not(:disabled) {
            transform: translateY(0);
        }

        .btn-card-cart-icon {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #FFFFFF 0%, #E2E8F0 35%, #CBD5E1 70%, #94A3B8 100%) !important;
            color: #0F172A !important;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 1px solid rgba(255, 255, 255, 0.6);
            transition: background 200ms ease, transform 150ms ease, box-shadow 200ms ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.35), inset 0 1px 1px #ffffff !important;
            flex-shrink: 0;
            padding: 0;
        }

        .btn-card-cart-icon:hover:not(:disabled) {
            background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 45%, #E2E8F0 100%) !important;
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.45), 0 0 14px rgba(226, 232, 240, 0.4) !important;
        }

        .btn-card-cart-icon:active:not(:disabled) {
            transform: translateY(0);
        }

        .btn-card-cart-icon .material-symbols-outlined {
            font-size: 1.25rem;
        }

        /* Floating Toast for AJAX feedback */
        .cart-toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #1C2631;
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #FFFFFF;
            padding: 0.9rem 1.4rem;
            border-radius: 14px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            z-index: 9999;
            transform: translateY(100px);
            opacity: 0;
            transition: transform 300ms cubic-bezier(0.16, 1, 0.3, 1), opacity 300ms ease;
            pointer-events: none;
        }

        .cart-toast.show {
            transform: translateY(0);
            opacity: 1;
            pointer-events: auto;
        }

        @keyframes badgePulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.35); }
            100% { transform: scale(1); }
        }

        .badge-bounce {
            animation: badgePulse 350ms ease-out;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<section class="store-hero">
    <div class="container">
        <h1 class="store-title">
            EXPLORE OUR COLLECTION
        </h1>
        <p class="store-subtitle">
            Discover quality electronics, fashion essentials, home appliances, and lifestyle accessories designed for modern living.
        </p>

        <div class="store-search-wrapper">
            <form action="<%= request.getContextPath() %>/products" method="get" class="store-search-bar">
                <span class="material-symbols-outlined" style="color: var(--color-on-surface-muted);">search</span>
                <input type="text" name="q" placeholder="Search products, brands, categories..." value="<%= searchQuery %>" autocomplete="off">
                <% if (!"all".equalsIgnoreCase(selectedCategory)) { %>
                    <input type="hidden" name="category" value="<%= selectedCategory %>">
                <% } %>
                <button type="submit" class="btn btn-primary btn-pill" style="padding: 0.45rem 1.15rem; font-size: 0.82rem;">
                    <span>Find</span>
                </button>
            </form>
        </div>

        <div class="category-pills-bar">
            <a href="<%= request.getContextPath() %>/products<%= !searchQuery.isEmpty() ? "?q=" + searchQuery : "" %>"
               class="category-pill <%= "all".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>All Products</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Electronics<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Electronics".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Electronics</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Fashion%20%26%20Style<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("fashion") || selectedCategory.toLowerCase().contains("style")) ? "active" : "" %>">
                <span>Fashion & Style</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Home%20%26%20Kitchen<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("home") || selectedCategory.toLowerCase().contains("kitchen")) ? "active" : "" %>">
                <span>Home & Kitchen</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Accessories<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Accessories".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Accessories</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Books<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Books".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Books</span>
            </a>
        </div>
    </div>
</section>

<main class="catalog-container">
    <div class="container">
        <% if (cartMessage != null) { %>
            <div class="alert-box alert-box-success" style="margin-bottom: 2rem;">
                <span class="material-symbols-outlined">check_circle</span>
                <span><%= cartMessage %></span>
            </div>
        <% } %>

        <% if (cartError != null) { %>
            <div class="alert-box alert-box-error" style="margin-bottom: 2rem;">
                <span class="material-symbols-outlined">warning</span>
                <span><%= cartError %></span>
            </div>
        <% } %>

        <div class="catalog-meta-bar">
            <div class="catalog-meta-title">
                <% if (!"all".equalsIgnoreCase(selectedCategory)) { %>
                    <span><%= selectedCategory %></span>
                <% } else if (!searchQuery.isEmpty()) { %>
                    <span>Search results for "<%= searchQuery %>"</span>
                <% } else { %>
                    <span>Featured Catalog</span>
                <% } %>
            </div>
            <div class="catalog-meta-count">
                Showing <%= products != null ? products.size() : 0 %> items
            </div>
        </div>

        <div class="products-grid">
            <% if (products != null && !products.isEmpty()) { %>
                <% for (Product p : products) { 
                    long pid = (p.getId() != null) ? p.getId() : 1L;
                    double ratingVal = 4.3 + (pid % 7) * 0.1;
                    if (ratingVal > 4.9) ratingVal = 4.9;
                    int reviewCount = 85 + (int)((pid * 43) % 450);
                    int discountPct = 18 + (int)((pid * 9) % 23);
                    BigDecimal currentPrice = (p.getPrice() != null) ? p.getPrice() : BigDecimal.ZERO;
                    BigDecimal mrpPrice = currentPrice.multiply(BigDecimal.valueOf(100 + discountPct)).divide(BigDecimal.valueOf(100), 0, java.math.RoundingMode.HALF_UP);
                %>
                    <div class="product-card">
                        <div class="product-image-box">
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" style="display: block; width: 100%; height: 100%;">
                                <% 
                                    String pImg = p.getImageUrl();
                                    if (pImg != null && !pImg.isBlank()) {
                                        if (!pImg.startsWith("http://") && !pImg.startsWith("https://")) {
                                            if (!pImg.startsWith("/")) {
                                                pImg = "/" + pImg;
                                            }
                                            pImg = request.getContextPath() + pImg;
                                        }
                                %>
                                    <img src="<%= pImg %>" alt="<%= p.getName() %>" loading="lazy" onerror="this.src='https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80'">
                                <% } else { %>
                                    <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80" alt="Product Image">
                                <% } %>
                            </a>

                            <div style="position: absolute; top: 12px; right: 12px; z-index: 5;">
                                <% if (p.getStockQty() > 10) { %>
                                    <span class="badge-tag badge-in-stock" style="padding: 0.35rem 0.75rem; font-size: 0.72rem; font-weight: 700; border-radius: var(--radius-pill); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); background: rgba(10, 14, 20, 0.92); border: 1px solid rgba(200, 177, 150, 0.45); color: #C8B196; box-shadow: none; display: inline-flex; align-items: center; gap: 5px;"><span style="width: 5px; height: 5px; border-radius: 50%; background: #C8B196; box-shadow: 0 0 6px #C8B196; flex-shrink: 0;"></span>In Stock</span>
                                <% } else if (p.getStockQty() > 0) { %>
                                    <span class="badge-tag badge-low-stock" style="padding: 0.35rem 0.75rem; font-size: 0.72rem; font-weight: 700; border-radius: var(--radius-pill); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); background: rgba(10, 14, 20, 0.92); border: 1px solid rgba(251, 191, 36, 0.45); color: #fbbf24; box-shadow: none; display: inline-flex; align-items: center; gap: 5px;"><span style="width: 5px; height: 5px; border-radius: 50%; background: #fbbf24; box-shadow: 0 0 6px #fbbf24; flex-shrink: 0;"></span>Only <%= p.getStockQty() %> Left</span>
                                <% } else { %>
                                    <span class="badge-tag badge-out-stock" style="padding: 0.35rem 0.75rem; font-size: 0.72rem; font-weight: 700; border-radius: var(--radius-pill); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); background: rgba(10, 14, 20, 0.92); border: 1px solid rgba(248, 113, 113, 0.45); color: #f87171; box-shadow: none; display: inline-flex; align-items: center; gap: 5px;"><span style="width: 5px; height: 5px; border-radius: 50%; background: #f87171; box-shadow: 0 0 6px #f87171; flex-shrink: 0;"></span>Sold Out</span>
                                <% } %>
                            </div>
                        </div>

                        <div class="product-content">
                            <div class="card-meta-row">
                                <span class="card-category-pill"><%= p.getCategory() != null ? p.getCategory() : "General" %></span>
                                <div class="card-rating-group">
                                    <span class="card-rating-star">★</span>
                                    <span><%= String.format(Locale.US, "%.2f", ratingVal) %></span>
                                    <span class="card-rating-count">(<%= reviewCount %>)</span>
                                </div>
                            </div>

                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" class="product-card-title" title="<%= p.getName() %>">
                                <%= p.getName() %>
                            </a>

                            <div class="product-card-price">
                                ₹ <%= String.format(Locale.US, "%,.0f", currentPrice) %>
                            </div>

                            <div class="product-price-meta">
                                <span class="product-mrp">M.R.P.: <span style="text-decoration: line-through;">₹<%= String.format(Locale.US, "%,.0f", mrpPrice) %></span></span>
                                <span class="product-discount"><%= discountPct %>% OFF</span>
                                <span class="product-delivery-badge">
                                    <span class="material-symbols-outlined" style="font-size: 0.95rem;">local_shipping</span>
                                    FREE Delivery
                                </span>
                            </div>

                            <%
                                String cat = (p.getCategory() != null) ? p.getCategory().toLowerCase() : "";
                                String pName = (p.getName() != null) ? p.getName().toLowerCase() : "";
                                boolean isFootwear = cat.contains("shoe") || cat.contains("sneaker") || cat.contains("footwear") || cat.contains("sandal") || pName.contains("sandal") || pName.contains("loafer") || pName.contains("sneaker") || pName.contains("shoe");
                                boolean isClothing = (cat.contains("fashion") || cat.contains("style") || cat.contains("apparel") || cat.contains("cloth") || cat.contains("wear"))
                                        && !isFootwear && !pName.contains("cap") && !pName.contains("hat") && !pName.contains("belt") && !pName.contains("wallet") && !pName.contains("bag") && !pName.contains("purse") && !pName.contains("watch");
                                String optLabel = (isFootwear || isClothing) ? "What is your size ?" : "Select Quantity :";
                                String[] options;
                                int defaultIdx;
                                if (isFootwear) {
                                    options = new String[]{"39", "40", "41", "42"};
                                    defaultIdx = 1; // 40 selected by default
                                } else if (isClothing) {
                                    options = new String[]{"S", "M", "L", "XL"};
                                    defaultIdx = 1; // M selected
                                } else {
                                    options = new String[]{"1", "2", "3", "4"};
                                    defaultIdx = 0; // 1 selected
                                }
                            %>
                            <div class="card-options-section">
                                <div class="card-options-label"><%= optLabel %></div>
                                <div class="card-options-row">
                                    <% for (int oi = 0; oi < options.length; oi++) { 
                                        String opt = options[oi];
                                        boolean isActive = (oi == defaultIdx);
                                    %>
                                        <button type="button" class="card-option-pill <%= isActive ? "active" : "" %>" data-val="<%= opt %>">
                                            <%= opt %>
                                        </button>
                                    <% } %>
                                </div>
                            </div>

                            <% if (p.getStockQty() > 0) { %>
                                <form action="<%= request.getContextPath() %>/cart/add" method="post" class="card-action-row product-card-form"
                                      data-product-id="<%= p.getId() %>"
                                      data-product-name="<%= p.getName().replace("\"", "&quot;") %>"
                                      data-product-price="₹<%= String.format(Locale.US, "%,.0f", currentPrice) %>">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="hidden" name="quantity" class="card-hidden-qty" value="<%= (isFootwear || isClothing) ? "1" : options[defaultIdx] %>">
                                    <input type="hidden" name="size" class="card-hidden-size" value="<%= (isFootwear || isClothing) ? options[defaultIdx] : "" %>">
                                    <input type="hidden" name="buyNow" class="card-buynow-flag" value="false">

                                    <button type="submit" class="btn-card-buy-now btn-buy-now">
                                        Buy Now
                                    </button>

                                    <button type="button" class="btn-card-cart-icon btn-add-cart-ajax" aria-label="Add to Cart" title="Add to Cart">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                    </button>
                                </form>
                            <% } else { %>
                                <div class="card-action-row">
                                    <button type="button" class="btn-card-buy-now" disabled style="opacity: 0.5; cursor: not-allowed; background: var(--pill-inactive-bg); color: var(--muted) !important;">
                                        Sold Out
                                    </button>
                                    <button type="button" class="btn-card-cart-icon" disabled style="opacity: 0.5; cursor: not-allowed; background: var(--pill-inactive-bg); color: var(--muted) !important;">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem;">
                    <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--color-on-surface-muted); margin-bottom: 1rem;">search_off</span>
                    <h3 style="margin-bottom: 0.5rem; color: #ffffff;">No products found</h3>
                    <p style="color: var(--color-on-surface-variant); margin-bottom: 1.5rem;">Try adjusting your search query or selecting a different category pill.</p>
                    <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-pill">Clear All Filters</a>
                </div>
            <% } %>
        </div>
    </div>
</main>

<div id="cartToast" class="cart-toast" role="status" aria-live="polite">
    <span class="material-symbols-outlined" style="color: #2ED8A3; font-size: 1.35rem;">check_circle</span>
    <span id="cartToastMsg">Product added to cart!</span>
</div>

<%@ include file="/includes/footer.jspf" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toastEl = document.getElementById('cartToast');
        const toastMsgEl = document.getElementById('cartToastMsg');
        let toastTimeout = null;

        function showToast(message) {
            if (!toastEl || !toastMsgEl) return;
            toastMsgEl.textContent = message;
            toastEl.classList.add('show');
            if (toastTimeout) clearTimeout(toastTimeout);
            toastTimeout = setTimeout(function() {
                toastEl.classList.remove('show');
            }, 3000);
        }

        // Option Pills selection (Size / Quantity)
        document.querySelectorAll('.card-options-row').forEach(function(row) {
            const pills = row.querySelectorAll('.card-option-pill');
            const card = row.closest('.product-card');
            const form = card ? card.querySelector('.product-card-form') : null;
            if (!form) return;

            const qtyInput = form.querySelector('.card-hidden-qty');
            const sizeInput = form.querySelector('.card-hidden-size');
            const labelEl = row.closest('.card-options-section').querySelector('.card-options-label');
            const isSizeOption = labelEl && labelEl.textContent.toLowerCase().includes('size');

            pills.forEach(function(pill) {
                pill.addEventListener('click', function(e) {
                    e.preventDefault();
                    pills.forEach(p => p.classList.remove('active'));
                    pill.classList.add('active');
                    const selectedVal = pill.getAttribute('data-val');

                    if (isSizeOption) {
                        if (sizeInput) sizeInput.value = selectedVal;
                        if (qtyInput) qtyInput.value = '1';
                    } else {
                        if (qtyInput) qtyInput.value = selectedVal;
                    }
                });
            });
        });

        // "Buy Now" handler: sets buyNow=true and submits form → CartServlet redirects to /checkout
        document.querySelectorAll('.btn-buy-now').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const form = btn.closest('form');
                if (!form) return;
                const buyNowInput = form.querySelector('.card-buynow-flag');
                if (buyNowInput) {
                    buyNowInput.value = 'true';
                }
                form.submit();
            });
        });

        // "Cart Icon" AJAX Add to Cart handler
        document.querySelectorAll('.btn-add-cart-ajax').forEach(function(cartBtn) {
            cartBtn.addEventListener('click', function(e) {
                e.preventDefault();
                const form = cartBtn.closest('form');
                if (!form) return;

                const productId = form.querySelector('input[name="productId"]').value;
                const quantity = form.querySelector('.card-hidden-qty').value || '1';
                const size = form.querySelector('.card-hidden-size') ? form.querySelector('.card-hidden-size').value : '';
                const productName = form.getAttribute('data-product-name') || 'Item';

                const params = new URLSearchParams();
                params.append('productId', productId);
                params.append('quantity', quantity);
                if (size) params.append('size', size);
                params.append('ajax', 'true');

                // Animate button feedback
                const icon = cartBtn.querySelector('.material-symbols-outlined');
                const origIconText = icon ? icon.textContent : 'shopping_cart';

                fetch('<%= request.getContextPath() %>/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: params.toString()
                })
                .then(function(res) {
                    if (res.status === 401) {
                        // User not logged in, redirect to login page
                        window.location.href = '<%= request.getContextPath() %>/login.jsp';
                        return null;
                    }
                    return res.json();
                })
                .then(function(data) {
                    if (!data) return;

                    if (data.redirect) {
                        window.location.href = data.redirect;
                        return;
                    }

                    if (data.success) {
                        // Update cart badge in navbar
                        const badge = document.getElementById('navCartBadge');
                        if (badge && data.itemCount !== undefined) {
                            badge.textContent = data.itemCount;
                            badge.style.display = data.itemCount > 0 ? 'inline-flex' : 'none';
                            badge.classList.remove('badge-bounce');
                            void badge.offsetWidth; // trigger reflow
                            badge.classList.add('badge-bounce');
                        }

                        // Button icon temporary checkmark
                        if (icon) {
                            icon.textContent = 'done';
                            setTimeout(function() {
                                icon.textContent = origIconText;
                            }, 1200);
                        }

                        showToast('Added ' + productName + ' to your cart');
                    } else {
                        showToast(data.message || 'Could not add item to cart');
                    }
                })
                .catch(function(err) {
                    console.error('Cart add error:', err);
                    // Fallback to normal form submit if fetch fails
                    form.submit();
                });
            });
        });
    });
</script>

</body>
</html>
