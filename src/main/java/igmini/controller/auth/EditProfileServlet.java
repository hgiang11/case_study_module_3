package igmini.controller.auth;

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

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newUsername = request.getParameter("username");
        String newEmail = request.getParameter("email");

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

        currentUser.setUsername(newUsername);
        currentUser.setEmail(newEmail);
        currentUser.setAvatarUrl(avatarPath);

        if (userDAO.updateUser(currentUser)) {
            // Cập nhật lại session để giao diện đổi ngay lập tức
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            response.getWriter().println("Lỗi cập nhật Profile!");
        }
    }
}