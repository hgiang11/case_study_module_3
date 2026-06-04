package igmini.dao.impl;

import igmini.model.User;
import igmini.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static igmini.utils.DBConnection.getConnection;

public class UserDAOImpl implements igmini.dao.UserDAO {
    @Override
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            // Hash password với BCrypt
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            ps.setString(3, hashedPassword);

            int rowAffected = ps.executeUpdate();
            return rowAffected > 0; // Trả về true nếu lưu thành công

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    @Override
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                boolean isMatch = false;

                // Kiểm tra nếu là mật khẩu đã hash (BCrypt) hay plain text cũ
                if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$")) {
                    isMatch = BCrypt.checkpw(password, storedPassword);
                } else {
                    // Kiểm tra plain text cũ
                    isMatch = password.equals(storedPassword);
                    // Nếu khớp mật khẩu cũ, tự động hash lại và cập nhật vào DB
                    if (isMatch) {
                        updateUserPassword(rs.getInt("id"), BCrypt.hashpw(password, BCrypt.gensalt()));
                    }
                }

                if (isMatch) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setActive(rs.getBoolean("is_active"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void updateUserPassword(int userId, String newHash) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, avatarUrl = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getAvatarUrl());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public User getUserById(int id) {
        User user = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAvatarUrl(rs.getString("avatarUrl"));
                    user.setRole(rs.getString("role"));
                    user.setActive(rs.getBoolean("is_active"));
                    // Thêm các trường khác nếu bạn có (bio, phone, etc.)
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    @Override
    public List<User> searchUsers(String keyword, int currentUserId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE (username LIKE ? OR email LIKE ?) AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, currentUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setAvatarUrl(rs.getString("avatarUrl"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }



    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setAvatarUrl(rs.getString("avatarUrl"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("is_active"));
                users.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean toggleUserStatus(int userId, boolean status) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateUserRole(int userId, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }



    @Override
    public boolean changePassword(int userId, String newPasswordInput) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String hashedNewPassword = BCrypt.hashpw(newPasswordInput, BCrypt.gensalt());
            ps.setString(1, hashedNewPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}