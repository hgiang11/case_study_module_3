package igmini.controller;

import igmini.dao.impl.PostDAOImpl; // Nhớ import đúng tầng PostDAO của bạn
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/delete-post") // Đường dẫn xử lý hành động xóa bài của Admin
public class AdminDeletePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int postId = Integer.parseInt(request.getParameter("id"));

            // Gọi hàm xóa bài viết do Admin chỉ định (hàm xử lý Transaction xóa sạch Likes, Comments, Reports trước đó)
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

        // Xử lý xong thì điều hướng Admin quay trở lại danh sách quản lý bài viết
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
}