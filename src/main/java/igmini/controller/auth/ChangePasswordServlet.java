package igmini.controller.auth;

import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (oldPass == null || newPass == null || confirmPass == null || newPass.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả các trường!");
            request.getRequestDispatcher("/change_password.jsp").forward(request, response);
            return;
        }


        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới và mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/change_password.jsp").forward(request, response);
            return;
        }


        User userInDb = userDAO.checkLogin(currentUser.getUsername(), oldPass);

        if (userInDb == null) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác!");
            request.getRequestDispatcher("/change_password.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.changePassword(currentUser.getId(), newPass);
        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");

            session.invalidate();
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra từ hệ thống, vui lòng thử lại sau!");
            request.getRequestDispatcher("/change_password.jsp").forward(request, response);
        }
    }
}