package igmini.controller;

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

        // PHÂN QUYỀN: Nếu chưa đăng nhập hoặc không phải ADMIN -> Đá về trang Home hoặc Login
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Xử lý hành động thay đổi trạng thái Khóa/Mở khóa nếu có request gửi lên
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("id");

        if (action != null && userIdStr != null) {
            int userId = Integer.parseInt(userIdStr);
            // Ngăn việc Admin tự khóa chính mình
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
            // Thực hiện xong thì redirect lại trang để cập nhật dữ liệu mới nhất
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // Lấy danh sách toàn bộ người dùng để hiển thị lên bảng điều khiển
        List<User> allUsers = userDAO.getAllUsers();
        request.setAttribute("allUsers", allUsers);

        request.getRequestDispatcher("/admin_users.jsp").forward(request, response);
    }
}