package igmini.controller;

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
        // 1. Kiểm tra đăng nhập TRƯỚC TIÊN
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Nếu đã đăng nhập thành công, mới bắt đầu đi lấy dữ liệu bài viết từ DB
        List<Post> listPostas = postDAO.getAllPosts();
        // Đẩy danh sách này vào "chiếc xe tải" request để chở sang JSP
        request.setAttribute("postList", listPostas);

        // --- BẮT ĐẦU ĐOẠN TÍCH HỢP: LẤY DỮ LIỆU THÔNG BÁO CHO TRANG HOME ---
        try {
            NotificationDAO notiDAO = new NotificationDAOImpl();

            // Lấy toàn bộ danh sách thông báo của User hiện tại để hiển thị ở Dropdown quả chuông
            List<Notification> homeNotiList = notiDAO.getNotificationsByUserId(currentUser.getId());
            request.setAttribute("homeNotiList", homeNotiList);

            // Đếm xem có bao nhiêu thông báo CHƯA ĐỌC (isRead == false) để hiển thị Badge số đỏ
            long unreadCount = 0;
            if (homeNotiList != null) {
                unreadCount = homeNotiList.stream().filter(n -> !n.isRead()).count();
            }
            request.setAttribute("unreadCount", unreadCount);

        } catch (Exception e) {
            System.out.println("Lỗi khi nạp dữ liệu thông báo lên trang Home: " + e.getMessage());
            e.printStackTrace();
        }
        // --- KẾT THÚC ĐOẠN TÍCH HỢP ---

        // 4. Chuyển tiếp sang trang home.jsp (Giữ nguyên định tuyến tuyệt đối của bạn)
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}