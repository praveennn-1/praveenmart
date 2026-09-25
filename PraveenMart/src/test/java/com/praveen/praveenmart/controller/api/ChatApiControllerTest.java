package com.praveen.praveenmart.controller.api;

import com.google.gson.JsonObject;
import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dto.ChatResponseDTO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.service.ChatService;
import com.praveen.praveenmart.service.chat.ChatProvider;
import com.praveen.praveenmart.util.JsonUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ChatApiControllerTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private ChatProvider chatProvider;

    @Mock
    private ProductDAO productDAO;

    private ChatService chatService;
    private ChatApiController controller;
    private StringWriter stringWriter;
    private PrintWriter printWriter;

    // Emulated session storage for rate limiting and cache testing
    private Map<String, Object> sessionAttributes;

    @BeforeEach
    public void setUp() throws Exception {
        chatService = new ChatService(chatProvider, productDAO);
        controller = new ChatApiController();
        controller.setChatService(chatService);

        stringWriter = new StringWriter();
        printWriter = new PrintWriter(stringWriter);
        lenient().when(response.getWriter()).thenReturn(printWriter);

        sessionAttributes = new HashMap<>();
        lenient().when(request.getSession(true)).thenReturn(session);
        lenient().when(request.getSession(false)).thenReturn(session);

        lenient().doAnswer(invocation -> {
            String key = invocation.getArgument(0);
            Object value = invocation.getArgument(1);
            sessionAttributes.put(key, value);
            return null;
        }).when(session).setAttribute(anyString(), any());

        lenient().doAnswer(invocation -> {
            String key = invocation.getArgument(0);
            return sessionAttributes.get(key);
        }).when(session).getAttribute(anyString());
    }

    @Test
    public void testDoGetReturnsHealthStatus() throws Exception {
        controller.doGet(request, response);
        printWriter.flush();

        verify(response).setStatus(HttpServletResponse.SC_OK);
        JsonObject json = JsonUtil.getGson().fromJson(stringWriter.toString(), JsonObject.class);
        assertTrue(json.get("success").getAsBoolean());
        assertEquals("UP", json.getAsJsonObject("data").get("status").getAsString());
    }

    @Test
    public void testDoPostValidMessage() throws Exception {
        String jsonBody = "{\"message\":\"What headphones do you have?\"}";
        when(request.getContentType()).thenReturn("application/json");
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(jsonBody)));

        when(chatProvider.getReply(anyString(), anyString())).thenReturn("We have Apple AirPods and Soundcore headphones.");

        controller.doPost(request, response);
        printWriter.flush();

        verify(response).setStatus(HttpServletResponse.SC_OK);
        JsonObject json = JsonUtil.getGson().fromJson(stringWriter.toString(), JsonObject.class);
        assertTrue(json.get("success").getAsBoolean());
        assertEquals("We have Apple AirPods and Soundcore headphones.",
                json.getAsJsonObject("data").get("reply").getAsString());
    }

    @Test
    public void testDoPostEmptyMessageReturnsBadRequest() throws Exception {
        String jsonBody = "{\"message\":\"   \"}";
        when(request.getContentType()).thenReturn("application/json");
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(jsonBody)));

        controller.doPost(request, response);
        printWriter.flush();

        verify(response).setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JsonObject json = JsonUtil.getGson().fromJson(stringWriter.toString(), JsonObject.class);
        assertFalse(json.get("success").getAsBoolean());
        assertEquals("VALIDATION_ERROR", json.getAsJsonObject("error").get("code").getAsString());
    }

    @Test
    public void testDoPostSessionCacheReturnsCachedResponseOnDuplicate() throws Exception {
        String jsonBody = "{\"message\":\"How to track order?\"}";
        when(request.getContentType()).thenReturn("application/json");
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(jsonBody)));

        when(chatProvider.getReply(anyString(), anyString())).thenReturn("Go to My Orders page.");

        // First call populates cache
        controller.doPost(request, response);
        printWriter.flush();

        // Second call with identical query (different casing/spacing)
        String jsonBody2 = "{\"message\":\" how to track order? \"}";
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(jsonBody2)));
        StringWriter writer2 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer2));

        controller.doPost(request, response);

        JsonObject json2 = JsonUtil.getGson().fromJson(writer2.toString(), JsonObject.class);
        assertTrue(json2.get("success").getAsBoolean());
        assertEquals("cache", json2.getAsJsonObject("data").get("provider").getAsString());
        assertEquals("Go to My Orders page.", json2.getAsJsonObject("data").get("reply").getAsString());

        // ChatProvider should only be called once, second was served from cache
        verify(chatProvider, times(1)).getReply(anyString(), anyString());
    }

    @Test
    public void testRateLimitingEnforcesMaxTenMessagesPerMinute() throws Exception {
        // Pre-fill 10 recent timestamps in session
        List<Long> timestamps = new ArrayList<>();
        long now = System.currentTimeMillis();
        for (int i = 0; i < 10; i++) {
            timestamps.add(now);
        }
        sessionAttributes.put("CHAT_RATE_LIMIT_TIMESTAMPS", timestamps);

        controller.doPost(request, response);
        printWriter.flush();

        // 11th request should be rejected with 429
        verify(response).setStatus(429);
        JsonObject json = JsonUtil.getGson().fromJson(stringWriter.toString(), JsonObject.class);
        assertFalse(json.get("success").getAsBoolean());
        assertEquals("RATE_LIMIT_EXCEEDED", json.getAsJsonObject("error").get("code").getAsString());
    }
}
