package igmini.filter;

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

        if (loggedIn || isLoginPage || isRegisterPage || isStaticResources) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {}
}
