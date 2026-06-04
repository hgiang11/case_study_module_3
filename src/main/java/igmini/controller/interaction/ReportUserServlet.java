package igmini.controller.interaction;

import igmini.dao.ReportDAO;
import igmini.dao.impl.ReportDAOImpl;
import igmini.model.Report;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reportUser")
public
class ReportUserServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int reportedUserId = Integer.parseInt(request.getParameter("reportedUserId"));
            String reason = request.getParameter("reason");

            Report report = new Report();
            report.setReporter_id(currentUser.getId());
            report.setReporter_user_id(reportedUserId);
            report.setReason(reason);

            reportDAO.insertUserReport(report);
            session.setAttribute("message", "Đã gửi báo cáo tài khoản thành công!");

            // Quay lại trang cá nhân của người vừa bị báo cáo
            response.sendRedirect(request.getContextPath() + "/profile?userId=" + reportedUserId);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}