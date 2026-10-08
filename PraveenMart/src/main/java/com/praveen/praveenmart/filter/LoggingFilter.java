package com.praveen.praveenmart.filter;

import org.slf4j.MDC;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebFilter("/*")
public class LoggingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}

    private static final String MDC_KEY = "requestId";
    private static final String HEADER_NAME = "X-Request-Id";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            String requestId = null;
            if (request instanceof HttpServletRequest httpRequest) {
                requestId = httpRequest.getHeader(HEADER_NAME);
            }
            if (requestId == null || requestId.isBlank()) {
                requestId = UUID.randomUUID().toString().substring(0, 8);
            }

            MDC.put(MDC_KEY, requestId);

            if (response instanceof HttpServletResponse httpResponse) {
                httpResponse.setHeader(HEADER_NAME, requestId);
            }

            chain.doFilter(request, response);
        } finally {
            MDC.remove(MDC_KEY);
        }
    }
}
