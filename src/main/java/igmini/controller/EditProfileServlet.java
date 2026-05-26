package igmini.controller;

import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/edit-profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra trạng thái đăng nhập bảo mật
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Chuyển tiếp (Forward) sang trang giao diện jsp để hiển thị form sửa
        request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Lấy thông tin từ form
        String newUsername = request.getParameter("username");
        String newEmail = request.getParameter("email");

        // 2. Xử lý file ảnh Avatar
        Part filePart = request.getPart("avatar");
        String fileName = filePart.getSubmittedFileName();
        String avatarPath = currentUser.getAvatarUrl();

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/uploads") ;
            System.out.println(uploadPath); // check
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String cleanFileName =
                    fileName.replaceAll("\\s+", "_");

            String uniqueFileName =
                    System.currentTimeMillis() + "_" + cleanFileName;
            System.out.println(uploadPath);
            System.out.println(uniqueFileName);
            filePart.write(uploadPath + File.separator + uniqueFileName);
            File savedFile =
                    new File(uploadPath, uniqueFileName);

            System.out.println(savedFile.exists());
            avatarPath = "uploads/" + uniqueFileName;
        }

        // 3. Cập nhật đối tượng User
        currentUser.setUsername(newUsername);
        currentUser.setEmail(newEmail);
        currentUser.setAvatarUrl(avatarPath);

        // 4. Lưu vào Database
        if (userDAO.updateUser(currentUser)) {
            // Cập nhật lại session để giao diện đổi ngay lập tức
            session.setAttribute("user", currentUser);
            response.sendRedirect("profile");
        } else {
            response.getWriter().println("Lỗi cập nhật Profile!");
        }
    }
}