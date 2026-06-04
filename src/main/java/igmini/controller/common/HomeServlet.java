package igmini.controller.common;

import igmini.dao.PostDAO;
import igmini.dao.NotificationDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.dao.impl.NotificationDAOImpl;
import igmini.model.Post;
import igmini.model.Notification;
import igmini.model.User;            
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Post> listPostas = postDAO.getAllPosts();
        request.setAttribute("postList", listPostas);

        try {
            NotificationDAO notiDAO = new NotificationDAOImpl();

            List<Notification> homeNotiList = notiDAO.getNotificationsByUserId(currentUser.getId());
            request.setAttribute("homeNotiList", homeNotiList);

            long unreadCount = 0;
            if (homeNotiList != null) {
                unreadCount = homeNotiList.stream().filter(n -> !n.isRead()).count();
            }
            request.setAttribute("unreadCount", unreadCount);

        } catch (Exception e) {
            System.out.println("Lỗi khi nạp dữ liệu thông báo lên trang Home: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}