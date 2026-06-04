package igmini.controller.post; // Giang sửa lại tên package cho đúng với dự án của bạn nhé

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl; // Nhớ import lớp triển khai DAO bài viết của bạn
import igmini.model.Post;
import igmini.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/edit-post")
public class EditPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Khởi tạo đối tượng DAO để làm việc với Cơ sở dữ liệu bài viết
    private PostDAO postDAO = new PostDAOImpl();

    /**
     * 1. XỬ LÝ GET: Lấy dữ liệu bài viết cũ và hiển thị lên form sửa
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra bảo mật xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy mã id bài viết từ tham số Query trên URL (?id=...)
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int postId = Integer.parseInt(idStr);

                // 🔎 GỌI DAO: Tìm bài viết trong Database theo ID
                Post post = postDAO.getPostById(postId);

                if (post != null) {
                    // Kiểm tra bảo mật: Chỉ cho phép chính chủ sở hữu bài viết được sửa
                    if (post.getUser_id() == currentUser.getId()) {
                        // Đẩy đối tượng bài viết sang trang JSP để hứng dữ liệu vào form
                        request.setAttribute("post", post);
                        request.getRequestDispatcher("edit_post.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Nếu có lỗi, không tìm thấy bài hoặc không phải chính chủ, đá về trang profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    /**
     * 2. XỬ LÝ POST: Nhận dữ liệu Caption mới từ form và lưu xuống Database
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập UTF-8 để không bị lỗi font Tiếng Việt khi lưu Caption
        request.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy dữ liệu từ các thẻ input ẩn và textarea trong form edit_post.jsp
        String idStr = request.getParameter("id");
        String newCaption = request.getParameter("caption");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int postId = Integer.parseInt(idStr);

                // Thêm một bước kiểm tra bảo mật nhỏ ở Backend trước khi update
                Post post = postDAO.getPostById(postId);
                if (post != null && post.getUser_id() == currentUser.getId()) {

                    // 💾 GỌI DAO: Cập nhật nội dung Caption mới vào DB
                    post.setCaption(newCaption);
                    boolean success = postDAO.updatePost(post);

                    if (success) {
                        // Cập nhật thành công thì chuyển hướng quay lại trang profile luôn
                        response.sendRedirect(request.getContextPath() + "/profile");
                        return;
                    } else {
                        response.getWriter().println("Lỗi: Không thể cập nhật bài viết vào Database!");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Nếu có lỗi xảy ra, đưa người dùng quay lại trang chủ
        response.sendRedirect(request.getContextPath() + "/home");
    }
}