<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - PraveenMart</title>
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
            font-family: var(--font-body, 'Inter', -apple-system, BlinkMacSystemFont, sans-serif);
            color: #E4E4E7;
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
            max-width: 450px;
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

        .auth-brand .brand-badge {
            font-size: 0.68rem;
            color: #888888;
            font-family: var(--font-mono);
            font-weight: 500;
            padding: 1px 6px;
            background: #111111;
            border: 1px solid #27272A;
            border-radius: 4px;
            text-transform: none;
            letter-spacing: 0;
        }

        .auth-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 2rem;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            line-height: 1.15;
            margin: 0 0 0.5rem 0;
            text-align: center;
        }

        .auth-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #888888;
            margin: 0 0 2rem 0;
            line-height: 1.5;
            text-align: center;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 1.15rem;
            position: relative;
        }

        .form-label {
            display: block;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.78rem;
            font-weight: 600;
            color: #A1A1AA;
            text-transform: uppercase;
            letter-spacing: 0.04em;
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
            color: #52525B;
            font-size: 1.15rem;
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
            border-radius: 4px;
            padding: 0 1rem 0 2.75rem !important;
            color: #FFFFFF;
            font-size: 0.9rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            outline: none;
            box-sizing: border-box;
            transition: border-color 150ms ease, background 150ms ease;
        }

        input[type="password"].form-input-field {
            width: 100%;
            height: 44px;
            background: #050505;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0 2.75rem 0 2.75rem !important;
            color: #FFFFFF;
            font-size: 0.9rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            outline: none;
            box-sizing: border-box;
            transition: border-color 150ms ease, background 150ms ease;
            opacity: 1;
        }

        .form-input-field:focus {
            border-color: #FFFFFF;
            background: #0A0A0A;
        }

        .form-input-field::placeholder {
            color: #52525B;
            opacity: 1;
        }

        .form-select-field,
        select.form-select-field {
            width: 100%;
            height: 44px;
            background: #050505;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0 2.5rem 0 2.75rem !important;
            color: #FFFFFF;
            font-size: 0.9rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            outline: none;
            box-sizing: border-box;
            appearance: none;
            -webkit-appearance: none;
            cursor: pointer;
            transition: border-color 150ms ease, background 150ms ease;
        }

        .form-select-field:focus {
            border-color: #FFFFFF;
            background: #0A0A0A;
        }

        .form-select-arrow {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #52525B;
            font-size: 1.2rem;
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
            color: #52525B;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 6px;
            border-radius: 4px;
            transition: color 150ms ease;
            user-select: none;
        }

        .password-toggle-btn:hover {
            color: #FFFFFF;
        }

        .password-toggle-btn .material-symbols-outlined {
            font-size: 1.15rem;
            line-height: 1;
        }

        /* Checkbox Options */
        .options-row {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin: 0.2rem 0 1.5rem 0;
            font-size: 0.8rem;
            color: #A1A1AA;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
        }

        .auth-checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            cursor: pointer;
            user-select: none;
            transition: color 150ms ease;
        }

        .auth-checkbox-label:hover {
            color: #FFFFFF;
        }

        .auth-checkbox-label input[type="checkbox"] {
            accent-color: #FFFFFF;
            cursor: pointer;
            width: 14px;
            height: 14px;
        }

        /* Submit Button: OpenCode High Contrast */
        .auth-submit-btn {
            width: 100%;
            height: 44px;
            background: #FFFFFF;
            border: 1px solid #FFFFFF;
            border-radius: 4px;
            color: #000000 !important;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            font-weight: 600;
            letter-spacing: -0.01em;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: background 150ms ease, opacity 150ms ease;
        }

        .auth-submit-btn span {
            color: #000000 !important;
            font-weight: 600;
        }

        .auth-submit-btn .material-symbols-outlined {
            color: #000000 !important;
            font-size: 1.1rem;
        }

        .auth-submit-btn:hover {
            background: #E4E4E7;
            border-color: #E4E4E7;
        }

        .auth-submit-btn:active {
            opacity: 0.9;
        }

        /* Footer Link */
        .auth-footer-text {
            margin-top: 2rem;
            text-align: center;
            font-size: 0.85rem;
            color: #71717A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
        }

        .auth-footer-text a {
            color: #FFFFFF;
            font-weight: 600;
            text-decoration: underline;
            text-underline-offset: 3px;
            margin-left: 0.3rem;
            transition: color 150ms ease;
        }

        .auth-footer-text a:hover {
            color: #A1A1AA;
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

            <h1 class="auth-title">Create Account</h1>
            <p class="auth-subtitle">Sign up for PraveenMart to get started.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-box alert-box-error">
                    <span class="material-symbols-outlined">warning</span>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <form action="register" method="post">
                <div class="form-group">
                    <label class="form-label" for="role">Register As</label>
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
                    <label class="form-label" for="name">Full Name</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">person</span>
                        <input type="text" class="form-input-field" id="name" name="name" placeholder="Enter your full name" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">mail</span>
                        <input type="email" class="form-input-field" id="email" name="email" placeholder="Your email address" required autocomplete="email">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="form-input-box">
                        <span class="material-symbols-outlined form-input-icon">lock</span>
                        <input type="password" class="form-input-field" id="password" name="password" placeholder="At least 8 characters" minlength="8" required autocomplete="new-password">
                        <button type="button" class="password-toggle-btn" id="togglePasswordBtn" title="Show password" aria-label="Show password" tabindex="-1">
                            <span class="material-symbols-outlined" id="togglePasswordIcon">visibility</span>
                        </button>
                    </div>
                </div>

                <div class="options-row">
                    <label class="auth-checkbox-label">
                        <input type="checkbox" id="showPasswordCheckbox">
                        <span>Show password</span>
                    </label>
                </div>

                <button type="submit" class="auth-submit-btn">
                    <span>Create Account</span>
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">arrow_forward</span>
                </button>
            </form>

            <div class="auth-footer-text">
                Already have an account?
                <a href="login.jsp">Sign in</a>
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
