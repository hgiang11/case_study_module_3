package igmini.controller;

import igmini.dao.ReportDAO;
import igmini.dao.impl.ReportDAOImpl;
import igmini.model.Report;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports") // Đường dẫn vào trang quản lý báo cáo của Admin
public class AdminReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy toàn bộ danh sách báo cáo từ cơ sở dữ liệu sử dụng hàm LEFT JOIN đã viết
        List<Report> reportList = reportDAO.getAllReports();

        // 2. Đẩy danh sách này vào request attribute
        request.setAttribute("reportList", reportList);

        // 3. Chuyển hướng sang file giao diện JSP của admin (bạn xem lại đường dẫn thư mục jsp của bạn nhé)
        request.getRequestDispatcher("/admin_reports.jsp").forward(request, response);
    }
}