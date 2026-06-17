package igmini.controller.admin;

import igmini.dao.ReportDAO;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.dao.impl.ReportDAOImpl;
import igmini.model.Report;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-report")
public class DeleteReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();

    private final NotificationDAOImpl notificationDAO = new NotificationDAOImpl();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));

            // 1. Lấy thông tin bản ghi báo cáo từ DB bằng hàm checkReport của bạn
            Report report = reportDAO.checkReport(reportId);

            if (report != null) {
                // Bốc dữ liệu chuẩn xác theo các thuộc tính trong ảnh file Report.java của bạn
                int targetUserId = report.getReporter_user_id(); // Người bị vi phạm nhận thông báo
                int postId = report.getPost_id();               // ID bài viết bị báo cáo

                // 2. Thực hiện xóa bản ghi báo cáo vi phạm khỏi hệ thống
                boolean isDeleted = reportDAO.deleteReport(reportId);

                if (isDeleted) {
                    // 3. Tự động gửi thông báo hệ thống về cho User bị báo cáo dựa theo post_id
                    if (postId > 0) {
                        // Nếu có post_id tức là Admin vừa thực hiện duyệt gỡ bài viết vi phạm
                        String msg = "Một bài viết của bạn đã bị Ban quản trị gỡ bỏ khỏi hệ thống do vi phạm tiêu chuẩn cộng đồng sau khi nhận phản hồi báo cáo.";
                        // Bài viết đã bị xóa hoàn toàn khỏi DB nên tham số postId truyền vào bảng notifications là null
                        notificationDAO.insertAdminNotification(targetUserId, "DELETE_POST", null, msg);
                    } else {
                        // Nếu không có post_id (bằng 0) tức là Admin xử lý báo cáo vi phạm tài khoản
                        String msg = "Tài khoản của bạn tạm thời bị cảnh cáo hoạt động do vi phạm quy định hệ thống hoặc nhận nhiều báo cáo xấu từ cộng đồng.";
                        notificationDAO.insertAdminNotification(targetUserId, "LOCK_USER", null, msg);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/reports");
    }
}