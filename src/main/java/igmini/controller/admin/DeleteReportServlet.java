package igmini.controller;

import igmini.dao.ReportDAO;
import igmini.dao.impl.ReportDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-report")
public class DeleteReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));

            // Gọi DAO xóa bản ghi báo cáo này
            reportDAO.deleteReport(reportId);

        } catch (Exception e) {
            e.printStackTrace();
        }
        // Xử lý xong quay về lại trang danh sách báo cáo
        response.sendRedirect(request.getContextPath() + "/admin/reports");
    }
}