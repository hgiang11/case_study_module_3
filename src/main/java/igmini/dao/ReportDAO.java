package igmini.dao;

import igmini.model.Report;
import java.util.List;

public interface ReportDAO {
    boolean insertReport(Report report);      // Lưu báo cáo bài viết từ User
    boolean insertUserReport(Report report);  // Lưu báo cáo tài khoản từ User
    List<Report> getAllReports();             // Admin lấy tất cả báo cáo hệ thống
    boolean deleteReport(int reportId);       // Admin bỏ qua/bác bỏ báo cáo
}