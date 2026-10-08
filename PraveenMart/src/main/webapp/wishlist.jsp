<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.WishlistItem" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    List<WishlistItem> wishlistItems = (List<WishlistItem>) request.getAttribute("wishlistItems");
    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError = (String) session.getAttribute("msgError");
    session.removeAttribute("msgSuccess");
    session.removeAttribute("msgError");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=6.0">
    <style>
        body { background-color: #000000; }
        .wishlist-wrapper { padding: 3rem 0 6rem; position: relative; }
        .wishlist-header { margin-bottom: 2.5rem; }
        .wishlist-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 2.2rem;
            font-weight: 700;
            color: #FFFFFF;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
        }
        .wishlist-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #888888;
        }
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }
        .wishlist-card {
            background: #121212;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }
        .wishlist-card:hover {
            transform: translateY(-4px);
            border-color: rgba(255, 255, 255, 0.2);
        }
        .wishlist-img-box {
            position: relative;
            width: 100%;
            height: 220px;
            background: #181818;
            overflow: hidden;
        }
        .wishlist-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .wishlist-card:hover .wishlist-img-box img {
            transform: scale(1.05);
        }
        .wishlist-content {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .wishlist-category {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #ff9800;
            font-weight: 600;
            margin-bottom: 0.35rem;
        }
        .wishlist-prod-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: #FFFFFF;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }
        .wishlist-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #4CAF50;
            margin-bottom: 1rem;
        }
        .wishlist-actions {
            margin-top: auto;
            display: flex;
            gap: 0.75rem;
        }
        .btn-move-cart {
            flex: 1;
            background: #FFFFFF;
            color: #000000;
            font-weight: 600;
            border: none;
            padding: 0.65rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            font-size: 0.9rem;
            transition: background 0.2s;
        }
        .btn-move-cart:hover {
            background: #E0E0E0;
        }
        .btn-remove-wishlist {
            background: transparent;
            color: #FF5252;
            border: 1px solid rgba(255, 82, 82, 0.3);
            border-radius: 8px;
            padding: 0.65rem 0.85rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-remove-wishlist:hover {
            background: rgba(255, 82, 82, 0.1);
            border-color: #FF5252;
        }
        .empty-wishlist-box {
            text-align: center;
            padding: 4rem 2rem;
            background: #111111;
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 16px;
            max-width: 600px;
            margin: 2rem auto;
        }
        .empty-icon { font-size: 3.5rem; margin-bottom: 1rem; }
        .alert-toast {
            padding: 1rem 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        .alert-success { background: rgba(76, 175, 80, 0.15); border: 1px solid #4CAF50; color: #81C784; }
        .alert-danger { background: rgba(244, 67, 54, 0.15); border: 1px solid #F44336; color: #E57373; }

        /* Mobile Screen Responsiveness */
        @media (max-width: 640px) {
            .wishlist-wrapper {
                padding: 1.25rem 0 3.5rem;
            }
            .wishlist-header {
                margin-bottom: 1.25rem;
            }
            .wishlist-title {
                font-size: 1.4rem;
                letter-spacing: -0.02em;
            }
            .wishlist-subtitle {
                font-size: 0.76rem;
                line-height: 1.4;
            }
            .wishlist-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 0.65rem;
            }
            .wishlist-card {
                border-radius: 8px;
            }
            .wishlist-img-box {
                height: 135px;
            }
            .wishlist-content {
                padding: 0.65rem;
            }
            .wishlist-category {
                font-size: 0.62rem;
                margin-bottom: 0.2rem;
            }
            .wishlist-prod-title {
                font-size: 0.82rem;
                margin-bottom: 0.35rem;
                line-height: 1.25;
            }
            .wishlist-price {
                font-size: 0.95rem;
                margin-bottom: 0.65rem;
            }
            .wishlist-actions {
                gap: 0.35rem;
            }
            .btn-move-cart {
                padding: 0.45rem 0.35rem;
                font-size: 0.72rem;
                border-radius: 6px;
            }
            .btn-remove-wishlist {
                padding: 0.45rem 0.55rem;
                font-size: 0.75rem;
                border-radius: 6px;
            }
            .wishlist-wrapper {
                width: 100%;
                max-width: 100%;
                overflow-x: hidden;
                box-sizing: border-box;
            }
            .empty-wishlist-box {
                padding: 2.25rem 1rem;
                border-radius: 12px;
                margin: 1rem auto;
            }
            .empty-icon {
                font-size: 2.5rem;
                margin-bottom: 0.65rem;
            }
        }

        @media (max-width: 440px) {
            .wishlist-grid {
                grid-template-columns: 1fr;
            }
            .wishlist-img-box {
                height: 190px;
            }
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<div class="container wishlist-wrapper">
    <div class="wishlist-header">
        <h1 class="wishlist-title">My Wishlist & Saved Items</h1>
        <p class="wishlist-subtitle">Requirement O1 &mdash; Save items for later and move them effortlessly to your shopping cart.</p>
    </div>

    <% if (msgSuccess != null) { %>
        <div class="alert-toast alert-success"><%= msgSuccess %></div>
    <% } %>
    <% if (msgError != null) { %>
        <div class="alert-toast alert-danger"><%= msgError %></div>
    <% } %>

    <% if (wishlistItems == null || wishlistItems.isEmpty()) { %>
        <div class="empty-wishlist-box">
            <div class="empty-icon">🤍</div>
            <h2 style="color: #fff; margin-bottom: 0.75rem;">Your Wishlist is Empty</h2>
            <p style="color: #888; margin-bottom: 1.5rem;">Explore our curated multi-seller marketplace and save your favorite products for later!</p>
            <a href="<%= request.getContextPath() %>/products" class="btn-move-cart" style="display: inline-block; padding: 0.75rem 2rem; text-decoration: none;">Browse Products</a>
        </div>
    <% } else { %>
        <div class="wishlist-grid">
            <% for (WishlistItem item : wishlistItems) {
                Product p = item.getProduct();
                if (p == null) continue;
            %>
                <div class="wishlist-card">
                    <div class="wishlist-img-box">
                        <img src="<%= request.getContextPath() %><%= p.getImageUrl() != null ? p.getImageUrl() : "/images/placeholder.jpg" %>"
                             alt="<%= p.getName() %>"
                             onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                    </div>
                    <div class="wishlist-content">
                        <div class="wishlist-category"><%= p.getCategory() %></div>
                        <h3 class="wishlist-prod-title">
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" style="color: inherit; text-decoration: none;">
                                <%= p.getName() %>
                            </a>
                        </h3>
                        <div class="wishlist-price"><%= currencyFormat.format(p.getPrice()) %></div>
                        <div class="wishlist-actions">
                            <form action="<%= request.getContextPath() %>/wishlist/move-to-cart" method="post" class="wishlist-action-form" style="flex: 1; margin: 0;">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <button type="submit" class="btn-move-cart">Move to Cart</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/wishlist/remove" method="post" class="wishlist-action-form" style="margin: 0;">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <button type="submit" class="btn-remove-wishlist" title="Remove from wishlist">✕</button>
                            </form>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<div id="wishlistToast" class="cart-toast" role="status" aria-live="polite" style="position: fixed; bottom: 2rem; right: 2rem; background: #09090B; border: 1px solid #27272A; color: #FFFFFF; padding: 0.75rem 1.25rem; border-radius: 4px; font-family: var(--font-mono, 'JetBrains Mono', monospace); font-size: 13px; display: flex; align-items: center; gap: 0.75rem; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.8); z-index: 9999; transform: translateY(100px); opacity: 0; transition: transform 300ms cubic-bezier(0.16, 1, 0.3, 1), opacity 300ms ease; pointer-events: none;">
    <span class="material-symbols-outlined" style="color: #2ED8A3; font-size: 1.35rem;">check_circle</span>
    <span id="wishlistToastMsg">Action completed</span>
</div>

<%@ include file="/includes/footer.jspf" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toastEl = document.getElementById('wishlistToast');
        const toastMsg = document.getElementById('wishlistToastMsg');
        let toastTimeout = null;

        function showToast(message) {
            if (!toastEl || !toastMsg) return;
            toastMsg.textContent = message;
            toastEl.style.transform = 'translateY(0)';
            toastEl.style.opacity = '1';
            toastEl.style.pointerEvents = 'auto';
            if (toastTimeout) clearTimeout(toastTimeout);
            toastTimeout = setTimeout(function() {
                toastEl.style.transform = 'translateY(100px)';
                toastEl.style.opacity = '0';
                toastEl.style.pointerEvents = 'none';
            }, 3000);
        }

        document.querySelectorAll('.wishlist-action-form').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const card = form.closest('.wishlist-card');
                const actionUrl = form.getAttribute('action');
                const productId = form.querySelector('input[name="productId"]').value;
                const submitBtn = form.querySelector('button');

                if (submitBtn) submitBtn.disabled = true;

                const params = new URLSearchParams();
                params.append('productId', productId);
                params.append('ajax', 'true');

                fetch(actionUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        'Accept': 'application/json'
                    },
                    body: params.toString()
                })
                .then(function(res) {
                    if (res.status === 401) {
                        window.location.href = '<%= request.getContextPath() %>/login.jsp';
                        return null;
                    }
                    return res.json();
                })
                .then(function(data) {
                    if (!data) return;

                    if (data.success) {
                        // Update cart badge if returned
                        if (data.cartCount !== undefined) {
                            const badge = document.getElementById('navCartBadge');
                            if (badge) {
                                badge.textContent = data.cartCount;
                                badge.style.display = data.cartCount > 0 ? 'inline-flex' : 'none';
                                badge.classList.remove('badge-bounce');
                                void badge.offsetWidth;
                                badge.classList.add('badge-bounce');
                            }
                        }

                        // Animate card removal smoothly without page scroll jump
                        if (card) {
                            card.style.transition = 'all 280ms ease';
                            card.style.opacity = '0';
                            card.style.transform = 'scale(0.92)';
                            setTimeout(function() {
                                card.remove();
                                const remaining = document.querySelectorAll('.wishlist-card');
                                if (remaining.length === 0) {
                                    window.location.reload();
                                }
                            }, 280);
                        }

                        showToast(data.message || 'Updated successfully');
                    } else {
                        if (submitBtn) submitBtn.disabled = false;
                        showToast(data.message || 'Operation failed');
                    }
                })
                .catch(function(err) {
                    console.error('Wishlist action error:', err);
                    if (submitBtn) submitBtn.disabled = false;
                    form.submit(); // fallback to normal submit
                });
            });
        });
    });
</script>

</body>
</html>
