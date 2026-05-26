package igmini.controller;

import igmini.dao.CommentDAO;
import igmini.dao.impl.CommentDAOImpl;
import igmini.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        try {
            String postIdStr = request.getParameter("post_id_comment");
            String content = request.getParameter("content");

            if (postIdStr == null || postIdStr.isEmpty() || content == null || content.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing data\"}");
                return;
            }

            int post_id_comment = Integer.parseInt(postIdStr);
            content = content.trim();

            CommentDAO commentDAO = new CommentDAOImpl();
            boolean success = commentDAO.insertComment(user.getId(), post_id_comment, content);


            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid postId\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Server error\"}");
            e.printStackTrace();
        }
    }
}