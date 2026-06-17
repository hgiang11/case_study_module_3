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

@WebServlet("/admin/check-report")
public class AdminCheckReportServlet extends HttpServlet {

    private ReportDAO reportDAO = new ReportDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int reportId = Integer.parseInt(idParam);

                Report reportDetail = reportDAO.checkReport(reportId);

                if (reportDetail != null) {
                    request.setAttribute("reportDetail", reportDetail);


                    request.getRequestDispatcher("/check_report_detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }


        
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
}