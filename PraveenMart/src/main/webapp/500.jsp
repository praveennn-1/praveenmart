<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #000000;
            text-align: center;
            padding: 2rem;
            color: #E4E4E7;
        }
        .error-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 3.5rem 2.5rem;
            max-width: 480px;
        }
    </style>
</head>
<body>
    <div class="error-card">
        <span class="material-symbols-outlined" style="font-size: 3.5rem; color: #EF4444; margin-bottom: 1rem;">error</span>
        <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.5rem; color: #FFFFFF;">500 - Internal Server Error</h1>
        <p style="font-family: var(--font-mono); color: #888888; font-size: 0.85rem; margin-bottom: 2rem; line-height: 1.6;">
            Something unexpected occurred on our end. Please try again later or return to the marketplace.
        </p>
        <a href="<%= request.getContextPath() %>/products" class="btn btn-primary" style="padding: 0.75rem 1.75rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem;">
            <span class="material-symbols-outlined" style="font-size: 1.1rem;">home</span>
            <span>Return to Storefront</span>
        </a>
    </div>
</body>
</html>
