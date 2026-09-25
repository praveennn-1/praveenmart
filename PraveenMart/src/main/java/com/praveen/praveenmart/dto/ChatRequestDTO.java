package com.praveen.praveenmart.dto;

/**
 * Request payload for Chatbot API endpoint (/api/v1/chat).
 */
public class ChatRequestDTO {

    private String message;

    public ChatRequestDTO() {
    }

    public ChatRequestDTO(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
