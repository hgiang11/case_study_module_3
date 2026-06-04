package igmini.controller.interaction;

import igmini.dao.LikeDAO;
import igmini.dao.PostDAO;
import igmini.dao.NotificationDAO;
import igmini.dao.impl.LikeDAOImpl;
import igmini.dao.impl.PostDAOImpl;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.model.Post;             
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LikeServlet", value = "/like")
public class LikeServlet extends HttpServlet {
    private final LikeDAO likeDAO = new LikeDAOImpl();
    private final PostDAO postDAO = new PostDAOImpl(); // Khai báo đối tượng lấy bài viết
    private final NotificationDAO notiDAO = new NotificationDAOImpl(); // Khai báo đối tượng tạo thông báo

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            String xhr = request.getHeader("X-Requested-With");
            if (xhr != null && "XMLHttpRequest".equals(xhr)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"error\":\"unauthorized\"}");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            int userId = user.getId();
            boolean isLikedNow;

            // 2. Nếu đã từng like rồi -> Thực hiện Unlike. Ngược lại -> Thực hiện Like.
            if (likeDAO.checkIfUserLiked(userId, postId)) {
                likeDAO.deleteLike(userId, postId);
                isLikedNow = false; // Trạng thái sau khi bấm là UNLIKE
            } else {
                likeDAO.insertLike(userId, postId);
                isLikedNow = true;  // Trạng thái sau khi bấm là LIKE

                // --- BẮT ĐẦU ĐOẠN XỬ LÝ TẠO THÔNG BÁO NGẦM ---
                try {
                    // Tìm chi tiết bài viết xem chủ bài viết là ai để gửi thông báo
                    Post post = postDAO.getPostById(postId);
                    if (post != null) {
                        int postOwnerId = post.getUser_id(); // Lấy ID của chủ bài viết (Người nhận)
                        int senderId = user.getId();         // Lấy ID của người vừa bấm Like (Người gửi)

                        // Tiến hành lưu thông báo vào Database
                        // Hàm addNotification đã tự chặn cấu hình: nếu postOwnerId == senderId (tự like bài mình) thì sẽ không lưu thông báo.
                        notiDAO.addNotification(postOwnerId, senderId, "LIKE", postId);
                    }
                } catch (Exception e) {
                    System.out.println("Lỗi khi tạo thông báo Like ngầm: " + e.getMessage());
                    e.printStackTrace();
                }
                // --- KẾT THÚC ĐOẠN XỬ LÝ TẠO THÔNG BÁO NGẦM ---
            }

            // 3. Trả về dữ liệu dạng JSON nếu là cuộc gọi AJAX ngầm từ giao diện
            String xhr = request.getHeader("X-Requested-With");
            if (xhr != null && "XMLHttpRequest".equals(xhr)) {
                int count = likeDAO.getLikeCount(postId);
                response.setContentType("application/json;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    // Dùng biến isLikedNow trực tiếp, không cần truy vấn lại DB
                    out.print("{\"liked\": " + isLikedNow + ", \"count\": " + count + "}");
                }
                return; // Kết thúc sớm luồng xử lý AJAX
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid post ID");
            return; // Đảm bảo thoát ra ngay lập tức để không chạy xuống sendRedirect phía dưới
        }

        // 4. Nếu là click trực tiếp không qua AJAX (Dùng làm phương án backup), quay về trang home
        response.sendRedirect(request.getContextPath() + "/home");
    }
}