package igmini.controller.interaction;

import igmini.dao.CommentDAO;
import igmini.dao.impl.CommentDAOImpl;
import igmini.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/comment-delete")
public class CommentDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra trạng thái đăng nhập
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        try {
            String commentIdStr = request.getParameter("comment_id");

            // 2. Kiểm tra dữ liệu đầu vào
            if (commentIdStr == null || commentIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"error\":\"Missing comment_id\"}");
                return;
            }

            int commentId = Integer.parseInt(commentIdStr);
            CommentDAO commentDAO = new CommentDAOImpl();

            // 3. Xóa comment (chỉ chủ sở hữu comment mới có quyền xóa)
            boolean success = commentDAO.deleteComment(commentId);

            // 4. Thiết lập kiểu dữ liệu trả về là JSON
            response.setContentType("application/json; charset=UTF-8");

            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"Invalid commentId\"}");
        }
    }
}

