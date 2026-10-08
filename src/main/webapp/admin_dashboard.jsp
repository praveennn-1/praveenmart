<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.dto.UserResponseDTO" %>
<%@ page import="com.praveen.praveenmart.model.Order" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    List<UserResponseDTO> users = (List<UserResponseDTO>) request.getAttribute("users");
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalBuyers = (Integer) request.getAttribute("totalBuyers");
    Integer totalSellers = (Integer) request.getAttribute("totalSellers");
    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");

    if (totalUsers == null) totalUsers = (users != null) ? users.size() : 0;
    if (totalBuyers == null) totalBuyers = 0;
    if (totalSellers == null) totalSellers = 0;
    if (totalProducts == null) totalProducts = (products != null) ? products.size() : 0;
    if (totalOrders == null) totalOrders = (orders != null) ? orders.size() : 0;
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError = (String) session.getAttribute("msgError");
    if (msgSuccess != null) session.removeAttribute("msgSuccess");
    if (msgError != null) session.removeAttribute("msgError");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Control Center - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        body {
            background-color: #000000;
        }

        .admin-main {
            padding: 3rem 0 5rem 0;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.5rem;
        }

        .stat-label {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.75rem;
            font-weight: 600;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.4rem;
        }

        .stat-val {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.8rem;
            font-weight: 700;
            color: #FFFFFF;
        }

        .admin-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid #1E1E22;
            padding-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .admin-tab-btn {
            background: #000000;
            border: 1px solid #27272A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            font-weight: 500;
            padding: 0.5rem 1.1rem;
            color: #A1A1AA;
            cursor: pointer;
            border-radius: 4px;
            transition: all 150ms ease;
        }

        .admin-tab-btn:hover {
            color: #FFFFFF;
            border-color: #3F3F46;
        }

        .admin-tab-btn.active {
            background: #FFFFFF !important;
            color: #000000 !important;
            border-color: #FFFFFF !important;
            font-weight: 600;
        }

        .admin-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
            margin-bottom: 2.5rem;
        }

        .table-wrap {
            overflow-x: auto;
            border-radius: 6px;
            border: 1px solid #222222;
            background-color: #050505;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.88rem;
        }

        th {
            background-color: #0A0A0A;
            color: #71717A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid #1E1E22;
        }

        td {
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid #1E1E22;
            vertical-align: middle;
            color: #E4E4E7;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #0A0A0A;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container admin-main">
    <div class="admin-header">
        <div>
            <div style="display: flex; align-items: center; gap: 0.6rem; margin-bottom: 0.5rem;">
                <span class="badge-tag" style="background-color: #0C0C0C; color: #FFFFFF; border: 1px solid #27272A; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">System Admin</span>
            </div>
            <h1 style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.35rem; line-height: 1.15; color: #FFFFFF;">Admin Control Center</h1>
            <p style="font-family: var(--font-mono); color: #888888; font-size: 0.85rem;">System overview, user oversight, marketplace orders, and catalog listing moderation.</p>
        </div>
    </div>

    <% if (msgSuccess != null) { %>
        <div class="alert-box alert-box-success">
            <span class="material-symbols-outlined">check_circle</span>
            <span><%= msgSuccess %></span>
        </div>
    <% } %>
    <% if (msgError != null) { %>
        <div class="alert-box alert-box-error">
            <span class="material-symbols-outlined">warning</span>
            <span><%= msgError %></span>
        </div>
    <% } %>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total Users</div>
            <div class="stat-val"><%= totalUsers %></div>
            <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #71717A; margin-top: 0.3rem;">
                <%= totalBuyers %> buyers · <%= totalSellers %> sellers
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Platform Products</div>
            <div class="stat-val"><%= totalProducts %></div>
            <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #71717A; margin-top: 0.3rem;">
                across all sellers
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Total Orders</div>
            <div class="stat-val"><%= totalOrders %></div>
            <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #71717A; margin-top: 0.3rem;">
                completed & processing
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Gross Value</div>
            <div class="stat-val" style="color: #FFFFFF;">
                <%= currencyFormat.format(totalRevenue) %>
            </div>
            <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #71717A; margin-top: 0.3rem;">
                platform total sales
            </div>
        </div>
    </div>

    <div class="admin-tabs">
        <button class="admin-tab-btn active" onclick="showAdminTab('users', this)">User Management (<%= totalUsers %>)</button>
        <button class="admin-tab-btn" onclick="showAdminTab('orders', this)">Platform Orders (<%= totalOrders %>)</button>
        <button class="admin-tab-btn" onclick="showAdminTab('products', this)">Catalog Moderation (<%= totalProducts %>)</button>
    </div>

    <div id="adm-users">
        <div class="admin-card">
            <h3 style="font-size: 1.3rem; margin-bottom: 1.25rem;">Registered Users Overview</h3>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Registration Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (users != null) { %>
                            <% for (UserResponseDTO u : users) { %>
                                <tr>
                                    <td><strong>#USR-<%= u.getId() %></strong></td>
                                    <td style="font-weight: 600;"><%= u.getName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td>
                                        <% if ("ADMIN".equalsIgnoreCase(u.getRole())) { %>
                                            <span class="badge-tag" style="background-color: #FEF7E0; color: #B06000;">ADMIN</span>
                                        <% } else if ("SELLER".equalsIgnoreCase(u.getRole())) { %>
                                            <span class="badge-tag badge-primary">SELLER</span>
                                        <% } else { %>
                                            <span class="badge-tag badge-tertiary">BUYER</span>
                                        <% } %>
                                    </td>
                                    <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toLocalDate() : "" %></td>
                                    <td>
                                        <% if (!"ADMIN".equalsIgnoreCase(u.getRole())) { %>
                                            <form action="<%= request.getContextPath() %>/admin/users/delete" method="post" onsubmit="return confirm('Delete this user account? This cannot be undone.');">
                                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                                <button type="submit" class="btn btn-danger btn-pill" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;">
                                                    <span class="material-symbols-outlined" style="font-size: 0.95rem;">delete</span>
                                                    <span>Remove</span>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span style="font-size: 0.8rem; color: var(--color-on-surface-variant); font-style: italic;">Protected</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="adm-orders" style="display: none;">
        <div class="admin-card">
            <h3 style="font-size: 1.3rem; margin-bottom: 1.25rem;">All Customer Orders</h3>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Buyer Details</th>
                            <th>Total Amount</th>
                            <th>Order Date</th>
                            <th>Fulfillment Status</th>
                            <th>Items</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders != null && !orders.isEmpty()) { %>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td><strong style="color: var(--color-primary);">#ORD-<%= o.getId() %></strong></td>
                                    <td>
                                        <div style="font-weight: 600;"><%= o.getBuyerName() != null ? o.getBuyerName() : "User #" + o.getBuyerId() %></div>
                                        <div style="font-size: 0.8rem; color: var(--color-on-surface-variant);"><%= o.getBuyerEmail() != null ? o.getBuyerEmail() : "" %></div>
                                    </td>
                                    <td style="font-weight: 700; font-size: 1.05rem; color: var(--color-neutral-dark);">
                                        <%= currencyFormat.format(o.getTotalAmount()) %>
                                    </td>
                                    <td><%= o.getCreatedAt() != null ? o.getCreatedAt().toLocalDate() : "" %></td>
                                    <td>
                                        <span class="badge-tag <%= "DELIVERED".equalsIgnoreCase(o.getStatus()) ? "badge-in-stock" : "badge-primary" %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.85rem; color: var(--color-on-surface-variant);">
                                            <%= o.getItems() != null ? o.getItems().size() : 0 %> line items
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 2rem; color: var(--color-on-surface-variant);">No orders placed on the platform yet.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="adm-products" style="display: none;">
        <div class="admin-card">
            <h3 style="font-size: 1.3rem; margin-bottom: 1.25rem;">Marketplace Listing Moderation</h3>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Title & Details</th>
                            <th>Seller</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Moderation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null && !products.isEmpty()) { %>
                            <% for (Product p : products) { %>
                                <tr>
                                    <td>
                                        <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>" style="width: 48px; height: 48px; object-fit: cover; border-radius: var(--radius-sm);" onerror="this.src='https://via.placeholder.com/48'">
                                    </td>
                                    <td>
                                        <div style="font-weight: 700;"><%= p.getName() %></div>
                                        <div style="font-size: 0.8rem; color: var(--color-on-surface-variant); max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= p.getDescription() %></div>
                                    </td>
                                    <td><%= p.getSellerName() != null ? p.getSellerName() : "Seller #" + p.getSellerId() %></td>
                                    <td><span class="badge-tag badge-primary"><%= p.getCategory() %></span></td>
                                    <td style="font-weight: 700;"><%= currencyFormat.format(p.getPrice()) %></td>
                                    <td><%= p.getStockQty() %></td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/admin/products/delete" method="post" onsubmit="return confirm('Moderate and remove this listing from the marketplace?');">
                                            <input type="hidden" name="id" value="<%= p.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-pill" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;">
                                                <span class="material-symbols-outlined" style="font-size: 0.95rem;">gavel</span>
                                                <span>Takedown</span>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script>
    function showAdminTab(tab, btn) {
        document.getElementById('adm-users').style.display = (tab === 'users') ? 'block' : 'none';
        document.getElementById('adm-orders').style.display = (tab === 'orders') ? 'block' : 'none';
        document.getElementById('adm-products').style.display = (tab === 'products') ? 'block' : 'none';
        document.querySelectorAll('.admin-tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }
</script>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
