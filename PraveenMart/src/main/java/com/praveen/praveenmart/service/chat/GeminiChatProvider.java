package com.praveen.praveenmart.service.chat;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.praveen.praveenmart.util.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Gemini implementation of {@link ChatProvider} that invokes Google's Gemini LLM API.
 * Includes outbound timeouts, fixed server-side system prompts, and graceful degradation
 * to {@link MockChatProvider} upon failure. Fulfills Section 11 and Section 17 requirements.
 */
public class GeminiChatProvider implements ChatProvider {

    private static final Logger logger = LoggerFactory.getLogger(GeminiChatProvider.class);
    private static final String DEFAULT_MODEL = "gemini-3.1-flash-lite";
    private static final int TIMEOUT_SECONDS = 30;

    static {
        System.setProperty("java.net.preferIPv4Stack", "true");
        System.setProperty("java.net.preferIPv6Addresses", "false");
    }

    private final String apiKey;
    private final String model;
    private final HttpClient httpClient;
    private final Gson gson = JsonUtil.getGson();
    private final MockChatProvider fallbackProvider = new MockChatProvider();

    /**
     * Default constructor initializing API key and model from environment or system properties.
     */
    public GeminiChatProvider() {
        this(resolveApiKey(), resolveModel());
    }

    /**
     * Constructor allowing explicit API key and Gemini model specification.
     *
     * @param apiKey Google Gemini API key
     * @param model model name (e.g., gemini-3.1-flash-lite)
     */
    public GeminiChatProvider(String apiKey, String model) {
        this.apiKey = apiKey;
        this.model = normalizeModel(model);
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                .build();
    }

    private static String normalizeModel(String m) {
        if (m == null || m.isBlank()) {
            return DEFAULT_MODEL;
        }
        String trimmed = m.trim();
        if ("gemini-1.5-flash".equalsIgnoreCase(trimmed)
                || "gemini-2.5-flash".equalsIgnoreCase(trimmed)
                || "gemini-2.5-flash-lite".equalsIgnoreCase(trimmed)) {
            return DEFAULT_MODEL;
        }
        return trimmed;
    }

    private static String resolveApiKey() {
        String key = com.praveen.praveenmart.util.EnvUtil.get("GEMINI_API_KEY",
                System.getProperty("gemini.api.key", System.getenv("GEMINI_API_KEY")));
        return (key != null && !key.isBlank()) ? key.trim() : null;
    }

    private static String resolveModel() {
        String m = com.praveen.praveenmart.util.EnvUtil.get("GEMINI_MODEL",
                System.getProperty("gemini.model", System.getenv("GEMINI_MODEL")));
        return normalizeModel(m);
    }

    /**
     * Indicates whether an API key has been configured for Gemini.
     *
     * @return true if non-blank API key exists, false otherwise
     */
    public boolean hasApiKey() {
        return apiKey != null && !apiKey.isBlank();
    }

    /**
     * Sends the prompt with store context to the Gemini LLM API with an outbound timeout.
     * Gracefully degrades to {@link MockChatProvider} upon network or API error.
     *
     * @param userMessage user shopping query
     * @param context active store and catalog context
     * @return generated response text
     */
    @Override
    public String getReply(String userMessage, String context) {
        // If API key is missing, immediately degrade to MockChatProvider
        if (!hasApiKey()) {
            logger.warn("Gemini API key not configured. Gracefully falling back to MockChatProvider.");
            return fallbackProvider.getReply(userMessage, context);
        }

        try {
            String prompt = buildSystemPrompt(userMessage, context);
            String requestJson = buildRequestBody(prompt);

            String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                    + model + ":generateContent?key=" + apiKey;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(endpoint))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                    .POST(HttpRequest.BodyPublishers.ofString(requestJson))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                String reply = parseReply(response.body());
                if (reply != null && !reply.isBlank()) {
                    return reply.trim();
                }
            } else if (response.statusCode() == 429 && !"gemini-3.1-flash-lite".equalsIgnoreCase(model)) {
                logger.warn("Quota exceeded for model {}, retrying with gemini-3.1-flash-lite", model);
                try {
                    String retryEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent?key=" + apiKey;
                    HttpRequest retryReq = HttpRequest.newBuilder()
                            .uri(URI.create(retryEndpoint))
                            .header("Content-Type", "application/json")
                            .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                            .POST(HttpRequest.BodyPublishers.ofString(requestJson))
                            .build();
                    HttpResponse<String> retryRes = httpClient.send(retryReq, HttpResponse.BodyHandlers.ofString());
                    if (retryRes.statusCode() == 200) {
                        String reply = parseReply(retryRes.body());
                        if (reply != null && !reply.isBlank()) {
                            return reply.trim();
                        }
                    }
                } catch (Exception retryEx) {
                    logger.warn("Retry with gemini-3.1-flash-lite failed: {}", retryEx.getMessage());
                }
            } else {
                logger.warn("Gemini API returned non-200 status code: {}. Body: {}", response.statusCode(), response.body());
            }

