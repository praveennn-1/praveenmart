package com.praveen.praveenmart.service.chat;

/**
 * Strategy interface for AI Chatbot providers (Section 17.1).
 * Implementations provide conversational responses for shopping and product domain queries.
 */
public interface ChatProvider {

    /**
     * Generates an AI or canned response for the user's message.
     *
     * @param userMessage the prompt/message submitted by the user
     * @param context domain and store catalog context
     * @return reply string to return to the client
     */
    String getReply(String userMessage, String context);
}
