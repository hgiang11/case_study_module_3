package igmini.controller.admin;

import igmini.dao.impl.PostDAOImpl; // Nhớ import đúng tầng PostDAO của bạn
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/delete-post")
public class AdminDeletePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int postId = Integer.parseInt(request.getParameter("id"));

            PostDAOImpl postDAO = new PostDAOImpl();
            boolean success = postDAO.deletePostByAdmin(postId);

            HttpSession session = request.getSession();
            if (success) {
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