            // On unexpected response, degrade gracefully
            return fallbackProvider.getReply(userMessage, context);

        } catch (Exception e) {
            // Guardrail requirement: Wrapped in try/catch. On failure, return degraded response.
            logger.error("Outbound call to Gemini API failed or timed out. Falling back to degraded response: {}", e.getMessage());
            return fallbackProvider.getReply(userMessage, context);
        }
    }

    private String buildSystemPrompt(String userMessage, String context) {
        return "You are the AI Assistant for PraveenMart, a premier multi-seller e-commerce marketplace.\n"
                + "YOUR ROLE:\n"
                + "1. Converse naturally and warmly like a friendly, knowledgeable customer support and shopping companion.\n"
                + "2. Answer ALL questions related to PraveenMart and its website, including:\n"
                + "   - User accounts, logging in (/login), registering a new account (/register), passwords, profile settings\n"
                + "   - Browsing, searching, and filtering products across categories (Electronics, Fashion & Style, Home & Kitchen, Accessories, Books)\n"
                + "   - Adding items to cart (/cart), viewing cart, and completing checkout (/checkout)\n"
                + "   - Order tracking and order statuses (/orders: PENDING -> CONFIRMED -> SHIPPED -> DELIVERED)\n"
                + "   - Shipping details (free delivery, 2-4 business days) and returns/refunds (7-day customer-friendly policy)\n"
                + "   - Payment methods (UPI Instant Pay, Credit/Debit Cards, Cash on Delivery)\n"
                + "   - Wishlist (/wishlist), customer reviews and 1-5 star ratings\n"
                + "   - Seller features: registering as a seller, accessing the Seller Hub (/seller), listing products and managing sales\n"
                + "3. Answer the customer's question directly and conversationally with clear steps. Do NOT dump rigid lists of canned 'try asking' bullet points.\n"
                + "4. If a user asks something completely outside of PraveenMart or shopping (e.g. general politics, weather, math puzzles), politely guide the conversation back to PraveenMart.\n\n"
                + "STORE CONTEXT & INVENTORY:\n"
                + (context != null ? context : "Available categories: Electronics, Fashion & Style, Home & Kitchen, Accessories, Books.") + "\n\n"
                + "CUSTOMER QUERY:\n"
                + userMessage;
    }

    private String buildRequestBody(String prompt) {
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonArray partsArray = new JsonArray();
        partsArray.add(textPart);

        JsonObject contentObj = new JsonObject();
        contentObj.add("parts", partsArray);

        JsonArray contentsArray = new JsonArray();
        contentsArray.add(contentObj);

        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.7);
        generationConfig.addProperty("maxOutputTokens", 1000);

        JsonObject root = new JsonObject();
        root.add("contents", contentsArray);
        root.add("generationConfig", generationConfig);

        return gson.toJson(root);
    }

    private String parseReply(String responseJson) {
        try {
            JsonObject root = gson.fromJson(responseJson, JsonObject.class);
            if (root == null) return null;
            JsonArray candidates = root.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                JsonObject content = firstCandidate.getAsJsonObject("content");
                if (content != null) {
                    JsonArray parts = content.getAsJsonArray("parts");
                    if (parts != null && parts.size() > 0) {
                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < parts.size(); i++) {
                            JsonObject part = parts.get(i).getAsJsonObject();
                            if (part.has("text")) {
                                if (part.has("thought") && part.get("thought").getAsBoolean()) {
                                    continue;
                                }
                                sb.append(part.get("text").getAsString());
                            }
                        }
                        String text = sb.toString().trim();
                        if (!text.isEmpty()) {
                            return text;
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.warn("Failed to parse Gemini response JSON: {}", e.getMessage());
        }
        return null;
    }
}
