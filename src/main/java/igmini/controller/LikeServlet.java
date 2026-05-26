package igmini.controller;

import igmini.dao.LikeDAO;
import igmini.dao.impl.LikeDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LikeServlet", value = "/like")
public class LikeServlet extends HttpServlet {
    private final LikeDAO likeDAO = new LikeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            String xhr = request.getHeader("X-Requested-With");
            if (xhr != null && "XMLHttpRequest".equals(xhr)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"error\":\"unauthorized\"}");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            int userId = user.getId();
            boolean isLikedNow;

            // 2. Nếu đã từng like rồi -> Thực hiện Unlike. Ngược lại -> Thực hiện Like.
            if (likeDAO.checkIfUserLiked(userId, postId)) {
                likeDAO.deleteLike(userId, postId);
                isLikedNow = false; // Trạng thái sau khi bấm là UNLIKE
            } else {
                likeDAO.insertLike(userId, postId);
                isLikedNow = true;  // Trạng thái sau khi bấm là LIKE
            }

            // 3. Trả về dữ liệu dạng JSON nếu là cuộc gọi AJAX ngầm từ giao diện
            String xhr = request.getHeader("X-Requested-With");
            if (xhr != null && "XMLHttpRequest".equals(xhr)) {
                int count = likeDAO.getLikeCount(postId);
                response.setContentType("application/json;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    // Dùng biến isLikedNow trực tiếp, không cần truy vấn lại DB
                    out.print("{\"liked\": " + isLikedNow + ", \"count\": " + count + "}");
                }
                return; // Kết thúc sớm luồng xử lý AJAX
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid post ID");
            return; // Đảm bảo thoát ra ngay lập tức để không chạy xuống sendRedirect phía dưới
        }

        // 4. Nếu là click trực tiếp không qua AJAX (Dùng làm phương án backup), quay về trang home
        response.sendRedirect("home");
    }
}