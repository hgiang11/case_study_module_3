package igmini.controller;

import igmini.dao.FollowDAO;
import igmini.dao.NotificationDAO;    // NHỚ THÊM IMPORT NÀY
import igmini.dao.impl.FollowDAOImpl;
import igmini.dao.impl.NotificationDAOImpl; // NHỚ THÊM IMPORT NÀY
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/follow")
public class FollowServlet extends HttpServlet {
    private final FollowDAO followDAO = new FollowDAOImpl();
    private final NotificationDAO notiDAO = new NotificationDAOImpl(); // Khai báo đối tượng thông báo

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập giống như các Servlet khác
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int followingId = Integer.parseInt(request.getParameter("userId")); // Người được bấm theo dõi
            int followerId = currentUser.getId(); // Người bấm (chính là bạn)
            boolean isFollowingNow;

            // 2. Logic kiểm tra xem đã follow chưa để đảo trạng thái (Toggle)
            if (followDAO.isFollowing(followerId, followingId)) {
                followDAO.unfollow(followerId, followingId);
                isFollowingNow = false;
            } else {
                followDAO.follow(followerId, followingId);
                isFollowingNow = true;

                try {

                    notiDAO.addNotification(followingId, followerId, "FOLLOW", null);
                } catch (Exception e) {
                    System.out.println("Lỗi khi tạo thông báo Follow ngầm: " + e.getMessage());
                    e.printStackTrace();
                }
            }

            // 3. Trả về kết quả JSON để AJAX trên giao diện xử lý đổi màu nút bấm mượt mà
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": true, \"isFollowing\": " + isFollowingNow + "}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Invalid user ID\"}");
        }
    }
}