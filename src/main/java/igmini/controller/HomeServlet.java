package igmini.controller;

import igmini.dao.PostDAO;
import igmini.dao.impl.PostDAOImpl;
import igmini.model.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy danh sách bài viết từ DAO

        List<Post> listPostas = postDAO.getAllPosts();

        // 2. Đẩy danh sách này vào "chiếc xe tải" request để chở sang JSP
        request.setAttribute("postList", listPostas);

        // 3. Chuyển hướng sang trang index.jsp để hiển thị
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}