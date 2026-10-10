package com.praveen.praveenmart.service.chat;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ChatProviderFactoryTest {

    @BeforeEach
    @AfterEach
    public void resetFactory() {
        ChatProviderFactory.setCustomProvider(null);
        System.clearProperty("ai.chatbot.provider");
    }

    @Test
    public void testGetProviderDefaultsToMockWhenConfiguredAsMock() {
        System.setProperty("ai.chatbot.provider", "mock");
        ChatProvider provider = ChatProviderFactory.getProvider();
        assertNotNull(provider);
        assertTrue(provider instanceof MockChatProvider);
    }

    @Test
    public void testGetProviderResolvesGeminiWhenConfigured() {
        System.setProperty("ai.chatbot.provider", "gemini");
        ChatProvider provider = ChatProviderFactory.getProvider();
        assertNotNull(provider);
        assertTrue(provider instanceof GeminiChatProvider);
    }

    @Test
    public void testGetProviderReturnsCustomProviderWhenSet() {
        ChatProvider custom = (userMessage, context) -> "Custom: " + userMessage;
        ChatProviderFactory.setCustomProvider(custom);

        ChatProvider resolved = ChatProviderFactory.getProvider();
        assertEquals(custom, resolved);
        assertEquals("Custom: test", resolved.getReply("test", ""));
    }

    @Test
    public void testGeminiProviderDegradesGracefullyWithoutKey() {
        GeminiChatProvider gemini = new GeminiChatProvider(null, null);
        assertFalse(gemini.hasApiKey());

        String reply = gemini.getReply("What products do you have?", "Electronics");
        assertNotNull(reply);
        assertTrue(reply.contains("Electronics") || reply.contains("PraveenMart"));
    }

    @Test
    public void testGeminiProviderWithEnvKey() {
        GeminiChatProvider provider = new GeminiChatProvider();
        if (provider.hasApiKey()) {
            String reply = provider.getReply("Hello, who are you in 1 sentence?", "Electronics");
            assertNotNull(reply);
            assertFalse(reply.isBlank());
            System.out.println(">>> GEMINI LIVE RESPONSE: " + reply);
        }
    }

    @Test
    public void testHowToLoginQuery() {
        GeminiChatProvider provider = new GeminiChatProvider();
        String reply = provider.getReply("how to login", "Electronics");
        assertNotNull(reply);
        assertFalse(reply.contains("Try asking:"));
        assertTrue(reply.toLowerCase().contains("login") || reply.toLowerCase().contains("sign in") || reply.contains("PraveenMart"));
    }
}
