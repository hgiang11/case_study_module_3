package igmini.controller.admin;

import igmini.dao.impl.NotificationDAOImpl;
import igmini.dao.impl.PostDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import igmini.utils.DBConnection;

@WebServlet("/admin/delete-post")
public class AdminDeletePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession();

            int postOwnerId = 0;
            String sqlSelectOwner = "SELECT user_id FROM posts WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement psSelect = conn.prepareStatement(sqlSelectOwner)) {
                psSelect.setInt(1, postId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        postOwnerId = rs.getInt("user_id");
                    }
                }
            }

            PostDAOImpl postDAO = new PostDAOImpl();
            boolean success = postDAO.deletePostByAdmin(postId);

            if (success) {
                if (postOwnerId > 0) {
                    new NotificationDAOImpl().insertSystemNotification(
                            postOwnerId,
                            "SYSTEM_DELETE",
                            null,
                            "Bài viết của bạn đã vi phạm tiêu chuẩn cộng đồng và bắt buộc bị xóa khỏi hệ thống."
                    );
                }
                session.setAttribute("message", "Đã xóa vĩnh viễn bài viết vi phạm thành công!");
            } else {
                session.setAttribute("message", "Xóa bài viết thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
}