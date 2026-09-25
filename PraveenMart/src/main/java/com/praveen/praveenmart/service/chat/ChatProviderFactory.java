package com.praveen.praveenmart.service.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Factory class for instantiating the appropriate {@link ChatProvider}
 * based on configuration flag (Section 17.2: ai.chatbot.provider=gemini|mock).
 */
public class ChatProviderFactory {

    private static final Logger logger = LoggerFactory.getLogger(ChatProviderFactory.class);

    private static ChatProvider customProvider = null;

    /**
     * Set a custom ChatProvider for testing or runtime override.
     *
     * @param provider the custom provider instance
     */
    public static void setCustomProvider(ChatProvider provider) {
        customProvider = provider;
    }

    /**
     * Resolves and returns the configured {@link ChatProvider}.
     *
     * @return GeminiChatProvider if configured and API key available, otherwise MockChatProvider
     */
    public static ChatProvider getProvider() {
        if (customProvider != null) {
            return customProvider;
        }

        String providerName = System.getProperty("ai.chatbot.provider", System.getenv("AI_CHATBOT_PROVIDER"));
        if (providerName != null && "gemini".equalsIgnoreCase(providerName.trim())) {
            GeminiChatProvider gemini = new GeminiChatProvider();
            if (gemini.hasApiKey()) {
                logger.info("Using GeminiChatProvider for AI chatbot.");
                return gemini;
            } else {
                logger.warn("ai.chatbot.provider is set to 'gemini' but GEMINI_API_KEY is missing. Defaulting to MockChatProvider.");
            }
        }

        logger.debug("Using MockChatProvider for AI chatbot.");
        return new MockChatProvider();
    }
}
