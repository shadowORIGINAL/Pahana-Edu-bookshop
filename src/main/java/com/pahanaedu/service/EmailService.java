package com.pahanaedu.service;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {
    // Singleton instance
    private static EmailService instance;

    // Gmail credentials (⚠️ best to load from env variables or config, not hardcode!)
    private final String username = "wickramasinghakalana3@gmail.com";
    private final String password = "cnyn tbml btvn bjdd".replace(" ", "");

    // Private constructor prevents instantiation
    private EmailService() {}

    // Thread-safe global access point
    public static synchronized EmailService getInstance() {
        if (instance == null) {
            instance = new EmailService();
        }
        return instance;
    }

    public void sendEmail(String to, String subject, String content) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, "Pahana Edu Bookshop"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            session.setDebug(true); // Debugging (disable in production)

            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);
        } catch (MessagingException e) {
            System.err.println("Failed to send email to " + to);
            e.printStackTrace();
            throw new Exception("Failed to send email: " + e.getMessage(), e);
        }
    }
}
