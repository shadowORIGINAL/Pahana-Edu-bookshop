package com.pahanaedu.daotest;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import com.pahanaedu.model.PasswordResetToken;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class UserDAOTest {

    private UserDAO userDAO;

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
    }

    // Helper method to create a test user
    private User createTestUser(String email, String plainPassword, String role) throws Exception {
        User user = new User();
        user.setEmail(email);
        user.setPassword(BCrypt.hashpw(plainPassword, BCrypt.gensalt()));
        user.setFirstName("Test");
        user.setLastName("User");
        user.setRole(role);
        user.setAddress("123 Test St");
        user.setTelephone("0771234567");
        user.setActive(true);
        user.setUnitsConsumed(0);
        userDAO.saveUser(user);
        return user;
    }

//    @Test
//    void testSaveAndRetrieveUser() throws Exception {
//        User user = createTestUser("testuser@example.com", "testpass", "Customer");
//
//        // Retrieve by email
//        User retrieved = userDAO.getUserByEmail(user.getEmail());
//        assertNotNull(retrieved, "User should be retrievable by email");
//        assertEquals(user.getEmail(), retrieved.getEmail());
//
//        // Verify password using BCrypt
//        assertTrue(BCrypt.checkpw("testpass", retrieved.getPassword()), "Password should match the hash");
//
//        // Cleanup
//        userDAO.deleteUser(user.getId());
//    }
//
//    @Test
//    void testUpdateUserPassword() throws Exception {
//        User user = createTestUser("testuser@example.com", "oldpass", "Customer");
//
//        // Update password
//        String newPassword = BCrypt.hashpw("newpassss", BCrypt.gensalt());
//        userDAO.updateUserPassword(user.getId(), newPassword);
//
//        // Verify password update
//        User updated = userDAO.getUserByEmail("testuser@example.com");
//        assertNotNull(updated, "User should exist after password update");
//        assertTrue(BCrypt.checkpw("newpassss", updated.getPassword()), "Password should be updated correctly");
//
//        // Cleanup
//        userDAO.deleteUser(user.getId());
//    }
//
    @Test
    void testUpdateAndDeleteUser() throws Exception {
        User user = createTestUser("testuser@example.com", "pass123", "Customer");

        // Update
        user.setFirstName("Updated");
        userDAO.updateUser(user);
        User updated = userDAO.getUserById(user.getId());
        assertEquals("Updated", updated.getFirstName(), "User's first name should be updated");

        // Delete
        userDAO.deleteUser(user.getId());
        User deleted = userDAO.getUserById(user.getId());
        assertNull(deleted, "Deleted user should not be retrievable");
    }
//
//    @Test
//    void testPasswordResetTokenFlow() throws Exception {
//        User user = createTestUser("resetuser@example.com", "pass123", "Customer");
//
//        // Store token
//        String token = "resettoken123";
//        LocalDateTime expiry = LocalDateTime.now().plusHours(1);
//        userDAO.storePasswordResetToken(user.getId(), token, expiry);
//
//        // Retrieve token
//        PasswordResetToken prt = userDAO.getPasswordResetToken(token);
//        assertNotNull(prt, "Token should be retrievable");
//        assertEquals(token, prt.getToken());
//
//        // Invalidate token
//        userDAO.invalidatePasswordResetToken(token);
//        PasswordResetToken invalidated = userDAO.getPasswordResetToken(token);
//        assertTrue(invalidated.isUsed(), "Token should be marked as used");
//
//        // Cleanup
//        userDAO.deleteUser(user.getId());
//    }
//    
//    @Test
//    void testRegisterWithExistingEmail() throws Exception {
//        String email = "duplicate@example.com";
//
//        User existing = userDAO.getUserByEmail(email);
//        if (existing != null) userDAO.deleteUser(existing.getId());
//
//        User user1 = new User();
//        user1.setEmail(email);
//        user1.setPassword(BCrypt.hashpw("pass123", BCrypt.gensalt()));
//        user1.setFirstName("Test");
//        user1.setLastName("User");
//        user1.setRole("Customer");
//        user1.setActive(true);
//        userDAO.saveUser(user1);
//
//        Exception ex = assertThrows(Exception.class, () -> {
//            User user2 = new User();
//            user2.setEmail(email);
//            user2.setPassword(BCrypt.hashpw("anotherpass", BCrypt.gensalt()));
//            user2.setFirstName("Another");
//            user2.setLastName("User");
//            user2.setRole("Customer");
//            user2.setActive(true);
//            userDAO.saveUser(user2);
//        });
//        assertTrue(ex.getMessage().contains("Failed to save user"));
//
//        userDAO.deleteUser(user1.getId());
//    }
}
