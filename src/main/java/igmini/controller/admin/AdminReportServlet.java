package igmini.controller.admin;

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

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Report> reportList = reportDAO.getAllReports();

        request.setAttribute("reportList", reportList);

        request.getRequestDispatcher("/admin_reports.jsp").forward(request, response);
    }
}