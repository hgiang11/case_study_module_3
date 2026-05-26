package igmini.dao.impl;

import igmini.dao.PostDAO;
import igmini.model.Post;
import igmini.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PostDAOImpl implements PostDAO {
    @Override
    public boolean insertPost(Post post) {
        String sql = "INSERT INTO posts (user_id, image_url, caption) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getImageUrl());
            ps.setString(3, post.getCaption());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    @Override
    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        // Thêm p.created_at vào query
        String sql = "SELECT p.*, u.username, u.avatar_url FROM posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "ORDER BY p.created_at DESC";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setCaption(rs.getString("caption"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));

                    // QUAN TRỌNG: Gán thêm username vào object Post
                    p.setUsername(rs.getString("username"));
                    p.setAvatarUrl(rs.getString("avatar_url"));

                    list.add(p);
                }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Post> getPostsByUserId(int userId) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Post p = new Post();
                p.setId(rs.getInt("id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setCaption(rs.getString("caption"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUserId(rs.getInt("user_id"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    @Override
    public boolean deletePost(int postId) {
        String sql = "DELETE FROM posts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
                    p.setUserId(rs.getInt("user_id"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setCaption(rs.getString("caption"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    @Override
    public boolean createPost(Post post) {
        String sql = "INSERT INTO posts (user_id, image_url, caption) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getImageUrl());
            ps.setString(3, post.getCaption());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}