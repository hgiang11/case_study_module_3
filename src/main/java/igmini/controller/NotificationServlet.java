package igmini.controller;

import igmini.dao.NotificationDAO;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.model.User;
import igmini.model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notiDAO = new NotificationDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy toàn bộ thông báo ra
        List<Notification> notiList = notiDAO.getNotificationsByUserId(currentUser.getId());
        request.setAttribute("notiList", notiList);

        // Xem xong thì tự động đánh dấu tất cả là đã đọc
        notiDAO.markAsRead(currentUser.getId());

        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}