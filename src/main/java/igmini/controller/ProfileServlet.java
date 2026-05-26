package igmini.controller;

import igmini.dao.PostDAO;
import igmini.dao.UserDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Khai báo biến currentUser lấy từ session
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Khai báo biến profileUser để sử dụng xuyên suốt phương thức
        User profileUser = null;
        String userIDParam = request.getParameter("userId");

        // 3. Sửa lại logic kiểm tra: Nếu CÓ tham số userID thì mới đi tìm người khác
        if (userIDParam != null && !userIDParam.isEmpty()) {
            try {
                int targetId = Integer.parseInt(userIDParam);
                profileUser = userDAO.getUserById(targetId);
            } catch (NumberFormatException e) {
                profileUser = currentUser; // Nếu ID sai định dạng thì xem chính mình
            }
        } else {
            // 4. Nếu không có tham số -> Xem chính mình
            profileUser = currentUser;
        }

        if (profileUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy người dùng!");
            return;
        }

        // 5. Lấy danh sách bài viết của người được xem (profileUser)
        List<Post> userPosts = postDAO.getPostsByUserId(profileUser.getId());

        // Gửi thông tin sang trang JSP
        request.setAttribute("profileUser", profileUser);
        request.setAttribute("userPosts", userPosts);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}