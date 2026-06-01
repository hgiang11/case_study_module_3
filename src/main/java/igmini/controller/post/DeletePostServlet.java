package igmini.controller;

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/delete-post")
public class DeletePostServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("===> BUG: User chua dang nhap hoac Session bi mat!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy ID bài viết từ URL
        String idParam = request.getParameter("id");
        System.out.println("===> Servlet nhan duoc yeu cau xoa bai viet ID = " + idParam);

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int postId = Integer.parseInt(idParam);

                // Kiểm tra bài viết
                Post post = postDAO.getPostById(postId);

                if (post == null) {
                    // 🚨 ĐÂY CHÍNH LÀ NƠI PHÁT HIỆN RA BUG HÀM GETPOSTBYID:
                    System.err.println("===> BUG: Ham getPostById(" + postId + ") tra ve NULL! Kiem tra lai SQL cua ham nay.");
                    // Tạm thời bỏ qua check quyền để TEST xem hàm xóa có chạy được không:
                    System.out.println("===> Dang chay cuong che xoa bai viet...");
                    boolean success = postDAO.deletePost(postId);
                    System.out.println("===> Ket qua xoa cuong che: " + success);
                } else {
                    System.out.println("===> Tim thay bai viet! Owner ID trong DB: " + post.getUser_id() + " | Current User ID: " + currentUser.getId());

                    if (post.getUser_id() != currentUser.getId()) {
                        System.err.println("===> BUG: Khong trung khop ID chu so huu!");
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa bài viết này!");
                        return;
                    }

                    // Thực hiện xóa vĩnh viễn
                    boolean success = postDAO.deletePost(postId);
                    System.out.println("===> Ket qua chay ham deletePost: " + success);
                }

            } catch (NumberFormatException e) {
                System.err.println("===> Lỗi dinh dang ID: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.err.println("===> BUG: Tham so id tren URL bi thieu hoac rong!");
        }

        // Quay về trang Profile để xem kết quả
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}