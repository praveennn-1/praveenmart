package com.praveen.praveenmart.service.payment;

public class PaymentResult {

    private final boolean successful;
    private final String transactionId;
    private final String message;

    public PaymentResult(boolean successful, String transactionId, String message) {
        this.successful = successful;
        this.transactionId = transactionId;
        this.message = message;
    }

    public static PaymentResult success(String transactionId, String message) {
        return new PaymentResult(true, transactionId, message);
    }

    public static PaymentResult failure(String message) {
        return new PaymentResult(false, null, message);
    }

    public boolean isSuccessful() {
        return successful;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public String getMessage() {
        return message;
    }
}
