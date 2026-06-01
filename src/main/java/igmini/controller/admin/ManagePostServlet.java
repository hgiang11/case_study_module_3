package igmini.controller;

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/posts")
public class ManagePostServlet extends HttpServlet {
    private final PostDAO postDAO = new PostDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // PHÂN QUYỀN BẢO MẬT: Chỉ ADMIN mới được vào phá
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Kiểm tra xem Admin có ấn nút XÓA bài viết hay không
        String action = request.getParameter("action");
        String postIdStr = request.getParameter("id");

        if ("delete".equals(action) && postIdStr != null) {
            int postId = Integer.parseInt(postIdStr);
            postDAO.deletePostByAdmin(postId);
            // Xóa xong điều hướng tải lại trang Quản lý bài viết để cập nhật giao diện ngay
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