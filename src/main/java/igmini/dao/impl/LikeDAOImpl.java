package igmini.dao.impl;

import igmini.utils.DBConnection;
import igmini.dao.LikeDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;



public class LikeDAOImpl implements LikeDAO {

    // 1. Kiểm tra xem User đã like bài viết này chưa
    @Override
    public boolean checkIfUserLiked(int user_id_like, int post_id_like) {
        String sql = "SELECT * FROM likes WHERE user_id_like = ? AND post_id_like = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id_like);
            ps.setInt(2, post_id_like) ;
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // 2. Thêm lượt Like
    @Override
    public boolean insertLike(int user_id_like, int post_id_like) {
        String sql = "INSERT INTO likes (user_id_like, post_id_like) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id_like);
            ps.setInt(2, post_id_like);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // 3. Hủy Like (Unlike)
    @Override
    public boolean deleteLike(int user_id_like, int post_id_like) {
        String sql = "DELETE FROM likes WHERE user_id_like = ? AND post_id_like = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id_like);
            ps.setInt(2, post_id_like);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // 4. Lấy số lượt like của 1 bài viết
    @Override
    public int getLikeCount(int post_id_like) {
        String sql = "SELECT COUNT(*) AS cnt FROM likes WHERE post_id_like = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, post_id_like);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return 0;
    }

}