package igmini.controller.auth;

import org.mindrot.jbcrypt.BCrypt;
import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userParam = request.getParameter("username");
        String passParam = request.getParameter("password");

        User account = userDAO.checkLogin(userParam, passParam);

        if (account != null) {
            if (!account.isActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa bởi Ban Quản Trị!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", account);

            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
