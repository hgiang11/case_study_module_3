package igmini.controller;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // 1. Lấy ID bài viết từ URL (ví dụ: delete-post?id=10)
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int postId = Integer.parseInt(idParam);
                Post post = postDAO.getPostById(postId);
                if (post != null && post.getUser_id() != currentUser.getId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa bài viết này!");
                    return;
                }

                postDAO.deletePost(postId);

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 3. Xóa xong thì quay về trang Profile để thấy kết quả ngay
        response.sendRedirect(request.getContextPath() + "/profile");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ủy quyền mọi request từ POST (nếu có) chuyển hết sang cấu trúc doGet xử lý chung
        doGet(request, response);
    }
}