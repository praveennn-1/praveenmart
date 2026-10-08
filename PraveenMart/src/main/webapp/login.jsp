<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.7">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-color: #000000;
            font-family: var(--font-body);
            color: #E2E8F0;
            overflow-x: hidden;
        }

        /* Centered Auth Layout */
        .auth-split-layout {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            width: 100%;
            padding: 3rem 1.5rem;
            background-color: #000000;
        }

        /* Form Card Container */
        .auth-form-side {
            width: 100%;
            max-width: 440px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2.75rem 2.25rem;
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
            position: relative;
            z-index: 10;
        }

        .auth-form-inner {
            width: 100%;
            max-width: 100%;
            display: flex;
            flex-direction: column;
        }

        .auth-brand-wrapper {
            margin-bottom: 2rem;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            width: 100%;
        }

        .auth-brand {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.25rem;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            text-decoration: none;
            transition: color 200ms ease;
        }

        .auth-brand:hover {
            color: #FFFFFF;
        }

        .auth-title {
            font-family: var(--font-heading, 'Manrope', sans-serif);
            font-size: 2rem;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -0.025em;
            line-height: 1.15;
            margin: 0 0 0.5rem 0;
            text-align: center;
        }

        .auth-subtitle {
            font-size: 0.92rem;
            color: #78808F;
            margin: 0 0 2rem 0;
            line-height: 1.5;
            font-weight: 400;
            text-align: center;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 1.25rem;
            position: relative;
        }

        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 500;
            color: #9CA3AF;
            margin-bottom: 0.45rem;
        }

        .form-input-box {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
        }

        .form-input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748B;
            font-size: 1.25rem;
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
            user-select: none;
            z-index: 2;
            line-height: 1;
        }

        .form-input-field,
        input.form-input-field,
        input[type="text"].form-input-field,
        input[type="email"].form-input-field {
            width: 100%;
            height: 44px;
            background: #050505;
            border: 1px solid #27272A;
            border-radius: var(--radius-sm, 6px);
            padding: 0 1rem 0 2.85rem !important;
            color: #FFFFFF;
            font-size: 0.88rem;
            font-family: var(--font-mono, monospace);
            outline: none;
            box-sizing: border-box;
            transition: all 180ms ease;
        }

        input[type="password"].form-input-field {
            width: 100%;
            height: 44px;
            background: #050505;
            border: 1px solid #27272A;
            border-radius: var(--radius-sm, 6px);
            padding: 0 2.85rem 0 2.85rem !important;
            color: #FFFFFF;
            font-size: 0.88rem;
            font-family: var(--font-mono, monospace);
            outline: none;
            box-sizing: border-box;
            transition: all 180ms ease;
            opacity: 1;
        }

        .form-input-field:focus {
            border-color: #FFFFFF !important;
            background: #0A0A0A !important;
            box-shadow: 0 0 0 1px #FFFFFF !important;
        }

        .form-input-field::placeholder {
            color: rgba(184, 190, 199, 0.38);
            opacity: 1;
        }

        .form-select-field,
        select.form-select-field {
            width: 100%;
            height: 48px;
            background: #111319;
            border: 1px solid rgba(255, 255, 255, 0.10);
            border-radius: 10px;
            padding: 0 2.5rem 0 2.85rem !important;
            color: #FFFFFF;
            font-size: 0.92rem;
            font-family: inherit;
            outline: none;
            box-sizing: border-box;
            appearance: none;
            -webkit-appearance: none;
            cursor: pointer;
            transition: border-color 200ms ease, box-shadow 200ms ease, background 200ms ease;
        }

        .form-select-field:focus {
            border-color: rgba(200, 177, 150, 0.65);
            background: #13161F;
            box-shadow: 0 0 0 3px rgba(200, 177, 150, 0.12);
        }

        .form-select-arrow {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748B;
            font-size: 1.3rem;
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
            user-select: none;
            line-height: 1;
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: #64748B;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 6px;
            border-radius: 6px;
            transition: color 200ms ease;
            user-select: none;
        }

        .password-toggle-btn:hover {
            color: #FFFFFF;
        }

        .password-toggle-btn .material-symbols-outlined {
            font-size: 1.25rem;
            line-height: 1;
        }

        /* Checkbox Options */
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0.25rem 0 1.75rem 0;
            font-size: 0.85rem;
            color: #7E8694;
        }

        .auth-checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            cursor: pointer;
            user-select: none;
            transition: color 200ms ease;
        }

        .auth-checkbox-label:hover {
            color: #FFFFFF;
        }

        .auth-checkbox-label input[type="checkbox"] {
            accent-color: #FFFFFF;
            cursor: pointer;
            width: 15px;
            height: 15px;
        }

        /* Submit Button: OpenCode High-Contrast White */
        .auth-submit-btn {
            width: 100%;
            height: 44px;
            background: #FFFFFF !important;
            border: 1px solid #FFFFFF !important;
            border-radius: var(--radius-sm, 6px);
            color: #000000 !important;
            font-family: var(--font-mono, monospace);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 180ms ease;
            box-shadow: none !important;
        }

        .auth-submit-btn span {
            color: #000000 !important;
        }

        .auth-submit-btn .material-symbols-outlined {
            color: #000000 !important;
            font-size: 1.15rem;
            font-weight: 700;
        }

        .auth-submit-btn:hover {
            background: #E4E4E7 !important;
            border-color: #E4E4E7 !important;
            transform: translateY(-1px);
        }

        .auth-submit-btn:active {
            transform: translateY(0);
        }

        /* Footer Link */
        .auth-footer-text {
            margin-top: 2.2rem;
            text-align: center;
            font-size: 0.9rem;
            color: #7E8694;
        }

        .auth-footer-text a {
            color: #FFFFFF;
            font-weight: 600;
            text-decoration: underline;
            margin-left: 0.3rem;
            transition: color 200ms ease;
        }

        .auth-footer-text a:hover {
            color: #C8B196;
        }

        /* Mobile / Responsive View */
        @media (max-width: 640px) {
            .auth-split-layout {
                padding: 1.5rem 1rem !important;
            }
            .auth-form-side {
                padding: 2rem 1.25rem !important;
            }
        }
    </style>
