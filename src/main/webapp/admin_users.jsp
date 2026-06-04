<%@ page import="igmini.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Quản lý tài khoản</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .table-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-3">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#"><i class="fas fa-user-shield text-warning me-2"></i>Admin Panel</a>
        <div class="navbar-nav ms-auto gap-3">
            <a class="nav-link text-white fw-bold" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users me-1"></i> Quản lý Thành viên</a>
            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/posts"><i class="fas fa-images me-1"></i> Quản lý Bài viết</a>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/home"><i class="fas fa-home me-1"></i> Xem Bản Tin</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    <div class="card shadow border-0 rounded-3">
        <div class="card-header bg-white py-4 px-4 border-bottom">
            <h4 class="fw-bold mb-0 text-dark"><i class="fas fa-users text-primary me-2"></i>Danh sách tài khoản hệ thống</h4>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-4" style="width: 80px;">ID</th>
                    <th>Người dùng</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th class="text-end pe-4" style="width: 280px;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                    User admin = (User) session.getAttribute("user");
                    if (allUsers != null && !allUsers.isEmpty()) {
                        for (User u : allUsers) {
                %>
                <tr>
                    <td class="ps-4 fw-bold">#<%= u.getId() %></td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <img src="${pageContext.request.contextPath}/<%= (u.getAvatarUrl() != null && !u.getAvatarUrl().isEmpty()) ? u.getAvatarUrl() : "uploads/default-avatar.png" %>" class="table-avatar">
                            <span class="fw-bold">@<%= u.getUsername() %></span>
                        </div>
                    </td>
                    <td><%= (u.getEmail() != null) ? u.getEmail() : "Chưa cập nhật" %></td>
                    <td>
                                    <span class="badge <%= "ADMIN".equals(u.getRole()) ? "bg-danger" : "bg-info text-dark" %>">
                                        <%= u.getRole() %>
                                    </span>
                    </td>
                    <td>
                                    <span class="badge <%= u.isActive() ? "bg-success" : "bg-secondary" %>">
                                        <%= u.isActive() ? "Đang hoạt động" : "Đã khóa" %>
                                    </span>
                    </td>
                    <td class="text-end pe-4">
                        <% if (admin != null && u.getId() != admin.getId()) { %>
                        <a href="${pageContext.request.contextPath}/admin/users?action=changeRole&id=<%= u.getId() %>&role=<%= u.getRole() %>"
                           class="btn btn-sm btn-outline-warning rounded-pill px-3 me-2"
                           onclick="return confirm('Thay đổi quyền tài khoản này?')">
                            <i class="fas fa-exchange-alt me-1"></i> Đổi Quyền
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=<%= u.getId() %>&status=<%= u.isActive() %>"
                           class="btn btn-sm <%= u.isActive() ? "btn-outline-danger" : "btn-outline-success" %> rounded-pill px-3"
                           onclick="return confirm('<%= u.isActive() ? "Bạn có chắc muốn KHÓA?" : "Bạn muốn MỞ KHÓA?" %>')">
                            <i class="fas <%= u.isActive() ? "fa-user-slash" : "fa-user-check" %> me-1"></i>
                            <%= u.isActive() ? "Khóa" : "Mở khóa" %>
                        </a>
                        <% } else { %>
                        <span class="text-muted small fst-italic">Tài khoản của bạn</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>