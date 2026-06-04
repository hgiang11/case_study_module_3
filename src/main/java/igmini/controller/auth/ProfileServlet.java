package igmini.controller.auth;

import igmini.dao.FollowDAO;
import igmini.dao.PostDAO;
import igmini.dao.UserDAO;
import igmini.dao.impl.FollowDAOImpl;
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
    private FollowDAO followDAO = new FollowDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User profileUser = null;
        String userIDParam = request.getParameter("userId");

        if (userIDParam != null && !userIDParam.isEmpty()) {
            try {
                int targetId = Integer.parseInt(userIDParam);
                profileUser = userDAO.getUserById(targetId);
            } catch (NumberFormatException e) {
                profileUser = currentUser;
            }
        } else {
            profileUser = currentUser;
        }

        if (profileUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy người dùng!");
            return;
        }

        if (!profileUser.isActive() && currentUser.getId() != profileUser.getId()) {
            request.setAttribute("error", "Tài khoản này đã bị khóa hoặc tạm dừng hoạt động!");
            request.getRequestDispatcher("/home").forward(request, response);
            return;
        }

        List<Post> userPosts = postDAO.getPostsByUserId( profileUser.getId());

        boolean isFollowing = followDAO.isFollowing(currentUser.getId(), profileUser.getId());
        request.setAttribute("isFollowing", Boolean.valueOf(isFollowing));

        int followerCount = followDAO.getFollowerCount(profileUser.getId());
        int followingCount = followDAO.getFollowingCount(profileUser.getId());

        request.setAttribute("followerCount", followerCount);
        request.setAttribute("followingCount", followingCount);

        request.setAttribute("profileUser", profileUser);
        request.setAttribute("userPosts", userPosts);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}