package igmini.controller;

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "CreatePostServlet", value = "/create-post")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CreatePostServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển tiếp người dùng đến trang điền form đăng bài
        request.getRequestDispatcher("create_post.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Lấy thông tin file
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() <= 0) {
                response.getWriter().println("Vui lòng chọn một hình ảnh!");
                return;
            }

            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 2. Ghi file vật lý xuống thư mục uploads
            filePart.write(uploadPath + File.separator + fileName);
            // 3. Chuẩn bị đối tượng Post để lưu vào DB
            String caption = request.getParameter("caption");
            Post post = new Post();
            post.setUserId(user.getId());
            post.setCaption(caption);

            // Lưu đường dẫn đầy đủ: uploads/12345_filename.jpg
            post.setImageUrl("uploads/" + fileName);


            PostDAO postDAO = new PostDAOImpl();
            boolean isSuccess = postDAO.createPost(post);
            if (isSuccess) {
                response.sendRedirect("profile");
            } else {
                response.getWriter().println("Lỗi: Không thể lưu bài viết vào cơ sở dữ liệu.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }
}