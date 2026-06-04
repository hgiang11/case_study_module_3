package igmini.controller.admin;

import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("id");

        if (action != null && userIdStr != null) {
            int userId = Integer.parseInt(userIdStr);
            if (userId != currentUser.getId()) {
                if ("toggleStatus".equals(action)) {
                    boolean currentStatus = Boolean.parseBoolean(request.getParameter("status"));
                    userDAO.toggleUserStatus(userId, !currentStatus);
                } else if ("changeRole".equals(action)) {
                    String currentRole = request.getParameter("role");
                    String newRole = "ADMIN".equals(currentRole) ? "USER" : "ADMIN";
                    userDAO.updateUserRole(userId, newRole);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        List<User> allUsers = userDAO.getAllUsers();
        request.setAttribute("allUsers", allUsers);

        request.getRequestDispatcher("/admin_users.jsp").forward(request, response);
    }
}