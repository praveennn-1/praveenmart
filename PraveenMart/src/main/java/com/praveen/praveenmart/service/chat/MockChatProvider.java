package com.praveen.praveenmart.service.chat;

import java.util.Locale;

/**
 * Mock implementation of {@link ChatProvider} delivering canned domain responses
 * for e-commerce FAQs and product searches without requiring external network access.
 * Fulfills Section 11.4 and Section 17.1 specifications.
 */
public class MockChatProvider implements ChatProvider {

    /**
     * Generates a canned FAQ or catalog search response based on the user's inquiry and domain context.
     *
     * @param userMessage the query entered by the user
     * @param context active product and catalog details
     * @return markdown-formatted customer service answer
     */
    @Override
    public String getReply(String userMessage, String context) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Hello! How can I assist you with PraveenMart products today?";
        }

        String msg = userMessage.toLowerCase(Locale.ENGLISH).trim();

        // 1. Greetings
        if (msg.matches(".*\\b(hi|hello|hey|greetings|hola|good morning|good evening|good afternoon)\\b.*")) {
            return "Hello! Welcome to PraveenMart AI Assistant. I can help you discover products, track your orders, check shipping/return policies, or learn how to sell on our platform. How can I help you today?";
        }

        // 2. Who are you / Identity
        if (msg.contains("who are you") || msg.contains("what can you do") || msg.contains("what are you") || msg.contains("help me")) {
            return "I am the PraveenMart Shopping Assistant! You can ask me about:\n"
                    + "• Product recommendations across Electronics, Fashion, Home & Kitchen, Accessories, and Books\n"
                    + "• How to track your orders and order status workflows\n"
                    + "• Shipping timelines and delivery fees\n"
                    + "• Returns, refunds, and cancellations\n"
                    + "• Payment methods (UPI, Cards, Cash on Delivery)\n"
                    + "• Becoming a seller on PraveenMart";
        }

        // 3. Categories & Products list
        if (msg.contains("category") || msg.contains("categories") || msg.contains("what do you sell") || msg.contains("what products") || msg.contains("catalog")) {
            return "PraveenMart features a wide range of curated products across 5 main categories:\n"
                    + "1. **Electronics**: Premium headphones, gaming mice, mechanical keyboards, chargers, and accessories.\n"
                    + "2. **Fashion & Style**: Vintage knit polos, classic khaki button-downs, leather loafers, and slides.\n"
                    + "3. **Home & Kitchen**: Stoneware dinner plates, granite cookware, wooden whisks, and blenders.\n"
                    + "4. **Accessories**: Pebbled leather wallets, polarized sunglasses, and travel backpacks.\n"
                    + "5. **Books**: Programming and data science guides (Python, Algorithms, C++).\n\n"
                    + "You can filter by category on our store page or ask me for specific items!";
        }

        // 4. Electronics specific
        if (msg.contains("electronic") || msg.contains("headphone") || msg.contains("earbud") || msg.contains("keyboard") || msg.contains("mouse") || msg.contains("charger") || msg.contains("power bank")) {
            return "We have top-tier electronics available!\n"
                    + "• **Apple AirPods Pro** & **Bowers & Wilkins Wireless Headphones** for high-fidelity audio\n"
                    + "• **Soundcore Space One** active noise-canceling headphones\n"
                    + "• **Logitech G502 HERO** high-performance gaming mouse\n"
                    + "• **Compact 60% Mechanical Keyboard** with RGB lighting\n"
                    + "• **SuperVOOC & USB-C Fast Chargers**\n"
                    + "Visit the Electronics category on our Store page to view details and add items to your cart.";
        }

        // 5. Fashion & Style specific
        if (msg.contains("fashion") || msg.contains("cloth") || msg.contains("shirt") || msg.contains("polo") || msg.contains("shoe") || msg.contains("sneaker") || msg.contains("loafer") || msg.contains("sandal") || msg.contains("pant")) {
            return "Our Fashion & Style collection offers premium everyday elegance:\n"
                    + "• **Chocolate Brown Retro Knit Polo** & **Classic Khaki Button-Down Shirt**\n"
                    + "• **Black Leather Loafers** crafted from premium leather\n"
                    + "• **Nike Free Metcon Training Sneakers** & **Cork Slide Sandals**\n"
                    + "• **Hollister Cargo Pants**\n"
                    + "Check out the Fashion category on PraveenMart for sizing and quick order!";
        }

        // 6. Home & Kitchen specific
        if (msg.contains("kitchen") || msg.contains("home") || msg.contains("plate") || msg.contains("cookware") || msg.contains("blender") || msg.contains("cutting board") || msg.contains("knife") || msg.contains("utensil")) {
            return "Upgrade your culinary space with our Home & Kitchen essentials:\n"
                    + "• **Forest Green & Ceramic Round Dinner Plate Sets**\n"
                    + "• **Granite Cookware Non-Stick Set**\n"
                    + "• **Kenwood Glass High-Speed Blender**\n"
                    + "• **Bamboo 4-Piece Cutting Board Set** & **Acacia Wood Kitchen Utensils**\n"
                    + "Browse the Home & Kitchen tab to shop these handcrafted items.";
        }

        // 7. Books specific
        if (msg.contains("book") || msg.contains("python") || msg.contains("algorithm") || msg.contains("data science") || msg.contains("coding") || msg.contains("programming")) {
            return "Boost your technical knowledge with our popular tech titles:\n"
                    + "• **Python from Zero**: Comprehensive beginner to intermediate guide\n"
                    + "• **Learning Data Science**: Hands-on analytics and modeling\n"
                    + "• **Software Engineering and Algorithms**: Core data structures and algorithmic problem solving\n"
                    + "• **C++ Computer Science**: Fundamental programming concepts";
        }

        // 8. Order Tracking & Status
        if (msg.contains("track") || msg.contains("where is my order") || msg.contains("order status") || (msg.contains("order") && (msg.contains("history") || msg.contains("check")))) {
            return "You can easily track your orders by navigating to **My Orders** in the top navigation menu. "
                    + "Our order fulfillment progresses through 4 stages: "
                    + "`PENDING` → `CONFIRMED` → `SHIPPED` → `DELIVERED`. "
                    + "Once an order is marked `DELIVERED`, you can submit star ratings and detailed reviews!";
        }

        // 9. Shipping & Delivery
        if (msg.contains("shipping") || msg.contains("delivery") || msg.contains("deliver") || msg.contains("how long")) {
            return "Here are our shipping details:\n"
                    + "• **Delivery Timeline**: 2 to 4 business days for standard delivery across metro locations.\n"
                    + "• **Shipping Fee**: Free standard shipping on all orders above ₹999. A flat ₹49 fee applies for smaller orders.\n"
                    + "• **Live Tracking**: Real-time status updates are reflected in your **My Orders** dashboard.";
        }

        // 10. Returns, Refunds & Cancellation
        if (msg.contains("return") || msg.contains("refund") || msg.contains("cancel") || msg.contains("exchange")) {
            return "PraveenMart provides a customer-friendly 7-day return and refund policy:\n"
                    + "• **Eligible Items**: Products that are unused, in original packaging with intact tags, can be returned within 7 days of delivery.\n"
                    + "• **Refund Processing**: Once your return item is received and inspected, refunds are credited back to your original payment method (or UPI account) within 2-3 business days.\n"
                    + "• **Cancellations**: Orders in `PENDING` status can be cancelled prior to dispatch.";
        }

        // 11. Payment Methods
        if (msg.contains("payment") || msg.contains("pay") || msg.contains("upi") || msg.contains("card") || msg.contains("cod") || msg.contains("cash on delivery")) {
            return "PraveenMart supports multiple secure payment methods at checkout:\n"
                    + "1. **UPI Instant Pay**: Google Pay, PhonePe, Paytm, or BHIM UPI ID.\n"
                    + "2. **Credit & Debit Cards**: Visa, MasterCard, RuPay, and American Express.\n"
                    + "3. **Cash on Delivery (COD)**: Pay securely in cash or via QR upon package delivery.\n"
                    + "All online transactions use simulated mock verification for safe instant checkout.";
        }

        // 12. Seller onboarding / How to sell
        if (msg.contains("seller") || msg.contains("sell") || msg.contains("become a seller") || msg.contains("list product") || msg.contains("vendor")) {
            return "Interested in selling on PraveenMart? Here is how to get started:\n"
                    + "1. Register an account and choose the **Seller** role during signup.\n"
                    + "2. Access your **Seller Hub** from the navigation bar.\n"
                    + "3. Create, edit, and manage your product listings (name, price, stock, category, image URL).\n"
                    + "4. Track incoming buyer orders and sales performance directly on your dashboard.";
        }

        // 13. Reviews & Ratings
        if (msg.contains("review") || msg.contains("rating") || msg.contains("feedback") || msg.contains("star")) {
            return "Customer feedback helps our community! Buyers who have ordered products can leave 1-to-5 star ratings and detailed reviews on completed orders. You can view all customer reviews right on each product's details page.";
        }

        // 14. Customer Support / Contact
        if (msg.contains("contact") || msg.contains("support") || msg.contains("customer care") || msg.contains("email") || msg.contains("phone")) {
            return "Need personal assistance? You can reach PraveenMart Customer Support via:\n"
                    + "• **Email**: support@praveenmart.com (or admin@praveenmart.com)\n"
                    + "• **Hours**: Monday to Saturday, 9:00 AM – 8:00 PM IST\n"
                    + "• **Order Inquiries**: Include your Order ID when writing to us for faster resolution.";
        }

        // 15. Check dynamic context for specific keyword matches
        if (context != null && !context.isBlank()) {
            String[] keywords = msg.replaceAll("[^a-zA-Z0-9\\s]", " ").split("\\s+");
            for (String kw : keywords) {
                if (kw.length() > 3 && context.toLowerCase(Locale.ENGLISH).contains(kw)) {
                    return "I found items related to '" + kw + "' in our catalog! You can search for '" + kw
                            + "' in the search bar on our Store page to see available options, pricing, and live inventory.";
                }
            }
        }

        // Fallback response with helpful hints
        return "I can help you with anything on PraveenMart! Try asking:\n"
                + "• 'What products do you have in Electronics?'\n"
                + "• 'How do I track my order?'\n"
                + "• 'What payment methods can I use?'\n"
                + "• 'What is your return policy?'\n"
                + "• 'How can I become a seller?'";
    }
}
