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
            background-color: #08090C;
            font-family: var(--font-body, 'Manrope', -apple-system, BlinkMacSystemFont, sans-serif);
            color: #E2E8F0;
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
            background-color: #08090C;
            position: relative;
            z-index: 10;
        }

        .auth-form-inner {
            width: 100%;
            max-width: 390px;
            display: flex;
            flex-direction: column;
        }

        .auth-brand-wrapper {
            margin-bottom: 2.2rem;
        }

        .auth-brand {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-family: var(--font-heading, 'Manrope', sans-serif);
            font-size: 1.45rem;
            font-weight: 700;
            color: var(--logo, #CFE0E8);
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            transition: color 200ms ease;
        }

        .auth-brand:hover {
            color: #FFFFFF;
        }

        .auth-title {
            font-family: var(--font-heading, 'Manrope', sans-serif);
            font-size: 2.25rem;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -0.025em;
            line-height: 1.15;
            margin: 0 0 0.5rem 0;
        }

        .auth-subtitle {
            font-size: 0.95rem;
            color: #78808F;
            margin: 0 0 2.25rem 0;
            line-height: 1.5;
            font-weight: 400;
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
            height: 48px;
            background: #111319;
            border: 1px solid rgba(255, 255, 255, 0.10);
            border-radius: 10px;
            padding: 0 1rem 0 2.85rem !important;
            color: #FFFFFF;
            font-size: 0.92rem;
            font-family: inherit;
            outline: none;
            box-sizing: border-box;
            transition: border-color 200ms ease, box-shadow 200ms ease, background 200ms ease;
        }

        input[type="password"].form-input-field {
            width: 100%;
            height: 48px;
            background: #111319;
            border: 1px solid rgba(255, 255, 255, 0.10);
            border-radius: 10px;
            padding: 0 2.85rem 0 2.85rem !important;
            color: #FFFFFF;
            font-size: 0.92rem;
            font-family: inherit;
            outline: none;
            box-sizing: border-box;
            transition: border-color 200ms ease, box-shadow 200ms ease, background 200ms ease;
            opacity: 1;
        }

        .form-input-field:focus {
            border-color: rgba(200, 177, 150, 0.65);
            background: #13161F;
            box-shadow: 0 0 0 3px rgba(200, 177, 150, 0.12);
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

        /* Submit Button: Ice Blue Gradient */
        .auth-submit-btn {
            width: 100%;
            height: 48px;
            background: var(--btn-bg, linear-gradient(135deg, #D3E2EA 0%, #8FAFC2 100%));
            border: none;
            border-radius: var(--radius-pill, 9999px);
            color: var(--btn-text, #0B0C12) !important;
            font-family: inherit;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 200ms cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 14px rgba(143, 175, 194, 0.30);
        }

        .auth-submit-btn span {
            color: var(--btn-text, #0B0C12) !important;
        }

        .auth-submit-btn .material-symbols-outlined {
            color: var(--btn-text, #0B0C12) !important;
            font-size: 1.15rem;
            font-weight: 700;
        }

        .auth-submit-btn:hover {
            background: var(--btn-hover, linear-gradient(135deg, #E2EDF4 0%, #A2C1D2 100%));
            color: #0B0C12 !important;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(143, 175, 194, 0.45);
        }

        .auth-submit-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(143, 175, 194, 0.25);
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

        /* Right Side: Showcase Side */
        .auth-showcase-side {
            flex: 1 1 50%;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
            background: 
                radial-gradient(circle at 75% 30%, rgba(200, 215, 235, 0.12) 0%, transparent 55%),
                radial-gradient(circle at 35% 75%, rgba(140, 160, 190, 0.10) 0%, transparent 60%),
                linear-gradient(180deg, #090A0E 0%, #050608 100%);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 4.5rem 4.5rem 3.5rem 4.5rem;
            border-left: 1px solid rgba(255, 255, 255, 0.05);
        }

        .showcase-header {
            position: relative;
            z-index: 5;
        }

        .showcase-title {
            font-family: var(--font-heading, 'Manrope', sans-serif);
            font-size: 2.35rem;
            font-weight: 700;
            line-height: 1.22;
            letter-spacing: -0.015em;
            color: #FFFFFF;
            margin: 0;
            max-width: 560px;
        }

        .showcase-subtitle {
            color: #4A5160;
            display: block;
            margin-top: 0.45rem;
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
            max-width: 530px;
            height: auto;
            animation: floatNice 6.5s cubic-bezier(0.45, 0.05, 0.55, 0.95) infinite;
            transform-origin: center center;
            will-change: transform, filter;
        }

        @keyframes floatNice {
            0% {
                transform: translateY(0px) rotate(0deg);
                filter: drop-shadow(0 15px 30px rgba(0, 0, 0, 0.65)) drop-shadow(0 0 25px rgba(120, 100, 240, 0.18));
            }
            25% {
                transform: translateY(-8px) rotate(0.4deg);
            }
            50% {
                transform: translateY(-18px) rotate(-0.5deg);
                filter: drop-shadow(0 28px 45px rgba(0, 0, 0, 0.75)) drop-shadow(0 0 40px rgba(140, 120, 255, 0.32));
            }
            75% {
                transform: translateY(-10px) rotate(0.3deg);
            }
            100% {
                transform: translateY(0px) rotate(0deg);
                filter: drop-shadow(0 15px 30px rgba(0, 0, 0, 0.65)) drop-shadow(0 0 25px rgba(120, 100, 240, 0.18));
            }
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
                    <span>PraveenMart</span>
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

    <!-- Right Column: Showcase Side -->
    <div class="auth-showcase-side">
        <div class="showcase-header">
            <h2 class="showcase-title">DISCOVER PREMIUM PRODUCTS.<br><span class="showcase-subtitle">SHOP WITH CONFIDENCE. DELIVERED WORLDWIDE.</span></h2>
        </div>

        <div class="showcase-visual-wrap">
            <svg class="showcase-svg" viewBox="50 210 400 250" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <defs>
                    <filter id="orbitGlow" x="-20%" y="-20%" width="140%" height="140%">
                        <feGaussianBlur stdDeviation="4" result="blur" />
                        <feComposite in="SourceGraphic" in2="blur" operator="over" />
                    </filter>
                    <linearGradient id="colFront" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#1E222D" />
                        <stop offset="100%" stop-color="#0E1015" />
                    </linearGradient>
                    <linearGradient id="colTop" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#2D3342" />
                        <stop offset="100%" stop-color="#1A1E27" />
                    </linearGradient>
                    <linearGradient id="orbitGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#FFFFFF" />
                        <stop offset="35%" stop-color="#E2E8F0" />
                        <stop offset="70%" stop-color="#CBD5E1" />
                        <stop offset="100%" stop-color="#94A3B8" />
                    </linearGradient>
                    <radialGradient id="baseGlow" cx="50%" cy="50%" r="50%">
                        <stop offset="0%" stop-color="rgba(226, 232, 240, 0.22)" />
                        <stop offset="100%" stop-color="transparent" />
                    </radialGradient>
                </defs>

                <!-- Base ambient radial light -->
                <ellipse cx="250" cy="380" rx="180" ry="60" fill="url(#baseGlow)" />

                <!-- Back half of the orbital ring -->
                <path d="M 80 340 A 180 55 0 0 1 420 340" stroke="rgba(226, 232, 240, 0.35)" stroke-width="2" stroke-dasharray="6 4" />

                <!-- 3D Pedestal Body -->
                <rect x="195" y="240" width="110" height="200" rx="16" fill="url(#colFront)" stroke="rgba(255, 255, 255, 0.06)" stroke-width="1" />
                <rect x="197" y="238" width="106" height="40" rx="14" fill="url(#colTop)" stroke="rgba(255, 255, 255, 0.12)" stroke-width="1" />

                <!-- Perspective coordinate dots and wireframe on top -->
                <circle cx="205" cy="250" r="3.5" fill="#C8B196" />
                <circle cx="295" cy="250" r="3.5" fill="#C8B196" />
                <circle cx="250" cy="266" r="3.5" fill="#C8B196" />
                <circle cx="250" cy="242" r="3" fill="rgba(200, 177, 150, 0.5)" />
                <path d="M 205 250 L 250 266 L 295 250 L 250 242 Z" stroke="rgba(200, 177, 150, 0.35)" stroke-width="1.2" stroke-dasharray="3 3" fill="none" />

                <!-- Front half of the orbital ring -->
                <g filter="url(#orbitGlow)">
                    <path d="M 420 340 A 180 55 0 0 1 80 340" stroke="url(#orbitGrad)" stroke-width="2.5" />
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
