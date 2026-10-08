<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        com.praveen.praveenmart.service.UserService userService = new com.praveen.praveenmart.service.UserService();
        User fresh = userService.findById(user.getId());
        if (fresh != null) {
            user = fresh;
            session.setAttribute("user", fresh);
        }
    }
    String updated = request.getParameter("updated");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Dashboard - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=6.0">
    <style>
        body {
            background-color: #000000;
        }

        .dashboard-container {
            max-width: 620px;
            margin: 3.5rem auto 6rem auto;
        }

        .profile-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 2.75rem 2.25rem;
            text-align: center;
        }

        .avatar-box {
            width: 72px;
            height: 72px;
            border-radius: 4px;
            background: #0C0C0C;
            border: 1px solid #27272A;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
        }

        .info-list {
            display: flex;
            flex-direction: column;
            gap: 0.65rem;
            margin: 1.75rem 0;
            text-align: left;
        }

        .info-item {
            background-color: #000000;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0.85rem 1.15rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .info-key {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.78rem;
            font-weight: 600;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .info-val {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            font-weight: 600;
            color: #FFFFFF;
        }

        /* Default Delivery Address Section */
        .default-address-card {
            background-color: #000000;
            border: 1px solid #27272A;
            border-radius: 6px;
            padding: 1.35rem 1.25rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .default-address-card.highlight {
            border-color: #3F3F46;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #1E1E22;
        }

        .address-title-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .address-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 0.95rem;
            font-weight: 700;
            color: #FFFFFF;
        }

        .address-badge {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.68rem;
            font-weight: 600;
            padding: 2px 7px;
            border-radius: 3px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .address-badge-active {
            background: #0D1F12;
            border: 1px solid #1E3A24;
            color: #4ADE80;
        }

        .address-badge-empty {
            background: #111113;
            border: 1px solid #27272A;
            color: #A1A1AA;
        }

        .address-details {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.84rem;
            color: #D4D4D8;
            line-height: 1.5;
        }

        .address-details .row-label {
            color: #71717A;
            font-size: 0.74rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            display: inline-block;
            width: 100px;
        }

        .address-empty-state {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            color: #888888;
            line-height: 1.6;
        }

        .address-edit-box {
            display: none;
            margin-top: 1.25rem;
            padding-top: 1.25rem;
            border-top: 1px dashed #27272A;
        }

        .address-edit-box.open {
            display: block;
        }

        .edit-toggle-btn {
            background: #111113;
            border: 1px solid #27272A;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.75rem;
            padding: 0.35rem 0.75rem;
            border-radius: 4px;
            cursor: pointer;
            transition: all 150ms ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .edit-toggle-btn:hover {
            background: #1E1E22;
            border-color: #3F3F46;
        }

        .account-input {
            width: 100%;
            height: 38px;
            background: #050505;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0 0.75rem;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            outline: none;
            box-sizing: border-box;
            transition: border-color 150ms ease;
        }

        .account-input:focus {
            border-color: #FFFFFF;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .form-grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        @media (max-width: 600px) {
            .dashboard-container {
                margin: 1.5rem auto 3.5rem auto;
                width: 100%;
                max-width: 100%;
                box-sizing: border-box;
            }
            .profile-card {
                padding: 1.75rem 1.15rem;
                width: 100%;
                box-sizing: border-box;
            }
            .form-grid-2, .form-grid-3 {
                grid-template-columns: 1fr;
            }
            .info-item {
                padding: 0.75rem 0.85rem;
                flex-wrap: wrap;
                gap: 0.35rem;
            }
        }
    </style>
</head>
<body>

    <%@ include file="/includes/header.jspf" %>

    <main class="container">
        <div class="dashboard-container">

            <% if ("true".equals(updated)) { %>
                <div class="alert-box alert-box-success" style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem; background: #071509; border: 1px solid #1E3A24; color: #4ADE80; padding: 0.85rem 1.25rem; border-radius: 4px; font-family: var(--font-mono); font-size: 0.82rem;">
                    <span class="material-symbols-outlined" style="font-size: 1.2rem;">check_circle</span>
                    <span>Default delivery address updated successfully in your account!</span>
                </div>
            <% } %>

            <% if (user != null) { %>
                <div class="profile-card">
                    <div class="avatar-box">
                        <%= (user.getName() != null && !user.getName().isBlank()) ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                    </div>

                    <h1 style="font-family: var(--font-heading); font-size: 1.8rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.35rem; color: #FFFFFF;">
                        <%= user.getName() %>
                    </h1>
                    <p style="font-family: var(--font-mono); color: #888888; font-size: 0.82rem;">member &bull; <%= user.getRole().toLowerCase() %></p>

                    <div class="info-list">
                        <div class="info-item">
                            <span class="info-key">Name</span>
                            <span class="info-val"><%= user.getName() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Email</span>
                            <span class="info-val"><%= user.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Status</span>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #FFFFFF; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Active</span>
                        </div>
                    </div>

                    <!-- ── Default Delivery Address Section ────────────────────── -->
                    <div class="default-address-card <%= user.hasDefaultAddress() ? "highlight" : "" %>">
                        <div class="address-header">
                            <div class="address-title-group">
                                <span class="material-symbols-outlined" style="font-size: 1.15rem; color: <%= user.hasDefaultAddress() ? "#4ADE80" : "#A1A1AA" %>;">
                                    <%= user.hasDefaultAddress() ? "home_pin" : "location_off" %>
                                </span>
                                <span class="address-title">Default Delivery Address</span>
                                <span class="address-badge <%= user.hasDefaultAddress() ? "address-badge-active" : "address-badge-empty" %>">
                                    <%= user.hasDefaultAddress() ? "Default" : "Not Set" %>
                                </span>
                            </div>

                            <button type="button" class="edit-toggle-btn" id="toggleAddressBtn" onclick="toggleAddressForm()">
                                <span class="material-symbols-outlined" style="font-size: 0.85rem;" id="toggleIcon">edit</span>
                                <span id="toggleText"><%= user.hasDefaultAddress() ? "Edit" : "+ Add" %></span>
                            </button>
                        </div>

                        <% if (user.hasDefaultAddress()) { %>
                            <div class="address-details" id="addressDisplay">
                                <div>
                                    <span class="row-label">Recipient:</span>
                                    <strong style="color: #FFFFFF;"><%= user.getRecipientName() != null && !user.getRecipientName().isBlank() ? user.getRecipientName() : user.getName() %></strong>
                                </div>
                                <% if (user.getPhone() != null && !user.getPhone().isBlank()) { %>
                                    <div>
                                        <span class="row-label">Phone:</span>
                                        <span><%= user.getPhone() %></span>
                                    </div>
                                <% } %>
                                <div>
                                    <span class="row-label">Address:</span>
                                    <span><%= user.getStreet() %></span>
                                </div>
                                <div>
                                    <span class="row-label">City / PIN:</span>
                                    <span><%= (user.getCity() != null ? user.getCity() : "") + (user.getState() != null ? ", " + user.getState() : "") + (user.getPincode() != null ? " - " + user.getPincode() : "") %></span>
                                </div>
                                <div style="margin-top: 0.35rem; font-size: 0.72rem; color: #71717A; display: flex; align-items: center; gap: 0.35rem;">
                                    <span class="material-symbols-outlined" style="font-size: 0.9rem; color: #4ADE80;">verified</span>
                                    <span>Pre-fills automatically during checkout for instant 1-click orders.</span>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="address-empty-state" id="addressDisplay">
                                <p style="margin: 0 0 0.5rem 0;">No default delivery address saved yet.</p>
                                <span style="font-size: 0.74rem; color: #71717A;">When you enter an address for delivery during checkout, it will automatically be saved default in your account. You can also add it now below.</span>
                            </div>
                        <% } %>

                        <!-- Inline Edit / Add Form -->
                        <div class="address-edit-box" id="addressEditBox">
                            <form action="<%= request.getContextPath() %>/account/address" method="post" id="accountAddressForm">
                                <div class="form-grid-2">
                                    <div>
                                        <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_recipientName">Recipient Name</label>
                                        <input type="text" id="acc_recipientName" name="recipientName" class="account-input"
                                               value="<%= user.getRecipientName() != null ? user.getRecipientName() : user.getName() %>"
                                               placeholder="Recipient name" required>
                                    </div>
                                    <div>
                                        <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_phone">Contact Phone</label>
                                        <input type="tel" id="acc_phone" name="phone" class="account-input"
                                               value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                               placeholder="+91 98765 43210" required>
                                    </div>
                                </div>

                                <div style="margin-bottom: 0.75rem;">
                                    <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_street">Street Address / House No.</label>
                                    <input type="text" id="acc_street" name="street" class="account-input"
                                           value="<%= user.getStreet() != null ? user.getStreet() : "" %>"
                                           placeholder="e.g. 42, Green Avenue, Anna Nagar" required>
                                </div>

                                <div class="form-grid-3">
                                    <div>
                                        <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_city">City</label>
                                        <input type="text" id="acc_city" name="city" class="account-input"
                                               value="<%= user.getCity() != null ? user.getCity() : "" %>"
                                               placeholder="Chennai" required>
                                    </div>
                                    <div>
                                        <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_state">State</label>
                                        <input type="text" id="acc_state" name="state" class="account-input"
                                               value="<%= user.getState() != null ? user.getState() : "" %>"
                                               placeholder="Tamil Nadu" required>
                                    </div>
                                    <div>
                                        <label class="form-label" style="font-size: 0.72rem; margin-bottom: 0.3rem;" for="acc_pincode">PIN Code</label>
                                        <input type="text" id="acc_pincode" name="pincode" class="account-input"
                                               value="<%= user.getPincode() != null ? user.getPincode() : "" %>"
                                               placeholder="600025" required>
                                    </div>
                                </div>

                                <div style="display: flex; gap: 0.5rem; justify-content: flex-end; margin-top: 1rem;">
                                    <button type="button" class="btn btn-outlined" onclick="toggleAddressForm()" style="padding: 0.45rem 1rem; font-size: 0.78rem; font-family: var(--font-mono);">
                                        Cancel
                                    </button>
                                    <button type="submit" class="btn btn-primary" style="padding: 0.45rem 1.25rem; font-size: 0.78rem; font-family: var(--font-mono); font-weight: 600;">
                                        Save Default Address
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <% if ("ADMIN".equalsIgnoreCase(user.getRole()) && "admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) { %>
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">admin_panel_settings</span>
                                <span>Open Admin Control Center</span>
                            </a>
                        <% } %>

                        <% if ("SELLER".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/seller/dashboard" class="btn btn-secondary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">inventory_2</span>
                                <span>Open Seller Hub & Inventory</span>
                            </a>
                        <% } %>

                        <% if (!"ADMIN".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/orders" class="btn btn-secondary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">receipt_long</span>
                                <span>My Order History</span>
                            </a>

                            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">storefront</span>
                                <span>Explore Products</span>
                            </a>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outlined" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-size: 0.85rem; padding: 0.75rem;">
                            <span class="material-symbols-outlined" style="font-size: 1.1rem;">logout</span>
                            <span>Sign Out</span>
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="profile-card">
                    <span class="material-symbols-outlined" style="font-size: 3rem; color: #3F3F46; margin-bottom: 1rem;">lock</span>
                    <h2 style="font-family: var(--font-heading); font-size: 1.6rem; font-weight: 700; letter-spacing: -0.02em; margin-bottom: 0.5rem; color: #FFFFFF;">Access Required</h2>
                    <p style="font-family: var(--font-mono); color: #888888; margin-bottom: 2rem; font-size: 0.88rem;">Please sign in to view your profile dashboard.</p>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary" style="padding: 0.75rem 2rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">Sign In</a>
                </div>
            <% } %>
        </div>
    </main>

    <%@ include file="/includes/footer.jspf" %>

    <script>
        function toggleAddressForm() {
            var box = document.getElementById('addressEditBox');
            var icon = document.getElementById('toggleIcon');
            var text = document.getElementById('toggleText');
            if (!box) return;

            var isOpen = box.classList.contains('open');
            if (isOpen) {
                box.classList.remove('open');
                if (icon) icon.textContent = 'edit';
                if (text) text.textContent = '<%= user != null && user.hasDefaultAddress() ? "Edit" : "+ Add" %>';
            } else {
                box.classList.add('open');
                if (icon) icon.textContent = 'close';
                if (text) text.textContent = 'Close';
                var firstInput = document.getElementById('acc_recipientName');
                if (firstInput) firstInput.focus();
            }
        }
    </script>

</body>
</html>
