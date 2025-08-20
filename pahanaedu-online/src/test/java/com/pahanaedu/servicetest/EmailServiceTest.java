	package com.pahanaedu.servicetest;
	
	import com.pahanaedu.service.EmailService;
	import org.junit.jupiter.api.BeforeEach;
	import org.junit.jupiter.api.Test;
	
	import static org.junit.jupiter.api.Assertions.*;
	
	public class EmailServiceTest {
	
	    private EmailService emailService;
	
	    @BeforeEach
	    void setUp() {
	        emailService = EmailService.getInstance();
	    }
	
	    void testSendEmail_Success() {
	        assertDoesNotThrow(() -> {
	            emailService.sendEmail("test@example.com", "Test Subject", "<p>Test content</p>");
	        });
	    }
	
//	    void testSendEmail_InvalidAddress() {
//	        Exception exception = assertThrows(Exception.class, () -> {
//	            emailService.sendEmail("invalid-email", "Test Subject", "Content");
//	        });
//	
//	        assertTrue(exception.getMessage().contains("Invalid Addresses"));
//	    }
//	
//	    void testSendEmailAsync_NoException() {
//	        assertDoesNotThrow(() -> {
//	            emailService.sendEmailAsync("test@example.com", "Async Subject", "Async content");
//	        });
//	    }
	}
