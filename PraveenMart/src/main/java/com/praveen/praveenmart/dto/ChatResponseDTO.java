package com.praveen.praveenmart.dto;

/**
 * Response payload for Chatbot API endpoint (/api/v1/chat).
 */
public class ChatResponseDTO {

    private String reply;
    private String provider;
    private long timestamp;

    public ChatResponseDTO() {
    }

    public ChatResponseDTO(String reply, String provider, long timestamp) {
        this.reply = reply;
        this.provider = provider;
        this.timestamp = timestamp;
    }

    public static Builder builder() {
        return new Builder();
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public static class Builder {
        private String reply;
        private String provider;
        private long timestamp = System.currentTimeMillis();

        public Builder reply(String reply) {
            this.reply = reply;
            return this;
        }

        public Builder provider(String provider) {
            this.provider = provider;
            return this;
        }

        public Builder timestamp(long timestamp) {
            this.timestamp = timestamp;
            return this;
        }

        public ChatResponseDTO build() {
            return new ChatResponseDTO(reply, provider, timestamp);
        }
    }
}
