package igmini.controller.interaction;

import igmini.dao.CommentDAO;
import igmini.dao.NotificationDAO;
import igmini.dao.PostDAO;
import igmini.dao.impl.CommentDAOImpl;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {

    private final PostDAO postDAO = new PostDAOImpl();
    private final NotificationDAO notiDAO = new NotificationDAOImpl();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        try {
            String postIdStr = request.getParameter("post_id_comment");
            String content = request.getParameter("content");

            if (postIdStr == null || postIdStr.isEmpty() || content == null || content.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing data\"}");
                return;
            }

            int post_id_comment = Integer.parseInt(postIdStr);
            content = content.trim();

            CommentDAO commentDAO = new CommentDAOImpl();
            boolean success = commentDAO.insertComment(user.getId(), post_id_comment, content);



            if (success) {
                try {
                    // Lấy thông tin bài viết dựa vào post_id_comment để tìm chủ bài viết
                    Post post = postDAO.getPostById(post_id_comment);
                    if (post != null) {
                        int postOwnerId = post.getUser_id();
                        int senderId = user.getId();


                        notiDAO.addNotification(postOwnerId, senderId, "COMMENT", post_id_comment);
                    }
                } catch (Exception e) {
                    System.out.println("Lỗi khi tạo thông báo Comment ngầm: " + e.getMessage());
                    e.printStackTrace();
                }
                // --- KẾT THÚC ĐOẠN XỬ LÝ TẠO THÔNG BÁO BÌNH LUẬN NGẦM ---

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid postId\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Server error\"}");
            e.printStackTrace();
        }
    }
}