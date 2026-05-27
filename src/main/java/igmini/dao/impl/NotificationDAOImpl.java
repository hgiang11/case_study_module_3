package igmini.dao.impl;

import igmini.dao.NotificationDAO;
import igmini.model.Notification;
import igmini.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {
    @Override
    public boolean addNotification(int userId, int senderId, String type, Integer postId) {
        // Nếu tự mình tương tác với bài viết của mình thì không tạo thông báo
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
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT n.*, u.username, u.avatarUrl FROM notifications n " +
                "JOIN users u ON n.sender_id = u.id " +
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
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean markAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
