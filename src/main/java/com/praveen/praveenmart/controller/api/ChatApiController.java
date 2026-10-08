package com.praveen.praveenmart.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.dto.ApiResponse;
import com.praveen.praveenmart.dto.ChatRequestDTO;
import com.praveen.praveenmart.dto.ChatResponseDTO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.service.ChatService;
import com.praveen.praveenmart.util.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Backend proxy Servlet for AI Chatbot interactions (Section 11, 13, 17).
 * Supports JSON endpoints versioned under /api/v1/chat (and /api/chat).
 * Enforces per-session rate limits (10 messages/minute) and in-memory question caching.
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/api/v1/chat", "/api/chat"})
public class ChatApiController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ChatApiController.class);
    private static final String RATE_LIMIT_ATTR = "CHAT_RATE_LIMIT_TIMESTAMPS";
    private static final String CACHE_ATTR = "CHAT_SESSION_CACHE";
    private static final int MAX_MESSAGES_PER_MINUTE = 10;
    private static final long ONE_MINUTE_MILLIS = 60_000L;

    private final Gson gson = JsonUtil.getGson();
    private ChatService chatService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.chatService = new ChatService();
    }

    // For testing / dependency injection
    public void setChatService(ChatService chatService) {
        this.chatService = chatService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> statusData = new LinkedHashMap<>();
        statusData.put("status", "UP");
        statusData.put("endpoint", "/api/v1/chat");
        statusData.put("rateLimit", MAX_MESSAGES_PER_MINUTE + " messages/min");

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(ApiResponse.ok(statusData)));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);

        // 1. Guardrail: Enforce per-session rate limit (10 messages/minute) (Section 17.3)
        if (!checkRateLimit(session)) {
            logger.warn("Per-session rate limit exceeded for session ID: {}", session.getId());
            response.setStatus(429); // 429 Too Many Requests
            response.getWriter().write(gson.toJson(ApiResponse.fail(
                    "RATE_LIMIT_EXCEEDED",
                    "Rate limit exceeded (maximum " + MAX_MESSAGES_PER_MINUTE + " messages per minute). Please wait a moment."
            )));
            return;
        }

        // 2. Read request message
        String message;
        try {
            message = extractMessage(request);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("INVALID_REQUEST", "Unable to parse request body.")));
            return;
        }

        if (message == null || message.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", "Message cannot be empty.")));
            return;
        }

        String normalizedQuery = message.trim().toLowerCase(Locale.ENGLISH);

        // 3. Guardrail: In-memory session cache for repeated identical questions (Section 17.4)
        Map<String, String> sessionCache = getSessionCache(session);
        if (sessionCache.containsKey(normalizedQuery)) {
            String cachedReply = sessionCache.get(normalizedQuery);
            ChatResponseDTO cachedResponse = ChatResponseDTO.builder()
                    .reply(cachedReply)
                    .provider("cache")
                    .timestamp(System.currentTimeMillis())
                    .build();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(cachedResponse)));
            return;
        }

        // 4. Process via ChatService (enforces input length cap and provider dispatch)
        try {
            ChatResponseDTO result = chatService.processMessage(message);

            // Save to in-memory session cache
            if (result != null && result.getReply() != null) {
                sessionCache.put(normalizedQuery, result.getReply());
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(ApiResponse.ok(result)));

        } catch (ValidationException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(ApiResponse.fail("VALIDATION_ERROR", e.getMessage())));
        } catch (Exception e) {
            logger.error("Unexpected error in ChatApiController", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(ApiResponse.fail("SERVER_ERROR", "Failed to process chat query.")));
        }
    }

    /**
     * Checks whether the session has exceeded the sliding window rate limit.
     *
     * @param session the user's HTTP session
     * @return true if under rate limit, false if exceeded
     */
    private synchronized boolean checkRateLimit(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Long> timestamps = (List<Long>) session.getAttribute(RATE_LIMIT_ATTR);
        if (timestamps == null) {
            timestamps = Collections.synchronizedList(new ArrayList<>());
            session.setAttribute(RATE_LIMIT_ATTR, timestamps);
        }

        long now = System.currentTimeMillis();
        long windowStart = now - ONE_MINUTE_MILLIS;

        synchronized (timestamps) {
            timestamps.removeIf(t -> t < windowStart);
            if (timestamps.size() >= MAX_MESSAGES_PER_MINUTE) {
                return false;
            }
            timestamps.add(now);
            return true;
        }
    }

    /**
     * Retrieves or initializes the in-memory cache of questions for the session.
     */
    private Map<String, String> getSessionCache(HttpSession session) {
        @SuppressWarnings("unchecked")
        Map<String, String> cache = (Map<String, String>) session.getAttribute(CACHE_ATTR);
        if (cache == null) {
            cache = new ConcurrentHashMap<>();
            session.setAttribute(CACHE_ATTR, cache);
        }
        return cache;
    }

    /**
     * Extracts user message from JSON request body or form-data parameter.
     */
    private String extractMessage(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            String rawJson = sb.toString().trim();
            if (!rawJson.isEmpty()) {
                try {
                    ChatRequestDTO dto = gson.fromJson(rawJson, ChatRequestDTO.class);
                    if (dto != null && dto.getMessage() != null) {
                        return dto.getMessage();
                    }
                    JsonObject jsonObject = gson.fromJson(rawJson, JsonObject.class);
                    if (jsonObject != null && jsonObject.has("message")) {
                        return jsonObject.get("message").getAsString();
                    }
                } catch (Exception ignored) {}
            }
        }

        // Fallback to URL-encoded form parameter
        return request.getParameter("message");
    }
}
