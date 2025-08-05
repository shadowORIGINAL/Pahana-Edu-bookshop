package com.pahanaedu.service;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import java.util.logging.Logger;

public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private static final Logger logger = Logger.getLogger(UserService.class.getName());
    public User authenticate(String email, String password) throws Exception {
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            logger.info("No user found for email: " + email);
        } else if (!BCrypt.checkpw(password, user.getPassword())) {
            logger.info("Password mismatch for email: " + email);
        }
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public void registerUser(User user) throws Exception {
        userDAO.saveUser(user);
    }
    public List<User> getAllStaff() throws Exception {
        return userDAO.getAllUsersByRole("STAFF");
    }

    public List<User> getAllCustomers() throws Exception {
        return userDAO.getAllUsersByRole("CUSTOMER");
    }

    public User getUserById(long id) throws Exception {
        return userDAO.getUserById(id);
    }

    public void updateUser(User user) throws Exception {
        userDAO.updateUser(user);
    }
    public void updatePassword(Long id, String newPassword) throws Exception {
        // Validate input
        if (id == null || newPassword == null || newPassword.isEmpty()) {
            throw new Exception("User ID or new password cannot be null or empty");
        }
        // Pass the newPassword directly to DAO (assuming it's already hashed in the servlet)
        userDAO.updateUserPassword(id, newPassword);
    }

    public void deleteUser(long id) throws Exception {
        userDAO.deleteUser(id);
    }

    public List<User> searchStaff(String searchTerm) throws Exception {
        return userDAO.searchUsers("STAFF", searchTerm);
    }

    public List<User> searchCustomers(String searchTerm) throws Exception {
        return userDAO.searchUsers("CUSTOMER", searchTerm);
    }
}