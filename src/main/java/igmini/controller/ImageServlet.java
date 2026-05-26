package igmini.controller;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // BUG FIX #1: Kiểm tra null cho pathInfo
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("File not found");
            return;
        }

        String fileName = pathInfo.substring(1);


        if (fileName.contains("..") || fileName.contains("//")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("Access denied");
            return;
        }


        String uploadPath = getServletContext().getRealPath("/uploads");
        if (uploadPath == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Server configuration error");
            return;
        }

        File file = new File(uploadPath, fileName);

        if (file.exists() && file.isFile()) {
            String contentType = getServletContext().getMimeType(file.getAbsolutePath());
            response.setContentType(contentType != null ? contentType : "application/octet-stream");
            response.setContentLength((int) file.length());
            response.setHeader("Cache-Control", "public, max-age=86400");

            try {

                Files.copy(file.toPath(), response.getOutputStream());
            } catch (IOException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error reading file");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("File not found");
        }
    }
}
