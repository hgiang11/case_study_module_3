package igmini.controller.common;

import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;



@WebServlet(name = "AdminEditUserServlet", value = "/admin-edit-user")
public class AdminEditUserServlet extends HttpServlet {
    private UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(userId);

            if (user != null) {
                request.setAttribute("editUser", user);
                // Gọi tới file jsp nằm trong thư mục gốc webapp
                request.getRequestDispatcher("/admin_edit_user.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        boolean isActive = request.getParameter("isActive") != null; // Có tích chọn checkbox = true
        String newPassword = request.getParameter("newPassword");
        String username = request.getParameter("username");

        boolean success = userDAO.adminUpdateUserFull(id, username, email, role, isActive, newPassword);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "Cập nhật thất bại, vui lòng kiểm tra lại!");
            doGet(request, response);
        }
    }
}