package igmini.controller.interaction;

import igmini.dao.ReportDAO;
import igmini.dao.NotificationDAO;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.dao.impl.ReportDAOImpl;
import igmini.model.Report;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy dữ liệu từ Form gửi lên
            int postId = Integer.parseInt(request.getParameter("postId"));
            String reason = request.getParameter("reason");

            // Tạo đối tượng Report để lưu dữ liệu
            Report report = new Report();
            report.setReporter_id(currentUser.getId());
            report.setPost_id(postId);
            report.setReason(reason);

            // Gọi DAO để thực hiện insert vào database
            boolean success = reportDAO.insertReport(report);
            if (success) {
                // Tạo chuỗi nội dung thông báo gửi cho user2 (chủ bài viết)
                String notiContent = "Bài viết của bạn đã bị báo cáo với lý do: " + reason;

                // 2. THÊM ĐOẠN NÀY: Gọi hàm tự tìm chủ bài viết và bắn thông báo dạng "REPORT"
                boolean notiSuccess = notificationDAO.insertSystemNotificationByPostId(postId, "REPORT", notiContent);

                if (notiSuccess) {
                    session.setAttribute("message", "Đã gửi báo cáo bài viết thành công!");
                } else {
                    // Dự phòng trường hợp lưu báo cáo được nhưng bảng thông báo lỗi
                    session.setAttribute("message", "Đã gửi báo cáo nhưng hệ thống không thể tạo thông báo cho tác giả!");
                }
            } else {
                session.setAttribute("message", "Gửi báo cáo thất bại. Vui lòng thử lại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Có lỗi xảy ra trong quá trình xử lý báo cáo!");
        }

        // Sau khi xử lý xong, chuyển hướng quay trở lại trang chủ (home)
        response.sendRedirect(request.getContextPath() + "/home");
    }
}