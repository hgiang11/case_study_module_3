package igmini.controller.admin;

import igmini.dao.NotificationDAO;
import igmini.dao.PostDAO;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Notification;
import igmini.model.Post;
import igmini.model.User;

import igmini.utils.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/admin/posts")
public class ManagePostServlet extends HttpServlet {
    private final PostDAO postDAO = new PostDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String postIdStr = request.getParameter("id");

        if ("delete".equals(action) && postIdStr != null) {
            try {
                int postId = Integer.parseInt(postIdStr);

                // 1. Tìm thông tin bài viết trước khi gỡ để lấy user_id và caption gốc
                Post post = postDAO.getPostById(postId); // Bạn nhớ đảm bảo trong postDAO có hàm lấy 1 Post theo ID nhé

                if (post != null) {
                    // Lấy caption cũ để đưa vào nội dung thông báo giúp người dùng nhận diện bài viết nào bị gỡ
                    String cleanCaption = (post.getCaption() != null && !post.getCaption().isEmpty()) ? post.getCaption() : "Không có nội dung";

                    // 2. Thiết lập nội dung thông báo bảo mật (Tuyệt đối không có thông tin người report)
                    String systemMessage = "Hệ thống ghi nhận bài viết với nội dung \"" + cleanCaption + "\" của bạn đã vi phạm tiêu chuẩn cộng đồng và đã bị Admin gỡ bỏ.";

                    // 3. Khởi tạo đối tượng thông báo
                    Notification noti = new Notification();
                    noti.setUserId(post.getUser_id()); // Gửi trực tiếp tới ID của chủ bài viết
                    noti.setSenderId(0);               // 0 đại diện cho Hệ thống tự động phát ra thông báo
                    noti.setType("SYSTEM_DELETE");     // Gán phân loại thông báo từ hệ thống
                    noti.setPostId(null);              // Bài viết đã bị xóa hẳn khỏi DB nên để null
                    noti.setContent(systemMessage);    // Nội dung ẩn danh người báo cáo
                    noti.setRead(false);               // Mặc định là người dùng chưa đọc

                    notificationDAO.createNotification(noti);
                }

                postDAO.deletePostByAdmin(postId);

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }









// ---- Thêm đoạn này ngay trước redirect ----
            // Đặt flash message để hiển thị sau redirect
            String toast = "Bài viết đã bị admin gỡ bỏ và bạn đã nhận được thông báo.";
            FlashMessage.set(session, toast);



            response.sendRedirect(request.getContextPath() + "/admin/posts");
            return;
        }


        List<Post> allPosts = postDAO.getAllPostsForAdmin();
        request.setAttribute("allPosts", allPosts);

        List<Post> reportedPosts = postDAO.getReportedPosts();
        request.setAttribute("reportedPosts", reportedPosts);

        request.getRequestDispatcher("/admin_post.jsp").forward(request, response);
    }
}