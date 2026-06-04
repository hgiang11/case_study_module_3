package igmini.controller.auth;

import igmini.dao.impl.UserDAOImpl;
import igmini.dao.UserDAO;
import igmini.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        User newUser = new User(user, email, pass);

        boolean isSuccess = userDAO.registerUser(newUser);

        if (isSuccess) {
            request.setAttribute("successMessage", "Đăng ký thành công! Chào mừng bạn đến với Mini Instagram.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}