package com.praveen.praveenmart.service;

import com.praveen.praveenmart.dao.ProductDAO;
import com.praveen.praveenmart.dto.ChatResponseDTO;
import com.praveen.praveenmart.exception.ValidationException;
import com.praveen.praveenmart.model.Product;
import com.praveen.praveenmart.service.chat.ChatProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ChatServiceTest {

    @Mock
    private ChatProvider chatProvider;

    @Mock
    private ProductDAO productDAO;

    private ChatService chatService;

    @BeforeEach
    public void setUp() {
        chatService = new ChatService(chatProvider, productDAO);
    }

    @Test
    public void testEmptyMessageThrowsValidationException() {
        assertThrows(ValidationException.class, () -> chatService.processMessage(""));
        assertThrows(ValidationException.class, () -> chatService.processMessage("   "));
        assertThrows(ValidationException.class, () -> chatService.processMessage(null));
    }

    @Test
    public void testMessageExceedingMaxCharsThrowsValidationException() {
        String longMessage = "a".repeat(501);
        assertThrows(ValidationException.class, () -> chatService.processMessage(longMessage));
    }

    @Test
    public void testValidMessageProcessesSuccessfully() throws ValidationException {
        Product p = new Product();
        p.setId(1L);
        p.setName("Wireless Earbuds");
        p.setCategory("Electronics");
        p.setPrice(new BigDecimal("1999.00"));

        when(productDAO.findAll()).thenReturn(List.of(p));
        when(chatProvider.getReply(anyString(), anyString())).thenReturn("Here are the earbuds you asked for.");

        ChatResponseDTO response = chatService.processMessage("Tell me about earbuds");

        assertNotNull(response);
        assertEquals("Here are the earbuds you asked for.", response.getReply());
        verify(chatProvider, times(1)).getReply(eq("Tell me about earbuds"), contains("Wireless Earbuds"));
    }

    @Test
    public void testProviderExceptionDegradesGracefully() throws ValidationException {
        when(productDAO.findAll()).thenReturn(List.of());
        when(chatProvider.getReply(anyString(), anyString())).thenThrow(new RuntimeException("Simulated API failure"));

        ChatResponseDTO response = chatService.processMessage("Hello");

        assertNotNull(response);
        assertNotNull(response.getReply());
        assertTrue(response.getReply().contains("trouble processing") || response.getReply().contains("support@praveenmart.com"));
    }

    @Test
    public void testBuildStoreContextHandlesEmptyList() {
        when(productDAO.findAll()).thenReturn(List.of());
        String context = chatService.buildStoreContext();
        assertNotNull(context);
        assertTrue(context.contains("Store categories"));
    }
}
