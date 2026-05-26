
package igmini.dao.impl;

import igmini.dao.CommentDAO;
import igmini.utils.DBConnection;
import igmini.model.Comment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentDAOImpl implements CommentDAO {

    /**
     * Hàm lưu bình luận mới vào DB
     * @param userId ID của user viết comment
     * @param postId ID của bài viết
     * @param content Nội dung bình luận
     * @return true nếu thêm thành công, false nếu thất bại
     */
    @Override
    public boolean insertComment(int userId, int postId, String content) {
        String sql = "INSERT INTO comments (user_id_comment, post_id_comment, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            ps.setString(3, content);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hàm lấy danh sách bình luận của 1 bài viết (JOIN với username)
     * @param postId ID của bài viết
     * @return List<Comment> danh sách bình luận (có kèm username)
     */
    @Override
    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> commentList = new ArrayList<>();

        String sql = "SELECT c.id, c.user_id_comment, c.post_id_comment, c.content, " +
                "c.created_at, u.username " +
                "FROM comments c " +
                "JOIN users u ON c.user_id_comment = u.id " +
                "WHERE c.post_id_comment = ? " +
                "ORDER BY c.created_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("id"));
                    comment.setUserIdComment(rs.getInt("user_id_comment"));
                    comment.setPostIdComment(rs.getInt("post_id_comment"));
                    comment.setContent(rs.getString("content"));

                    // Xử lý an toàn tránh NullPointerException nếu created_at trống
                    if (rs.getTimestamp("created_at") != null) {
                        comment.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    comment.setUsername(rs.getString("username"));

                    commentList.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return commentList;
    }

    /**
     * Hàm xóa bình luận
     * @param commentId ID của bình luận cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    @Override
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hàm lấy số lượng bình luận của 1 bài viết
     * @param postId ID của bài viết
     * @return Số lượt comment, 0 nếu không có
     */
    @Override
    public int getCommentCount(int postId) {
        String sql = "SELECT COUNT(*) AS cnt FROM comments WHERE post_id_comment = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cnt");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}