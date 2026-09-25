package com.praveen.praveenmart.service.chat;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class MockChatProviderTest {

    private MockChatProvider provider;

    @BeforeEach
    public void setUp() {
        provider = new MockChatProvider();
    }

    @Test
    public void testNullOrEmptyMessage() {
        String reply = provider.getReply(null, "");
        assertNotNull(reply);
        assertTrue(reply.contains("assist you"));

        String reply2 = provider.getReply("   ", "");
        assertNotNull(reply2);
    }

    @Test
    public void testGreetings() {
        String reply = provider.getReply("Hello, who are you?", "");
        assertNotNull(reply);
        assertTrue(reply.toLowerCase().contains("praveenmart"));
    }

    @Test
    public void testCategoriesAndCatalogInquiry() {
        String reply = provider.getReply("What categories and products do you sell?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("Electronics"));
        assertTrue(reply.contains("Fashion"));
        assertTrue(reply.contains("Home & Kitchen"));
    }

    @Test
    public void testElectronicsInquiry() {
        String reply = provider.getReply("Tell me about your headphones and keyboard", "");
        assertNotNull(reply);
        assertTrue(reply.contains("AirPods") || reply.contains("Headphones") || reply.contains("Keyboard"));
    }

    @Test
    public void testFashionInquiry() {
        String reply = provider.getReply("Do you have shoes or polo shirts?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("Polo") || reply.contains("Loafers") || reply.contains("Fashion"));
    }

    @Test
    public void testHomeAndKitchenInquiry() {
        String reply = provider.getReply("Looking for blender and cookware for my kitchen", "");
        assertNotNull(reply);
        assertTrue(reply.contains("Cookware") || reply.contains("Blender") || reply.contains("Kitchen"));
    }

    @Test
    public void testBooksInquiry() {
        String reply = provider.getReply("What python or data science books do you offer?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("Python") || reply.contains("Data Science"));
    }

    @Test
    public void testOrderTrackingInquiry() {
        String reply = provider.getReply("How do I track my order status?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("My Orders") || reply.contains("PENDING"));
    }

    @Test
    public void testShippingPolicyInquiry() {
        String reply = provider.getReply("How long does delivery take and what is the shipping fee?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("2 to 4") || reply.contains("shipping") || reply.contains("₹999"));
    }

    @Test
    public void testReturnPolicyInquiry() {
        String reply = provider.getReply("What is your refund and return policy?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("7-day") || reply.contains("return"));
    }

    @Test
    public void testPaymentMethodsInquiry() {
        String reply = provider.getReply("What payment methods can I use? Do you support UPI?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("UPI") && reply.contains("Cards"));
    }

    @Test
    public void testSellerOnboardingInquiry() {
        String reply = provider.getReply("How do I become a seller on your website?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("Seller") || reply.contains("Seller Hub"));
    }

    @Test
    public void testCustomerSupportInquiry() {
        String reply = provider.getReply("How can I contact customer support email?", "");
        assertNotNull(reply);
        assertTrue(reply.contains("@praveenmart.com"));
    }

    @Test
    public void testDynamicCatalogContextSearch() {
        String context = "Available products: SuperSound Headphones, Wireless Mouse, Vintage Denim Jacket";
        String reply = provider.getReply("Can I find a jacket?", context);
        assertNotNull(reply);
        assertTrue(reply.contains("jacket") || reply.contains("catalog") || reply.contains("Store page"));
    }
}
