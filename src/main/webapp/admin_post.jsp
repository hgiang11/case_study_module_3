<%@ page import="igmini.model.Post" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Quản lý bài viết</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .post-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
        .nav-tabs .nav-link { color: #495057; font-weight: 500; }
        .nav-tabs .nav-link.active { font-weight: bold; color: #dc3545 !important; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-3">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#"><i class="fas fa-user-shield text-warning me-2"></i>Admin Panel</a>
        <div class="navbar-nav ms-auto gap-3">
            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users me-1"></i> Quản lý Thành viên</a>
            <a class="nav-link text-white fw-bold" href="${pageContext.request.contextPath}/admin/posts"><i class="fas fa-images me-1"></i> Quản lý Bài viết</a>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/home"><i class="fas fa-home me-1"></i> Xem Bản Tin</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    <ul class="nav nav-tabs mb-4" id="adminPostTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active px-4 py-2" id="all-posts-tab" data-bs-toggle="tab" data-bs-target="#all-posts" type="button">
                <i class="fas fa-images me-2 text-primary"></i>Tất cả bài viết hệ thống
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link px-4 py-2 position-relative" id="reported-posts-tab" data-bs-toggle="tab" data-bs-target="#reported-posts" type="button">
                <i class="fas fa-exclamation-triangle me-2 text-danger"></i>Bài viết bị tố cáo (Report)
                <%
                    List<Post> reportedBadge = (List<Post>) request.getAttribute("reportedPosts");
                    if(reportedBadge != null && !reportedBadge.isEmpty()) {
                %>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.75rem;">
                        <%= reportedBadge.size() %>
                    </span>
                <% } %>
            </button>
        </li>
    </ul>

    <div class="tab-content" id="adminPostTabContent">

        <div class="tab-pane fade show active" id="all-posts" role="tabpanel">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4" style="width: 80px;">ID</th>
                            <th style="width: 120px;">Hình ảnh</th>
                            <th>Người đăng</th>
                            <th>Nội dung (Caption)</th>
                            <th>Ngày đăng</th>
                            <th class="text-end pe-4" style="width: 150px;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Post> allPosts = (List<Post>) request.getAttribute("allPosts");
                            if (allPosts != null && !allPosts.isEmpty()) {
                                for (Post p : allPosts) {
                        %>
                        <tr>
                            <td class="ps-4 fw-bold">#<%= p.getId() %></td>
                            <td>
                                <% if (p.getImage_url() != null && !p.getImage_url().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= p.getImage_url() %>" class="post-img shadow-sm">
                                <% } else { %>
                                <span class="text-muted small">Không có ảnh</span>
                                <% } %>
                            </td>
                            <td class="fw-bold text-primary">@<%= p.getUsername() %></td>
                            <td class="text-secondary" style="max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                <%= p.getCaption() != null ? p.getCaption() : "<i>Không có caption</i>" %>
                            </td>
                            <td class="text-muted small"><%= p.getCreated_at() %></td>
                            <td class="text-end pe-4">
                                <a href="${pageContext.request.contextPath}/admin/posts?action=delete&id=<%= p.getId() %>"
                                   class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                   onclick="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN bài viết này?')">
                                    <i class="fas fa-trash-alt me-1"></i> Xóa bài
                                </a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-center py-5 text-muted">Không có bài viết nào trên hệ thống.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="reported-posts" role="tabpanel">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-4" style="width: 80px;">ID</th>
                            <th style="width: 120px;">Hình ảnh</th>
                            <th>Người báo cáo</th>
                            <th>Chi tiết lý do tố cáo & Nội dung gốc</th>
                            <th>Ngày báo cáo</th>
                            <th class="text-end pe-4" style="width: 150px;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Post> reportedPosts = (List<Post>) request.getAttribute("reportedPosts");
                            if (reportedPosts != null && !reportedPosts.isEmpty()) {
                                for (Post p : reportedPosts) {
                        %>
                        <tr>
                            <td class="ps-4 fw-bold text-danger">#<%= p.getId() %></td>
                            <td>
                                <% if (p.getImage_url() != null && !p.getImage_url().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= p.getImage_url() %>" class="post-img shadow-sm">
                                <% } else { %>
                                <span class="text-muted small">Không có ảnh</span>
                                <% } %>
                            </td>
                            <td class="fw-bold text-danger"><i class="fas fa-user-tag me-1"></i><%= p.getUsername() %></td>
                            <td class="text-dark fw-medium" style="max-width: 400px;">
                                <%= p.getCaption() != null ? p.getCaption() : "<i>Không có nội dung</i>" %>
                            </td>
                            <td class="text-muted small"><%= p.getCreated_at() %></td>
                            <td class="text-end pe-4">
                                <a href="${pageContext.request.contextPath}/admin/posts?action=delete&id=<%= p.getId() %>"
                                   class="btn btn-sm btn-danger rounded-pill px-3"
                                   onclick="return confirm('Bạn có chắc chắn muốn GỠ VĨNH VIỄN bài viết vi phạm này khỏi hệ thống?')">
                                    <i class="fas fa-exclamation-triangle me-1"></i> Gỡ bài vi phạm
                                </a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted fst-italic">
                                <i class="fas fa-check-circle text-success fa-2x mb-2"></i><br>
                                Hiện tại hệ thống sạch bóng bài viết bị báo cáo vi phạm!
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>