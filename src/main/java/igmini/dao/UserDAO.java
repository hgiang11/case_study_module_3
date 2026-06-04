package igmini.dao;

import igmini.model.User;

import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public interface UserDAO {

    boolean registerUser(User user);
    User checkLogin(String username, String password);
    boolean updateUser(User user);
    User getUserById(int id);
    List<User> searchUsers(String keyword, int currentUserId);



    List<User> getAllUsers(); // Lấy toàn bộ danh sách tài khoản
    boolean toggleUserStatus(int userId, boolean status); // Khóa hoặc mở khóa tài khoản
    boolean updateUserRole(int userId, String newRole); // Đổi quyền USER <-> ADMIN



    boolean changePassword(int userId, String newPasswordInput);
}