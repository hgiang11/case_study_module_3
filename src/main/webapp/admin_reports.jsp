<%@ page import="igmini.model.Report" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang=\"vi\">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - Quản lý báo cáo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #fafafa; }
        .navbar-admin { background: #111; color: white; }
        .table-container { background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .post-preview { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-admin mb-4">
    <div class="container">
        <a class="navbar-brand text-white fw-bold" href="#"><i class="fas fa-user-shield me-2"></i>Admin Panel</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/users">Quản lý Thành viên</a>
            <a class="nav-link text-white fw-bold active" href="${pageContext.request.contextPath}/admin/reports">Quản lý Báo cáo</a>
            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/home">Xem Bản Tin</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="p-4 table-container">
        <h3 class="fw-bold text-dark mb-4"><i class="fas fa-flag text-danger me-2"></i> Danh sách báo cáo vi phạm</h3>

        <table class="table table-hover align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Người báo cáo</th>
                <th>Đối tượng bị tố cáo</th>
                <th>Lý do vi phạm</th>
                <th>Thời gian</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Report> reportList = (List<Report>) request.getAttribute("reportList");
                if (reportList != null && !reportList.isEmpty()) {
                    for (Report r : reportList) {
            %>
            <tr>
                <td>#<%= r.getId() %></td>
                <td><strong class="text-secondary">@<%= r.getReporter_name() %></strong></td>
                <td>
                    <% if (r.getPost_id() > 0) { %>
                    <div class="d-flex align-items-center gap-2">
                        <% if (r.getPost_image_url() != null) { %>
                        <img src="${pageContext.request.contextPath}/<%= r.getPost_image_url() %>" class="post-preview border">
                        <% } %>
                        <span class="text-muted text-truncate d-inline-block" style="max-width: 150px;"><%= r.getPost_caption() %></span>
                    </div>
                    <span class="badge bg-warning text-dark mt-1" style="font-size: 10px;">Bài viết</span>
                    <% } else if (r.getReportedUsername() != null) { %>
                    <span class="text-danger fw-bold"><i class="fas fa-user-slash me-1"></i> @<%= r.getReportedUsername() %></span>
                    <br><span class="badge bg-danger mt-1" style="font-size: 10px;">Tài khoản</span>
                    <% } %>
                </td>
                <td><span class="text-dark fw-semibold"><%= r.getReason() %></span></td>
                <td class="small text-muted"><%= r.getCreated_at() %></td>
                <td>
                    <div class="d-flex gap-2">
                        <% if (r.getPost_id() > 0) { %>
                        <a href="${pageContext.request.contextPath}/delete-post?id=<%= r.getPost_id() %>"
                           class="btn btn-sm btn-outline-danger"
                           onclick="return confirm('Bạn có chắc muốn xóa bài viết vi phạm này không?')">
                            <i class="fas fa-trash"></i> Xóa Bài
                        </a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-user-cog"></i> Xử lý User
                        </a>
                        <% } %>

                        <a href="${pageContext.request.contextPath}/admin/delete-report?id=<%= r.getId() %>"
                           class="btn btn-sm btn-light text-muted border"
                           onclick="return confirm('Bác bỏ báo cáo này?')">
                            Bỏ qua
                        </a>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" class="text-center text-muted py-4">Hệ thống hiện tại chưa ghi nhận báo cáo vi phạm nào.</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>