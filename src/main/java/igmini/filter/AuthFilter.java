package igmini.filter;

import igmini.dao.UserDAO;
import igmini.dao.impl.UserDAOImpl;
import igmini.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;



@WebFilter("/*")
public class AuthFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());

        boolean isLoginPage = path.equals("/login") || path.equals("/login.jsp");
        boolean isRegisterPage = path.equals("/register") || path.equals("/register.jsp");
        boolean isStaticResources = path.startsWith("/uploads/") || path.startsWith("/assets/") || path.startsWith("/css/");
        boolean loggedIn = (session != null && session.getAttribute("user") != null);



// Kiểm tra quyền ADMIN cho các đường dẫn /admin/
        if (path.startsWith("/admin/")) {
            if (!loggedIn) {
                res.sendRedirect(contextPath + "/login");
                return;
            }
            igmini.model.User currentUser = (igmini.model.User) session.getAttribute("user");
            if (!"ADMIN".equals(currentUser.getRole())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang quản trị!");
                return;
            }
        }





        if (loggedIn && session != null) {
            igmini.model.User checkedUser = (igmini.model.User) session.getAttribute("user");
            if (checkedUser != null) {
                UserDAO userDAOForFilter = new UserDAOImpl();
                User freshUserStatus = userDAOForFilter.getUserById(checkedUser.getId());

                if (freshUserStatus != null && !freshUserStatus.isActive()) {
                    // Xóa session để đăng xuất hoàn toàn tài khoản bị khóa
                    session.invalidate();

                    // Gửi thông báo lỗi về trang login
                    req.setAttribute("error", "Tài khoản của bạn đã bị khóa do vi phạm quy chuẩn cộng đồng!");
                    req.getRequestDispatcher("/login.jsp").forward(req, res);
                    return; // Chặn đứng tại đây, không cho phép đi tiếp vào các luồng code dưới
                }
            }
        }





        if (loggedIn || isLoginPage || isRegisterPage || isStaticResources) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(contextPath + "/login");
        }
    }



    @Override
    public void destroy() {}
}

