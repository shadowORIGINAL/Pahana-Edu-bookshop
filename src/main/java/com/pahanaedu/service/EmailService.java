package com.pahanaedu.service;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {
    private static EmailService instance;
    private final Session session;
    private final String username = "wickramasinghakalana3@gmail.com";
    private final String password = "cnyn tbml btvn bjdd".replace(" ", ""); // Remove spaces from app password

    // Private constructor
    private EmailService() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        // Enable debug for development (optional)
        session.setDebug(true);
    }

    // Thread-safe Singleton getter
    public static EmailService getInstance() {
        if (instance == null) {
            synchronized (EmailService.class) {
                if (instance == null) {
                    instance = new EmailService();
                }
            }
        }
        return instance;
    }

    /**
     * Send email synchronously
     */
    public void sendEmail(String to, String subject, String content) throws Exception {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, "Pahana Edu Bookshop"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);
        } catch (MessagingException e) {
            System.err.println("Failed to send email to " + to);
            e.printStackTrace();
            throw new Exception("Failed to send email: " + e.getMessage(), e);
        }
    }

    /**
     * Send email asynchronously (recommended for order/staff creation)
     */
    public void sendEmailAsync(String to, String subject, String content) {
        new Thread(() -> {
            try {
                sendEmail(to, subject, content);
            } catch (Exception e) {
                System.err.println("Async email failed for: " + to);
                e.printStackTrace();
            }
        }).start();
    }
}
