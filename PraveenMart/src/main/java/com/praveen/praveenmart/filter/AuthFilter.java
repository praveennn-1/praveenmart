package com.praveen.praveenmart.filter;

import com.praveen.praveenmart.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        HttpSession session = req.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (path.startsWith("/admin") || path.equals("/admin_dashboard.jsp")) {
            if (sessionUser == null) {
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + path);
                return;
            }
            if (!"ADMIN".equalsIgnoreCase(sessionUser.getRole()) || !"admin@praveenmart.com".equalsIgnoreCase(sessionUser.getEmail())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Admin page is restricted exclusively to admin@praveenmart.com.");
                return;
            }
        }

        if (path.startsWith("/seller") || path.equals("/seller_dashboard.jsp")) {
            if (sessionUser == null) {
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + path);
                return;
            }
            if (!"SELLER".equalsIgnoreCase(sessionUser.getRole()) && !"ADMIN".equalsIgnoreCase(sessionUser.getRole())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Seller role required.");
                return;
            }
        }

        if (sessionUser != null && "ADMIN".equalsIgnoreCase(sessionUser.getRole())) {
            if (path.startsWith("/cart") || path.startsWith("/checkout") ||
                    path.startsWith("/orders")) {
                res.sendRedirect(contextPath + "/admin/dashboard");
                return;
            }
        }

        if (path.startsWith("/cart") || path.startsWith("/checkout") ||
                path.startsWith("/orders") || path.equals("/dashboard.jsp") ||
                path.startsWith("/api/v1/cart") || path.startsWith("/api/v1/orders")) {
            if (sessionUser == null) {
                boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                        || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"));
                if (path.startsWith("/api/") || isAjax) {
                    res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    res.setContentType("application/json");
                    res.setCharacterEncoding("UTF-8");
                    res.getWriter().write("{\"success\":false,\"requireLogin\":true,\"redirect\":\"" + contextPath + "/login.jsp\",\"data\":null,\"error\":{\"code\":\"UNAUTHORIZED\",\"message\":\"Authentication required.\"}}");
                    return;
                }
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + path);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/") ||
                path.equals("/index.jsp") ||
                path.equals("/login") ||
                path.equals("/login.jsp") ||
                path.equals("/register") ||
                path.equals("/register.jsp") ||
                path.equals("/logout") ||
                path.startsWith("/products") ||
                path.startsWith("/product-details") ||
                path.startsWith("/api/v1/health") ||
                path.startsWith("/api/v1/products") ||
                path.startsWith("/api/v1/reviews") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.startsWith("/error") ||
                path.equals("/404.jsp") ||
                path.equals("/500.jsp");
    }
}
