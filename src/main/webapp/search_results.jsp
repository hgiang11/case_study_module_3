<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, igmini.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kết quả tìm kiếm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5" style="max-width: 600px;">
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
</body>
</html>