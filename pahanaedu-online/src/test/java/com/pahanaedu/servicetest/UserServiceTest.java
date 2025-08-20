package com.pahanaedu.servicetest;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    private UserService userService;
    private UserDAO userDAOMock;

    @BeforeEach
    void setUp() throws Exception {
        userService = UserService.getInstance();
        userDAOMock = mock(UserDAO.class);

        // Inject mock DAO via reflection
        var field = UserService.class.getDeclaredField("userDAO");
        field.setAccessible(true);
        field.set(userService, userDAOMock);
    }

    @Test
    void testAuthenticate_Success() throws Exception {
        String rawPassword = "mypassword";
        User user = new User();
        user.setEmail("user@example.com");
        user.setPassword(BCrypt.hashpw(rawPassword, BCrypt.gensalt()));

        when(userDAOMock.getUserByEmail("user@example.com")).thenReturn(user);

        User result = userService.authenticate("user@example.com", rawPassword);

        assertNotNull(result);
        assertEquals("user@example.com", result.getEmail());
    }

//    @Test
//    void testRegisterUser_Success() throws Exception {
//        User user = new User();
//        user.setEmail("newuser@example.com");
//        user.setFirstName("John");
//        user.setLastName("Doe");
//
//        userService.registerUser(user);
//
//        verify(userDAOMock).saveUser(user);
//    }
//
//    @Test
//    void testGetAllStaff_Success() throws Exception {
//        User staff = new User();
//        staff.setEmail("staff@example.com");
//
//        when(userDAOMock.getAllUsersByRole("STAFF")).thenReturn(List.of(staff));
//
//        List<User> result = userService.getAllStaff();
//
//        assertEquals(1, result.size());
//        assertEquals("staff@example.com", result.get(0).getEmail());
//    }
//
//    @Test
//    void testUpdatePassword_Success() throws Exception {
//        userService.updatePassword(1L, "newpass123");
//        verify(userDAOMock).updateUserPassword(1L, "newpass123");
//    }
//
//    // ================= RED TESTS (simulated failures) =================
//
//    @Test
//    void testAuthenticate_WrongPassword() throws Exception {
//        User user = new User();
//        user.setEmail("user@example.com");
//        user.setPassword(BCrypt.hashpw("correctpass", BCrypt.gensalt()));
//
//        when(userDAOMock.getUserByEmail("user@example.com")).thenReturn(user);
//
//        User result = userService.authenticate("user@example.com", "wrongpass");
//        assertNull(result); // Correct assertion
//    }
//
//    @Test
//    void testAuthenticate_NoUserFound() throws Exception {
//        when(userDAOMock.getUserByEmail("missing@example.com")).thenReturn(null);
//
//        User result = userService.authenticate("missing@example.com", "any");
//        assertNull(result); // Correct assertion
//    }
//
//    @Test
//    void testUpdatePassword_NullPassword() {
//        Exception ex = assertThrows(Exception.class, () -> userService.updatePassword(1L, null));
//        assertEquals("User ID or new password cannot be null or empty", ex.getMessage());
//    }
//
//    @Test
//    void testRegisterUser_DAOFailure() throws Exception {
//        User user = new User();
//        user.setEmail("fail@example.com");
//        doThrow(new Exception("DB error")).when(userDAOMock).saveUser(user);
//
//        Exception ex = assertThrows(Exception.class, () -> userService.registerUser(user));
//        assertEquals("DB error", ex.getMessage()); // Use getMessage(), not getCause()
//    }
}
