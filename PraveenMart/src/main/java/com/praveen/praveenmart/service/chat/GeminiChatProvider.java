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
    private static final String DEFAULT_MODEL = "gemini-1.5-flash";
    private static final int TIMEOUT_SECONDS = 5;

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
     * @param model model name (e.g., gemini-1.5-flash)
     */
    public GeminiChatProvider(String apiKey, String model) {
        this.apiKey = apiKey;
        this.model = (model != null && !model.isBlank()) ? model : DEFAULT_MODEL;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                .build();
    }

    private static String resolveApiKey() {
        String key = System.getProperty("gemini.api.key", System.getenv("GEMINI_API_KEY"));
        return (key != null) ? key.trim() : null;
    }

    private static String resolveModel() {
        String m = System.getProperty("gemini.model", System.getenv("GEMINI_MODEL"));
        return (m != null && !m.isBlank()) ? m.trim() : DEFAULT_MODEL;
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
        return "You are the AI Shopping Assistant for PraveenMart, a premier multi-seller e-commerce marketplace.\n"
                + "STRICT GUARDRAIL RULES:\n"
                + "1. Restrict your answers strictly to PraveenMart product domain queries, categories (Electronics, Fashion & Style, Home & Kitchen, Accessories, Books), order tracking, shipping, returns, and seller inquiries.\n"
                + "2. If the user asks something completely outside of shopping/e-commerce (e.g. general politics, weather, math puzzles, coding unrelated to the store), politely steer them back to shopping on PraveenMart.\n"
                + "3. Keep your answers concise, helpful, friendly, and under 3-4 short paragraphs.\n\n"
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
        generationConfig.addProperty("maxOutputTokens", 350);

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
                        return parts.get(0).getAsJsonObject().get("text").getAsString();
                    }
                }
            }
        } catch (Exception e) {
            logger.warn("Failed to parse Gemini response JSON: {}", e.getMessage());
        }
        return null;
    }
}
