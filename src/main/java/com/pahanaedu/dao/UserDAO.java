package com.pahanaedu.dao;

import com.pahanaedu.config.DBConnection;
import com.pahanaedu.model.PasswordResetToken;
import com.pahanaedu.model.User;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    /**
     * Retrieves a user by email and verifies the provided password using BCrypt.
     */
    public User getUserByEmailAndPassword(String email, String password) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSet(rs);
                    if (BCrypt.checkpw(password, user.getPassword())) {
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error authenticating user by email: " + email, e);
            throw new Exception("Failed to authenticate user.");
        }
        return null;
    }

    /**
     * Saves a new user to the database.
     */
    public void saveUser(User user) throws Exception {
        if (!isValidEmail(user.getEmail())) {
            throw new Exception("Invalid email format.");
        }
        if (user.getFirstName() == null || user.getFirstName().trim().isEmpty()) {
            throw new Exception("First name cannot be empty.");
        }
        String sql = "INSERT INTO users (email, password, first_name, last_name, role, address, telephone, is_active, units_consumed) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword()); // Use the hashed password from the User object
            ps.setString(3, user.getFirstName());
            ps.setString(4, user.getLastName());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getTelephone());
            ps.setBoolean(8, user.isActive());
            ps.setInt(9, user.getUnitsConsumed());
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving user: " + user.getEmail(), e);
            throw new Exception("Failed to save user.");
        }
    }

    /**
     * Updates a user's password (expects hashed password).
     */
    public void updateUserPassword(long userId, String hashedPassword) throws Exception {
        if (userId <= 0 || hashedPassword == null || hashedPassword.isEmpty()) {
            throw new Exception("User ID or new password cannot be null or empty.");
        }
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword); // Use the provided hashed password
            ps.setLong(2, userId);
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating password failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating password for user ID: " + userId, e);
            throw new Exception("Failed to update password.");
        }
    }

    /**
     * Maps a ResultSet to a User object.
     */
    private User mapResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setEmail(rs.getString("email"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setRole(rs.getString("role"));
        user.setPassword(rs.getString("password"));
        user.setAddress(rs.getString("address"));
        user.setTelephone(rs.getString("telephone"));
        user.setUnitsConsumed(rs.getInt("units_consumed"));
        user.setActive(rs.getBoolean("is_active"));
        return user;
    }

    /**
     * Retrieves all users with a specific role, ordered by last name and first name.
     */
    public List<User> getAllUsersByRole(String role) throws Exception {
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY last_name, first_name";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting users by role: " + role, e);
            throw new Exception("Failed to fetch users.");
        }
        return users;
    }

    /**
     * Retrieves a user by ID.
     */
    public User getUserById(long id) throws Exception {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user by ID: " + id, e);
            throw new Exception("Failed to fetch user.");
        }
        return null;
    }

    /**
     * Updates user details (excluding password).
     */
    public void updateUser(User user) throws Exception {
        if (!isValidEmail(user.getEmail())) {
            throw new Exception("Invalid email format.");
        }
        String sql = "UPDATE users SET email=?, first_name=?, last_name=?, address=?, telephone=?, is_active=?, units_consumed=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFirstName());
            ps.setString(3, user.getLastName());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getTelephone());
            ps.setBoolean(6, user.isActive());
            ps.setInt(7, user.getUnitsConsumed());
            ps.setLong(8, user.getId());
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating user failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user: " + user.getId(), e);
            throw new Exception("Failed to update user.");
        }
    }

    /**
     * Deletes a user by ID.
     */
    public void deleteUser(long id) throws Exception {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting user failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting user: " + id, e);
            throw new Exception("Failed to delete user.");
        }
    }

    /**
     * Searches users by role and search term.
     */
    public List<User> searchUsers(String role, String searchTerm) throws Exception {
        String sql = "SELECT * FROM users WHERE role = ? AND " +
                    "(LOWER(email) LIKE LOWER(?) OR LOWER(first_name) LIKE LOWER(?) OR " +
                    "LOWER(last_name) LIKE LOWER(?) OR telephone LIKE ?) " +
                    "ORDER BY last_name, first_name";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            String likeTerm = "%" + searchTerm + "%";
            ps.setString(2, likeTerm);
            ps.setString(3, likeTerm);
            ps.setString(4, likeTerm);
            ps.setString(5, likeTerm);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching users for role: " + role, e);
            throw new Exception("Failed to search users.");
        }
        return users;
    }

    /**
     * Stores a password reset token.
     */
    public void storePasswordResetToken(long userId, String token, LocalDateTime expiryDate) throws Exception {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, Timestamp.valueOf(expiryDate));
            ps.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error storing password reset token", e);
            throw new Exception("Failed to store password reset token.");
        }
    }

    /**
     * Retrieves a password reset token by token value.
     */
    public PasswordResetToken getPasswordResetToken(String token) throws Exception {
        String sql = "SELECT * FROM password_reset_tokens WHERE token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PasswordResetToken resetToken = new PasswordResetToken();
                    resetToken.setRkeyId(rs.getLong("rkey_id"));
                    resetToken.setUserId(rs.getLong("user_id"));
                    resetToken.setToken(rs.getString("token"));
                    resetToken.setExpiryDate(rs.getTimestamp("expiry_date").toLocalDateTime());
                    resetToken.setUsed(rs.getBoolean("used"));
                    resetToken.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    resetToken.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    return resetToken;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving password reset token", e);
            throw new Exception("Failed to retrieve password reset token.");
        }
        return null;
    }

    /**
     * Invalidates a password reset token by marking it as used.
     */
    public void invalidatePasswordResetToken(String token) throws Exception {
        String sql = "UPDATE password_reset_tokens SET used = TRUE WHERE token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                logger.log(Level.WARNING, "No password reset token found for: " + token);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error invalidating password reset token", e);
            throw new Exception("Failed to invalidate password reset token.");
        }
    }

    /**
     * Retrieves a user by email.
     */
    public User getUserByEmail(String email) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user by email: " + email, e);
            throw new Exception("Failed to fetch user by email.");
        }
        return null;
    }

    /**
     * Deletes expired or used password reset tokens.
     */
    public void deleteExpiredTokens() throws Exception {
        String sql = "DELETE FROM password_reset_tokens WHERE expiry_date < ? OR used = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting expired tokens", e);
            throw new Exception("Failed to delete expired tokens.");
        }
    }

    /**
     * Validates email format.
     */
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
}