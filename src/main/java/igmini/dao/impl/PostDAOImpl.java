package igmini.dao.impl;

import igmini.dao.PostDAO;
import igmini.model.Post;
import igmini.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostDAOImpl implements PostDAO {


    private Post mapRow(ResultSet rs) throws SQLException {
        Post p = new Post();
        p.setId(rs.getInt("id"));
        p.setUser_id(rs.getInt("user_id"));
        p.setImage_url(rs.getString("image_url"));
        p.setCaption(rs.getString("caption"));
        p.setCreated_at(rs.getTimestamp("created_at"));
        p.setUsername(rs.getString("username"));
        p.setAvatarUrl(rs.getString("avatarUrl"));
        return p;
    }


    @Override
    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT p.*, u.username, u.avatarUrl FROM posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "WHERE u.is_active = 1 " +
                "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post post = mapRow(rs);
                list.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deletePost(int post_id) {
        String deleteLikes = "DELETE FROM likes WHERE post_id_like = ?";
        String deleteComments = "DELETE FROM comments WHERE post_id_comment = ?";
        String deleteReports = "DELETE FROM reports WHERE post_id = ?";
        String deletePost = "DELETE FROM posts WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(deleteLikes)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deleteComments)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deleteReports)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deletePost)) {
                ps.setInt(1, post_id);
                int rowAffected = ps.executeUpdate();
                conn.commit();
                return rowAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    @Override
    public Post getPostById(int id) {
        String sql = "SELECT * FROM posts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setUser_id(rs.getInt("user_id"));
                    p.setImage_url(rs.getString("image_url"));
                    p.setCaption(rs.getString("caption"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean createPost(Post post) {
        String sql = "INSERT INTO posts (user_id, image_url, caption) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUser_id());
            ps.setString(2, post.getImage_url());
            ps.setString(3, post.getCaption());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Post> getPostsByUserId(int user_id) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user_id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setImage_url(rs.getString("image_url"));
                    p.setCaption(rs.getString("caption"));
                    p.setCreated_at(rs.getTimestamp("created_at"));
                    p.setUser_id(rs.getInt("user_id"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Post> getAllPostsForAdmin() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT p.*, u.username FROM posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post post = mapRow(rs);
                list.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deletePostByAdmin(int post_id) {
        String deleteLikes = "DELETE FROM likes WHERE post_id_like = ?";
        String deleteComments = "DELETE FROM comments WHERE post_id_comment = ?";
        String deleteReports = "DELETE FROM reports WHERE post_id = ?";
        String deletePost = "DELETE FROM posts WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(deleteLikes)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deleteComments)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deleteReports)) {
                ps.setInt(1, post_id);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(deletePost)) {
                ps.setInt(1, post_id);
                int rows = ps.executeUpdate();
                conn.commit();
                return rows > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Post> getReportedPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT p.*, r.id AS report_id, r.reason, r.created_at AS report_date, u.username AS reporter_name " +
                "FROM posts p " +
                "INNER JOIN reports r ON p.id = r.post_id " +
                "INNER JOIN users u ON r.reporter_id = u.id " +
                "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post p = new Post();
                p.setId(rs.getInt("id"));
                p.setUser_id(rs.getInt("user_id"));
                p.setImage_url(rs.getString("image_url"));
                p.setCaption(rs.getString("caption"));
                p.setCreated_at(rs.getTimestamp("created_at"));
                p.setUsername(rs.getString("reporter_name"));
                String reason = rs.getString("reason");
                String originalCaption = rs.getString("caption");
                p.setCaption("⚠️ LÝ DO: " + (reason != null ? reason : "Không rõ") + " | (Nội dung gốc: " + (originalCaption != null ? originalCaption : "") + ")");
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    @Override
    public boolean updatePost(Post post) {
        // Câu lệnh SQL cập nhật cả caption và image_url dựa vào ID bài viết
        String sql = "UPDATE posts SET caption = ?, image_url = ? WHERE id = ?";

        // Sử dụng try-with-resources để tự động đóng Connection và PreparedStatement
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Truyền dữ liệu mới vào các dấu hỏi chấm (?)
            ps.setString(1, post.getCaption());
            ps.setString(2, post.getImage_url());
            ps.setInt(3, post.getId());

            // Chạy câu lệnh và kiểm tra xem có dòng nào trong DB bị thay đổi không
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Nếu lớn hơn 0 tức là sửa thành công

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}