package com.pahanaedu.factory;

import com.pahanaedu.model.User;
import javax.servlet.http.HttpServletRequest;
import org.mindrot.jbcrypt.BCrypt;
import java.security.SecureRandom;

public class UserFactory {

    public static UserWithPlainPassword createUserFromRequest(HttpServletRequest request) {
        User user = new User();

        // Generate temporary password
        String generatedPassword = generateRandomPassword();
        String hashedPassword = BCrypt.hashpw(generatedPassword, BCrypt.gensalt());

        // Populate user fields
        user.setEmail(request.getParameter("email"));
        user.setPassword(hashedPassword); // store hashed password
        user.setFirstName(request.getParameter("first_name"));
        user.setLastName(request.getParameter("last_name"));
        user.setRole(request.getParameter("role"));
        user.setAddress(request.getParameter("address"));
        user.setTelephone(request.getParameter("telephone"));
        user.setActive(true);
        user.setUnitsConsumed(parseUnitsConsumed(request.getParameter("units_consumed")));

        return new UserWithPlainPassword(user, generatedPassword);
    }

    private static int parseUnitsConsumed(String unitsStr) {
        try {
            return unitsStr != null && !unitsStr.isEmpty() ? Integer.parseInt(unitsStr) : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private static String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    // Helper class to hold both User and plain password
    public static class UserWithPlainPassword {
        private final User user;
        private final String plainPassword;

        public UserWithPlainPassword(User user, String plainPassword) {
            this.user = user;
            this.plainPassword = plainPassword;
        }

        public User getUser() {
            return user;
        }

        public String getPlainPassword() {
            return plainPassword;
        }
    }
}
