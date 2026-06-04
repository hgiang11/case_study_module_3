package igmini.controller.admin;

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

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String postIdStr = request.getParameter("id");

        if ("delete".equals(action) && postIdStr != null) {
            int postId = Integer.parseInt(postIdStr);
            postDAO.deletePostByAdmin(postId);
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