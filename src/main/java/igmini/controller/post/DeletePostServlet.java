package igmini.controller.post;

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/delete-post")
public class DeletePostServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Vui lòng sử dụng POST để xóa bài viết.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int postId = Integer.parseInt(idParam);

                // kiểm tra bài viết
                Post post = postDAO.getPostById(postId);

                if (post == null) {
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                } else {
                    if (post.getUser_id() != currentUser.getId()) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa bài viết này!");
                        return;
                    }

                    // Thực hiện xóa vĩnh viễn
                    postDAO.deletePost(postId);
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Quay về trang Profile để xem kết quả
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}