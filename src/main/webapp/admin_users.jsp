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
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 🖤 Navbar gọn gàng trên cùng */
        .navbar-admin {
            background-color: #1e1e2d !important;
            border-bottom: 1px solid #2b2b40;
            z-index: 1030;
        }

        /* 📐 Bố cục chia hai cột: Sidebar bên trái & Content bên phải */
        .admin-wrapper {
            display: flex;
            flex: 1;
            position: relative;
        }

        /* 📑 Sidebar cố định bên trái */
        .admin-sidebar {
            width: 260px;
            background-color: #1e1e2d;
            color: #a2a3b7;
            min-height: calc(100vh - 70px);
            flex-shrink: 0;
            border-right: 1px solid #2b2b40;
            padding-top: 20px;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-item a {
            display: flex;
            align-items: center;
            padding: 14px 24px;
            color: #a2a3b7;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            font-size: 15px;
        }

        .sidebar-item a i {
            width: 24px;
            font-size: 16px;
            margin-right: 12px;
        }

        /* Trạng thái khi di chuột vào menu */
        .sidebar-item a:hover {
            color: #ffffff;
            background-color: #1b1b28;
        }

        /* Mục đang được chọn (Active) */
        .sidebar-item.active a {
            color: #ffffff;
            background-color: #0095f6; /* Màu xanh thương hiệu nổi bật */
            font-weight: 600;
        }

        /* 📊 Vùng nội dung chính bên phải */
        .admin-content {
            flex: 1;
            padding: 30px;
            background-color: #f8f9fa;
        }

        .table-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #dee2e6;
        }

        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-admin py-3">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-5" href="#">
            <i class="fas fa-user-shield text-warning me-2"></i>Admin Panel
        </a>
        <div class="ms-auto">
            <a class="btn btn-sm btn-outline-light rounded-pill px-3 fw-bold" href="${pageContext.request.contextPath}/home">
                <i class="fas fa-home me-1"></i> Xem Bản Tin
            </a>
        </div>
    </div>
</nav>

<div class="admin-wrapper">

    <aside class="admin-sidebar">
        <ul class="sidebar-menu">
            <li class="sidebar-item active">
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i>
                    <span>Quản lý Thành viên</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts">
                    <i class="fas fa-images"></i>
                    <span>Quản lý Bài viết</span>
                </a>
            </li>
        </ul>
    </aside>

    <main class="admin-content">
        <div class="card card-custom">
            <div class="card-header bg-white py-4 px-4 border-bottom">
                <h4 class="fw-bold mb-0 text-dark">
                    <i class="fas fa-users text-primary me-2"></i>Danh sách tài khoản hệ thống
                </h4>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
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
                            <td class="text-end pe-4">
                                <% if (admin != null && u.getId() != admin.getId()) { %>
                            <a href="${pageContext.request.contextPath}/admin-edit-user?id=<%= u.getId() %>"
                               class="btn btn-sm btn-outline-warning rounded-pill px-3 me-1">
                                Sửa thông tin
                            </a>


                                <% if (!"ADMIN".equalsIgnoreCase(u.getRole())) { %>
                                <a href="${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=<%= u.getId() %>&status=<%= u.isActive() %>"
                                   class="btn btn-sm <%= u.isActive() ? "btn-outline-danger" : "btn-outline-success" %> rounded-pill px-3"
                                   onclick="return confirm('<%= u.isActive() ? "Bạn có chắc muốn KHÓA?" : "Bạn muốn MỞ KHÓA?" %>')">
                                    <i class="fas <%= u.isActive() ? "fa-user-slash" : "fa-user-check" %> me-1"></i>
                                    <%= u.isActive() ? "Khóa" : "Mở khóa" %>
                                </a>
                                <% } else { %>
                                <span class="text-muted small fst-italic">Không thể khóa</span>
                                <% } %>

                                <% } else { %>
                                <span class="text-muted small fst-italic">Tài khoản của bạn</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" class="text-center p-4 text-muted">Không có tài khoản nào được tìm thấy.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>