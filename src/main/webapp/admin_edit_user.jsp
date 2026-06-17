<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="igmini.model.User" %>
<html>
<head>
    <title>Admin Panel - Chỉnh Sửa Thành Viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .edit-profile-container { max-width: 600px; margin: 50px auto; }
        .custom-card { background: #fff; border-radius: 16px; border: none; }
        .avatar-circle { width: 100px; height: 100px; border-radius: 50%; background: #eaeaea; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #aaa; margin: 0 auto 15px; overflow: hidden; border: 3px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<div class="container edit-profile-container">
    <div class="card custom-card p-4 shadow-lg">

        <div class="text-center mb-4">
            <h2 class="fw-bold mb-2" style="font-size: 26px;">
                <i class="fas fa-user-cog text-primary me-2"></i>Quản Trị Viên Sửa User
            </h2>
            <p class="text-muted" style="font-size: 14px;">Thay đổi thông tin hệ thống hoặc cấp lại mật khẩu cho thành viên</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger border-0 text-center py-2 mb-3" style="border-radius: 8px; font-size: 14px;">
            <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <%
            User editUser = (User) request.getAttribute("editUser");
            if (editUser != null) {
        %>
        <form action="${pageContext.request.contextPath}/admin-edit-user" method="POST">
            <input type="hidden" name="id" value="<%= editUser.getId() %>">

            <div class="text-center mb-4">
                <div class="avatar-circle">
                    <% if (editUser.getAvatarUrl() != null && !editUser.getAvatarUrl().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= editUser.getAvatarUrl() %>" style="width: 100%; height: 100%; object-fit: cover;">
                    <% } else { %>
                    <i class="fas fa-user"></i>
                    <% } %>
                </div>
                <span class="badge bg-secondary">Mã tài khoản: #<%= editUser.getId() %></span>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold"><i class="fas fa-user-tag me-1"></i> Tên tài khoản (Username)</label>
                <input type="text" name="username" class="form-control" value="<%= editUser.getUsername() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold"><i class="fas fa-envelope me-1"></i> Địa chỉ Email</label>
                <input type="email" name="email" class="form-control" value="<%= editUser.getEmail() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold"><i class="fas fa-shield-alt me-1"></i> Quyền hạn hệ thống</label>
                <select name="role" class="form-select">
                    <option value="USER" <%= "USER".equalsIgnoreCase(editUser.getRole()) ? "selected" : "" %>>USER</option>
                    <option value="ADMIN" <%= "ADMIN".equalsIgnoreCase(editUser.getRole()) ? "selected" : "" %>>ADMIN</option>
                </select>
            </div>

            <div class="mb-4 form-check form-switch p-3 bg-light rounded" style="padding-left: 3.5em !important;">
                <input class="form-check-input" type="checkbox" name="isActive" id="isActive" value="true" <%= editUser.isActive() ? "checked" : "" %>>
                <label class="form-check-label fw-bold text-dark" for="isActive">Trạng thái: Cho phép hoạt động</label>
            </div>

            <div class="mb-4 border border-warning p-3 rounded bg-warning-subtle" style="background-color: #fffbeb;">
                <label class="form-label fw-bold text-warning-emphasis"><i class="fas fa-key me-1"></i> Đặt lại mật khẩu mới (Nếu user quên)</label>
                <input type="password" name="newPassword" class="form-control bg-white" placeholder="Để trống nếu giữ nguyên mật khẩu cũ">
                <div class="form-text text-muted" style="font-size: 12px;">Khi gõ vào đây, hệ thống Backend sẽ tự mã hóa BCrypt đè vào DB.</div>
            </div>

            <div class="d-grid gap-2 mb-3">
                <button type="submit" class="btn btn-primary fw-bold">
                    <i class="fas fa-save me-2"></i> Lưu Thay Đổi
                </button>
            </div>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-link text-secondary text-decoration-none">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>
        </form>
        <% } else { %>
        <div class="alert alert-danger text-center">Không tìm thấy dữ liệu tài khoản này!</div>
        <% } %>
    </div>
</div>

</body>
</html>