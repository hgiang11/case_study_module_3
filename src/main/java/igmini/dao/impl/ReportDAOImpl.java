package igmini.dao.impl;

import igmini.dao.ReportDAO;
import igmini.model.Report;
import igmini.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAOImpl implements ReportDAO {

    @Override
    public boolean insertReport(Report report) {
        String sql = "INSERT INTO reports (reporter_id, post_id, reason) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getReporter_id());
            ps.setInt(2, report.getPost_id());
            ps.setString(3, report.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean insertUserReport(Report report) {
        String sql = "INSERT INTO reports (reporter_id, reported_user_id, reason) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getReporter_id());
            if (report.getReporter_user_id() > 0 ) {
                ps.setInt(2, report.getReporter_user_id());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, report.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Report> getAllReports() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                "u1.username AS reporter_name, " +
                "p.caption, p.image_url, " +
                "u2.username AS reported_username " +
                "FROM reports r " +
                "JOIN users u1 ON r.reporter_id = u1.id " +
                "LEFT JOIN posts p ON r.post_id = p.id " +
                "LEFT JOIN users u2 ON r.reported_user_id = u2.id " +
                "ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Report r = new Report();
                r.setId(rs.getInt("id"));
                r.setReporter_id(rs.getInt("reporter_id"));

                int postId = rs.getInt("post_id");
                if (!rs.wasNull()) r.setPost_id(postId);

                int reportedUserId = rs.getInt("reported_user_id");
                if (!rs.wasNull()) r.setReporter_user_id(reportedUserId);

                r.setReason(rs.getString("reason"));
                r.setCreated_at(rs.getTimestamp("created_at"));
                r.setReporter_name(rs.getString("reporter_name"));
                r.setPost_caption(rs.getString("caption"));
                r.setPost_image_url(rs.getString("image_url"));
                r.setReportedUsername(rs.getString("reported_username"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deleteReport(int reportId) {
        String sql = "DELETE FROM reports WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    @Override
    public Report checkReport(int reportId) {
        String sql = "SELECT r.*, " +
                "u1.username AS reporter_name, " +
                "p.caption, p.image_url, " +
                "u2.username AS reported_username " +
                "FROM reports r " +
                "JOIN users u1 ON r.reporter_id = u1.id " +
                "LEFT JOIN posts p ON r.post_id = p.id " +
                "LEFT JOIN users u2 ON r.reported_user_id = u2.id " +
                "WHERE r.post_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Report r = new Report();
                    r.setId(rs.getInt("id"));
                    r.setReporter_id(rs.getInt("reporter_id"));

                    int postId = rs.getInt("post_id");
                    if (!rs.wasNull()) r.setPost_id(postId);

                    int reportedUserId = rs.getInt("reported_user_id");
                    if (!rs.wasNull()) r.setReporter_user_id(reportedUserId);

                    r.setReason(rs.getString("reason"));
                    r.setCreated_at(rs.getTimestamp("created_at"));
                    r.setReporter_name(rs.getString("reporter_name"));
                    r.setPost_caption(rs.getString("caption"));
                    r.setPost_image_url(rs.getString("image_url"));
                    r.setReportedUsername(rs.getString("reported_username"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy bản ghi tố cáo nào trùng ID
    }
}