package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dao.impl.ProductDAOImpl;
import com.praveen.praveenmart.dto.ChatResponseDTO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.service.chat.ChatProvider;
import com.praveen.praveenmart.service.chat.ChatProviderFactory;
import com.praveen.praveenmart.service.chat.GeminiChatProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service orchestrating AI Chatbot business logic, input validation guardrails,
 * store context extraction, and provider delegation (Section 11, 12, 17).
 */
public class ChatService {

    private static final Logger logger = LoggerFactory.getLogger(ChatService.class);
    public static final int MAX_INPUT_LENGTH = 500;

    private final ChatProvider chatProvider;
    private final ProductDAO productDAO;

    /**
     * Default constructor using default ChatProviderFactory and ProductDAOImpl.
     */
    public ChatService() {
        this(ChatProviderFactory.getProvider(), new ProductDAOImpl());
    }

    /**
     * Dependency injection constructor for testing.
     *
     * @param chatProvider the chat provider strategy
     * @param productDAO the product DAO for catalog context
     */
    public ChatService(ChatProvider chatProvider, ProductDAO productDAO) {
        this.chatProvider = chatProvider != null ? chatProvider : ChatProviderFactory.getProvider();
        this.productDAO = productDAO != null ? productDAO : new ProductDAOImpl();
    }

    /**
     * Processes a user message, validates guardrail constraints, builds context,
     * and fetches a response from the configured ChatProvider.
     *
     * @param message user query message
     * @return ChatResponseDTO containing reply and metadata
     * @throws ValidationException if input violates length or emptiness constraints
     */
    public ChatResponseDTO processMessage(String message) throws ValidationException {
        // Validation at top of service method (Section 13.5)
        if (message == null || message.trim().isEmpty()) {
            throw new ValidationException("Message cannot be empty.");
        }

        String trimmed = message.trim();
        if (trimmed.length() > MAX_INPUT_LENGTH) {
            throw new ValidationException("Message exceeds maximum allowed length of " + MAX_INPUT_LENGTH + " characters.");
        }

        String context = buildStoreContext();
        String reply;
        String providerName = (chatProvider instanceof GeminiChatProvider) ? "gemini" : "mock";

        try {
            reply = chatProvider.getReply(trimmed, context);
        } catch (Exception e) {
            logger.error("Error executing ChatProvider getReply, returning degraded response", e);
            reply = "I apologize, but I am currently having trouble processing your request. "
                    + "Please browse our catalog categories or contact support@praveenmart.com for immediate help.";
        }

        return ChatResponseDTO.builder()
                .reply(reply)
                .provider(providerName)
                .timestamp(System.currentTimeMillis())
                .build();
    }

    /**
     * Compiles a concise summary of active catalog categories and products to ground the AI model.
     *
     * @return string representation of active store inventory context
     */
    public String buildStoreContext() {
        try {
            List<Product> products = productDAO.findAll();
            if (products == null || products.isEmpty()) {
                return "Store categories: Electronics, Fashion & Style, Home & Kitchen, Accessories, Books.";
            }

            List<String> sampleNames = products.stream()
                    .limit(15)
                    .map(p -> p.getName() + " (Category: " + p.getCategory() + ", Price: ₹" + p.getPrice() + ")")
                    .collect(Collectors.toList());

            return "Available categories: Electronics, Fashion & Style, Home & Kitchen, Accessories, Books.\n"
                    + "Sample available products:\n- " + String.join("\n- ", sampleNames);
        } catch (Exception e) {
            logger.warn("Failed to fetch products for store context: {}", e.getMessage());
            return "Store categories: Electronics, Fashion & Style, Home & Kitchen, Accessories, Books.";
        }
    }
}
