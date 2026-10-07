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

        /* Split Screen Container */
        .auth-split-layout {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* Left Side: Form Container */
        .auth-form-side {
            flex: 1 1 50%;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 3.5rem 3rem;
            background-color: #000000;
            position: relative;
            z-index: 10;
        }

        .auth-form-inner {
            width: 100%;
            max-width: 400px;
            display: flex;
            flex-direction: column;
        }

        .auth-brand-wrapper {
            margin-bottom: 2rem;
        }

        .auth-brand {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.15rem;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            text-transform: lowercase;
            text-decoration: none;
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
        }

        .auth-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: #888888;
            margin: 0 0 2rem 0;
            line-height: 1.5;
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

        /* Right Side: Showcase Side */
        .auth-showcase-side {
            flex: 1 1 50%;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
            background-color: #000000;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 4.5rem 4.5rem 3.5rem 4.5rem;
            border-left: 1px solid #222222;
        }

        .showcase-header {
            position: relative;
            z-index: 5;
        }

        .showcase-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 2.2rem;
            font-weight: 700;
            line-height: 1.25;
            letter-spacing: -0.03em;
            color: #FFFFFF;
            margin: 0;
            max-width: 540px;
        }

        .showcase-subtitle {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            color: #888888;
            font-size: 0.95rem;
            font-weight: 400;
            display: block;
            margin-top: 0.75rem;
            letter-spacing: -0.01em;
        }

        /* 3D Showcase Graphic */
        .showcase-visual-wrap {
            position: relative;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 420px;
        }

        .showcase-svg {
            position: relative;
            z-index: 3;
            width: 100%;
            max-width: 500px;
            height: auto;
        }

        /* Mobile / Responsive View */
        @media (max-width: 960px) {
            .auth-showcase-side {
                display: none;
            }
            .auth-form-side {
                flex: 1 1 100%;
                padding: 3rem 1.5rem;
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

    <!-- Right Column: Showcase Side -->
    <div class="auth-showcase-side">
        <div class="showcase-header">
            <h2 class="showcase-title">DISCOVER PREMIUM PRODUCTS.<br><span class="showcase-subtitle">SHOP WITH CONFIDENCE. DELIVERED WORLDWIDE.</span></h2>
        </div>

        <div class="showcase-visual-wrap">
            <svg class="showcase-svg" viewBox="50 210 400 250" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <defs>
                    <filter id="orbitGlowRegister" x="-20%" y="-20%" width="140%" height="140%">
                        <feGaussianBlur stdDeviation="4" result="blur" />
                        <feComposite in="SourceGraphic" in2="blur" operator="over" />
                    </filter>
                    <linearGradient id="colFrontReg" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#1E222D" />
                        <stop offset="100%" stop-color="#0E1015" />
                    </linearGradient>
                    <linearGradient id="colTopReg" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#2D3342" />
                        <stop offset="100%" stop-color="#1A1E27" />
                    </linearGradient>
                    <linearGradient id="orbitGradReg" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#FFFFFF" />
                        <stop offset="35%" stop-color="#E2E8F0" />
                        <stop offset="70%" stop-color="#CBD5E1" />
                        <stop offset="100%" stop-color="#94A3B8" />
                    </linearGradient>
                    <radialGradient id="baseGlowReg" cx="50%" cy="50%" r="50%">
                        <stop offset="0%" stop-color="rgba(226, 232, 240, 0.22)" />
                        <stop offset="100%" stop-color="transparent" />
                    </radialGradient>
                </defs>

                <!-- Base ambient radial light -->
                <ellipse cx="250" cy="380" rx="180" ry="60" fill="url(#baseGlowReg)" />

                <!-- Back half of the orbital ring -->
                <path d="M 80 340 A 180 55 0 0 1 420 340" stroke="rgba(226, 232, 240, 0.35)" stroke-width="2" stroke-dasharray="6 4" />

                <!-- 3D Pedestal Body -->
                <rect x="195" y="240" width="110" height="200" rx="16" fill="url(#colFrontReg)" stroke="rgba(255, 255, 255, 0.06)" stroke-width="1" />
                <rect x="197" y="238" width="106" height="40" rx="14" fill="url(#colTopReg)" stroke="rgba(255, 255, 255, 0.12)" stroke-width="1" />

                <!-- Perspective coordinate dots and wireframe on top -->
                <circle cx="205" cy="250" r="3.5" fill="#C8B196" />
                <circle cx="295" cy="250" r="3.5" fill="#C8B196" />
                <circle cx="250" cy="266" r="3.5" fill="#C8B196" />
                <circle cx="250" cy="242" r="3" fill="rgba(200, 177, 150, 0.5)" />
                <path d="M 205 250 L 250 266 L 295 250 L 250 242 Z" stroke="rgba(200, 177, 150, 0.35)" stroke-width="1.2" stroke-dasharray="3 3" fill="none" />

                <!-- Front half of the orbital ring -->
                <g filter="url(#orbitGlowRegister)">
                    <path d="M 420 340 A 180 55 0 0 1 80 340" stroke="url(#orbitGradReg)" stroke-width="2.5" />
                    <!-- Arrowhead traveling on the orbit path -->
                    <polygon points="256,395 238,386 244,395 238,404" fill="#FFFFFF" />
                </g>
            </svg>
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
