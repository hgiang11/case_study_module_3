<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, igmini.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kết quả tìm kiếm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .bg-black { background-color: #000 !important; }
    </style>
</head>
<body class="bg-light d-flex flex-column min-vh-100">

<nav class="bg-black text-white py-2 shadow-sm">
    <div class="container-fluid d-flex justify-content-between align-items-center px-4">

        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/home" class="text-white text-decoration-none fw-bold fs-4 d-flex align-items-center flex-shrink-0">
                <i class="bi bi-instagram me-2"></i>Mini Instagram
            </a>

            <div style="width: 250px; max-width: 100%;">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="w-100 m-0">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-dark border-0 text-secondary" style="border-top-left-radius: 8px; border-bottom-left-radius: 8px;">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="search" name="query" class="form-control bg-dark border-0 text-white text-xs shadow-none"
                               placeholder="Tìm kiếm..." aria-label="Search" required
                               style="border-top-right-radius: 8px; border-bottom-right-radius: 8px; font-size: 13px;">
                    </div>
                </form>
            </div>
        </div>

        <div class="d-flex align-items-center gap-4 flex-shrink-0">
            <a href="${pageContext.request.contextPath}/create-post" class="text-white text-decoration-none fw-bold" style="font-size: 14px;">
                <i class="bi bi-plus-lg me-1"></i> Đăng bài
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="text-white text-decoration-none fw-bold" style="font-size: 14px;">
                <i class="bi bi-box-arrow-right me-1"></i> Đăng xuất
            </a>
        </div>

    </div>
</nav>


<div class="container py-5 flex-grow-1" style="max-width: 600px;">
    <h4>Kết quả tìm kiếm cho: "${searchQuery}"</h4>
    <div class="card shadow-sm border-0 mt-3">
        <ul class="list-group list-group-flush">
            <%
                List<User> results = (List<User>) request.getAttribute("userResults");
                if (results != null && !results.isEmpty()) {
                    for (User u : results) {
            %>
            <li class="list-group-item d-flex align-items-center justify-content-between py-3">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/<%= u.getAvatarUrl() != null ? u.getAvatarUrl() : "assets/default-avatar.png" %>"
                         class="rounded-circle me-3" style="width: 50px; height: 50px; object-fit: cover;">
                    <div>
                        <h6 class="mb-0 fw-bold"><%= u.getUsername() %></h6>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/profile?userId=<%= u.getId() %>" class="btn btn-sm btn-outline-primary">Xem trang cá nhân</a>
            </li>
            <%
                }
            } else {
            %>
            <li class="list-group-item text-center py-4 text-muted">Không tìm thấy người dùng nào phù hợp.</li>
            <% } %>
        </ul>
    </div>
</div>

<footer class="bg-black text-white-50 border-top border-secondary text-xs" style="padding: 2px 0; height: 24px; line-height: 20px; margin-top: 40px;">
    <div class="container d-flex justify-content-between align-items-center" style="max-width: 935px; height: 100%;">
        <div style="opacity: 0.6; font-size: 11px; display: flex; align-items: center;">
            &copy; 2026 Mini Instagram. All rights reserved.
        </div>
        <div class="d-flex gap-3 text-white-50" style="opacity: 0.6; font-size: 11px; display: flex; align-items: center;">
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-facebook"></i></a>
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-twitter-x"></i></a>
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-instagram"></i></a>
        </div>
    </div>
</footer>

</body>
</html>