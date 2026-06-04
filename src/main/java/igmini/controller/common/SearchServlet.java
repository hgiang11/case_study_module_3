package igmini.controller.common;


import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        String query = request.getParameter("query");
        if (query != null && !query.trim().isEmpty()) {
            UserDAO userDAO = new UserDAOImpl();
            List<User> resultList = userDAO.searchUsers(query.trim(), currentUser.getId());

            request.setAttribute("userResults", resultList);
            request.setAttribute("searchQuery", query);
        }

        request.getRequestDispatcher("search_results.jsp").forward(request, response);
    }
}