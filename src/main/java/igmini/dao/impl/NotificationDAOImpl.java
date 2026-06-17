package igmini.dao.impl;

import igmini.dao.NotificationDAO;
import igmini.model.Notification;
import igmini.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {
    @Override
    public boolean addNotification(int userId, int senderId, String type, Integer postId) {
        if (userId == senderId) return false;

        String sql = "INSERT INTO notifications (user_id, sender_id, type, post_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, senderId);
            ps.setString(3, type);
            if (postId != null) {
                ps.setInt(4, postId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT n.*, u.username, u.avatarUrl FROM notifications n " +
                "LEFT JOIN users u ON n.sender_id = u.id " +
                "WHERE n.user_id = ? ORDER BY n.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setSenderId(rs.getInt("sender_id"));
                    n.setType(rs.getString("type"));
                    int pId = rs.getInt("post_id");
                    n.setPostId(rs.wasNull() ? null : pId);
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    n.setSenderUsername(rs.getString("username"));
                    n.setSenderAvatarUrl(rs.getString("avatarUrl"));
                    list.add(n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean markAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }



    @Override
    public boolean createNotification(Notification noti) {
        String sql = "INSERT INTO notifications (user_id, sender_id, type, post_id, content, is_read, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); // Thay bằng cách lấy Connection của bạn
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noti.getUserId());
            ps.setInt(2, noti.getSenderId()); // Hệ thống gỡ bài thì truyền 0 hoặc ID của Admin vào đây
            ps.setString(3, noti.getType());  // Ví dụ: "SYSTEM" hoặc "DELETE_POST"

            if (noti.getPostId() != null) {
                ps.setInt(4, noti.getPostId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            ps.setString(5, noti.getContent());
            ps.setBoolean(6, noti.isRead()); // Mặc định truyền false (chưa đọc)
            ps.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }



    public boolean insertAdminNotification(int userId, String type, Integer postId, String content) {
        String sql = "INSERT INTO notifications (user_id, sender_id, type, post_id, content, is_read) VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, 0); // Quy ước sender_id = 0 tức là hệ thống/Admin gửi ngầm
            ps.setString(3, type);

            // Xử lý đối với kiểu dữ liệu Integer có thể null trong PreparedStatement
            if (postId != null) {
                ps.setInt(4, postId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            ps.setString(5, content);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }




    public boolean insertSystemNotification(int userId, String type, Integer postId, String content) {
        String sql = "INSERT INTO notifications (user_id, sender_id, type, post_id, content, is_read) VALUES (?, 0, ?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, type);
            if (postId != null) {
                ps.setInt(3, postId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, content);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    @Override
    public boolean insertSystemNotificationByPostId(int postId, String type, String content) {
        int postOwnerId = 0;

        String sqlSelectOwner = "SELECT user_id FROM posts WHERE id = ?";

        String sqlInsertNoti = "INSERT INTO notifications (user_id, sender_id, type, post_id, content, is_read, created_at) " +
                "VALUES (?, NULL, ?, NULL, ?, 0, NOW())";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelectOwner)) {
                psSelect.setInt(1, postId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        postOwnerId = rs.getInt("user_id");
                    }
                }
            }

            if (postOwnerId > 0) {
                try (PreparedStatement psInsert = conn.prepareStatement(sqlInsertNoti)) {
                    psInsert.setInt(1, postOwnerId);
                    psInsert.setString(2, type);
                    psInsert.setString(3, content);

                    int rows = psInsert.executeUpdate();
                    conn.commit();
                    return rows > 0;
                }
            }

            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