</head>
<body>

<div class="auth-split-layout">
    <!-- Left Column: Form Side -->
    <div class="auth-form-side">
        <div class="auth-form-inner">
            <div class="auth-brand-wrapper">
                <a href="<%= request.getContextPath() %>/" class="auth-brand">
                    <span>PRAVEENMART</span>
                </a>
            </div>

            <h1 class="auth-title">Welcome!</h1>
            <p class="auth-subtitle">Log in to PraveenMart to continue.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-box alert-box-error">
                    <span class="material-symbols-outlined">warning</span>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert-box alert-box-success">
                    <span class="material-symbols-outlined">check_circle</span>
                    <span><%= request.getAttribute("success") %></span>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label class="form-label" for="role">Select Role</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">badge</span>
                        <select class="form-select-field" id="role" name="role" required>
                            <option value="CUSTOMER" selected>Customer</option>
                            <option value="SELLER">Seller</option>
                        </select>
                        <span class="material-symbols-outlined form-select-arrow">expand_more</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">mail</span>
                        <input type="email" class="form-input-field" id="email" name="email" placeholder="Your email address" required autocomplete="email">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">lock</span>
                        <input type="password" class="form-input-field" id="password" name="password" placeholder="Your password" minlength="8" required autocomplete="current-password">
                        <button type="button" class="password-toggle-btn" id="togglePasswordBtn" title="Show password" aria-label="Show password" tabindex="-1">
                            <span class="material-symbols-outlined" id="togglePasswordIcon">visibility</span>
                        </button>
                    </div>
                </div>

                <div class="options-row">
                    <label class="auth-checkbox-label">
                        <input type="checkbox" name="remember" checked>
                        <span>Remember me</span>
                    </label>
                    <label class="auth-checkbox-label">
                        <input type="checkbox" id="showPasswordCheckbox">
                        <span>Show password</span>
                    </label>
                </div>

                <button type="submit" class="auth-submit-btn">
                    <span>Sign in</span>
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">arrow_forward</span>
                </button>
            </form>

            <div class="auth-footer-text">
                Don't have an account?
                <a href="register.jsp">Sign up</a>
            </div>
        </div>
    </div>
</div>

<script>
    (function() {
        const pwdInput = document.getElementById('password');
        const toggleBtn = document.getElementById('togglePasswordBtn');
        const toggleIcon = document.getElementById('togglePasswordIcon');
        const showCb = document.getElementById('showPasswordCheckbox');

        if (!pwdInput) return;

        function setVisibility(show) {
            pwdInput.type = show ? 'text' : 'password';
            if (toggleIcon) {
                toggleIcon.textContent = show ? 'visibility_off' : 'visibility';
            }
            if (toggleBtn) {
                toggleBtn.setAttribute('title', show ? 'Hide password' : 'Show password');
                toggleBtn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            }
            if (showCb && showCb.checked !== show) {
                showCb.checked = show;
            }
        }

        if (toggleBtn) {
            toggleBtn.addEventListener('click', function(e) {
                e.preventDefault();
                const willShow = pwdInput.type === 'password';
                setVisibility(willShow);
                pwdInput.focus();
            });
        }

        if (showCb) {
            showCb.addEventListener('change', function() {
                setVisibility(showCb.checked);
                pwdInput.focus();
            });
        }
    })();
</script>

</body>
</html>
