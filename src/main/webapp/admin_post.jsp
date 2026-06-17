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
        body { background-color: #f8f9fa; margin: 0; padding-top: 70px; }

        /* Thanh Top Navbar màu đen */
        .top-navbar {
            height: 70px;
            background-color: #1a1d24;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
        }
        .navbar-brand-custom {
            color: #ffffff;
            font-size: 1.35rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        .btn-view-news {
            background-color: #2c313c;
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .btn-view-news:hover {
            background-color: #3d4454;
            color: #ffffff;
        }

        /* Thanh Sidebar dọc phía dưới */
        .sidebar {
            width: 260px;
            position: fixed;
            top: 70px;
            left: 0;
            bottom: 0;
            background-color: #1e222b;
            z-index: 1020;
            padding-top: 15px;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.65);
            padding: 14px 24px;
            font-weight: 500;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            text-decoration: none;
            transition: all 0.2s;
        }
        .sidebar .nav-link i {
            font-size: 1.1rem;
            width: 28px;
        }
        /* Active mục Quản lý bài viết - Đồng bộ hiệu ứng màu trong ảnh */
        .sidebar .nav-link.active-menu {
            background-color: #0095f6 !important; /* Xanh dương sáng giống ảnh mẫu */
            color: #ffffff !important;
        }
        .sidebar .nav-link:hover:not(.active-menu) {
            background-color: rgba(255, 255, 255, 0.05);
            color: #ffffff;
        }

        /* Vùng nội dung chính bên phải */
        .main-content {
            margin-left: 260px;
            padding: 40px;
        }

        /* Định dạng Table & Tabs nội dung */
        .post-img { width: 55px; height: 55px; object-fit: cover; border-radius: 6px; }
        .nav-tabs { border-bottom: 2px solid #dee2e6; }
        .nav-tabs .nav-link {
            color: #495057;
            font-weight: 600;
            border: none;
            padding: 10px 20px;
        }
        .nav-tabs .nav-link.active {
            color: #dc3545 !important;
            border-bottom: 3px solid #dc3545;
            background: none;
        }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .badge-count { font-size: 0.75rem; padding: 4px 7px; margin-left: 5px; }

        @media (max-width: 992px) {
            .sidebar { width: 70px; }
            .sidebar span { display: none; }
            .main-content { margin-left: 70px; padding: 20px; }
            .sidebar .nav-link { justify-content: center; padding: 15px 0; }
            .sidebar .nav-link i { width: auto; margin: 0; }
        }
    </style>
</head>



<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
<script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
<script>
    // Đọc flash message được đặt trong session bởi servlet
    // (giá trị sẽ được in ra dưới dạng một biến JavaScript)
    <%
        String flash = igmini.util.FlashMessage.get(request.getSession());
        if (flash != null) {
    %>
    // Hiển thị toast một lần
    Toastify({
        text: "<%= flash.replace("\"", "\\\"") %>",
        duration: 5000,          // 5 giây
        gravity: "top",          // top / bottom
        position: "right",       // left / center / right
        backgroundColor: "#4a90e2",
        stopOnFocus: true,
    }).showToast();
    <% } %>
</script>
<body>

<div class="top-navbar">
    <a class="navbar-brand-custom" href="#">
        <i class="fas fa-user-shield text-warning me-2"></i>
        <span>Admin Panel</span>
    </a>
    <a class="btn-view-news" href="${pageContext.request.contextPath}/home">
        <i class="fas fa-home me-1"></i> Xem Bản Tin
    </a>
</div>

<div class="sidebar">
    <nav class="nav flex-column">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
            <i class="fas fa-users"></i> <span>Quản lý Thành viên</span>
        </a>
        <a class="nav-link active-menu" href="${pageContext.request.contextPath}/admin/posts">
            <i class="fas fa-images"></i> <span>Quản lý Bài viết</span>
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="container-fluid">

        <h2 class="fw-bold mb-4 text-dark">Quản lý bài viết</h2>

        <ul class="nav nav-tabs mb-4" id="adminPostTab" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="all-posts-tab" data-bs-toggle="tab" data-bs-target="#all-posts" type="button">
                    <i class="fas fa-list me-2"></i>Tất cả bài viết hệ thống
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link position-relative" id="reported-posts-tab" data-bs-toggle="tab" data-bs-target="#reported-posts" type="button">
                    <i class="fas fa-exclamation-circle me-2"></i>Bài viết bị tố cáo (Report)
                    <%
                        List<Post> reportedBadge = (List<Post>) request.getAttribute("reportedPosts");
                        if(reportedBadge != null && !reportedBadge.isEmpty()) {
                    %>
                    <span class="badge rounded-pill bg-danger badge-count">
                        <%= reportedBadge.size() %>
                    </span>
                    <% } %>
                </button>
            </li>
        </ul>

        <div class="tab-content" id="adminPostTabContent">
            <div class="tab-pane fade show active" id="all-posts" role="tabpanel">
                <div class="card">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 90px;">ID</th>
                                <th style="width: 120px;">Hình ảnh</th>
                                <th>Người đăng</th>
                                <th>Nội dung (Caption)</th>
                                <th>Ngày đăng</th>
                                <th class="text-end pe-4" style="width: 160px;">Hành động</th>
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
                                    <img src="${pageContext.request.contextPath}/<%= p.getImage_url() %>" class="post-img border shadow-sm">
                                    <% } else { %>
                                    <span class="text-muted small">Không có ảnh</span>
                                    <% } %>
                                </td>
                                <td class="text-primary fw-bold">@<%= p.getUsername() %></td>
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
                <div class="card">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 90px;">ID</th>
                                <th style="width: 120px;">Hình ảnh</th>
                                <th>Người báo cáo</th>
                                <th>Nội dung vi phạm</th>
                                <th>Ngày báo cáo</th>
                                <th class="text-end pe-4" style="width: 160px;">Hành động</th>
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
                                    <img src="${pageContext.request.contextPath}/<%= p.getImage_url() %>" class="post-img border border-danger shadow-sm">
                                    <% } else { %>
                                    <span class="text-muted small">Không có ảnh</span>
                                    <% } %>
                                </td>
                                <td class="fw-bold text-danger"><i class="fas fa-user-tag me-1"></i><%= p.getUsername() %></td>
                                <td class="text-dark fw-medium" style="max-width: 350px;">
                                    <%= p.getCaption() != null ? p.getCaption() : "<i>Không có nội dung</i>" %>
                                </td>
                                <td class="text-muted small"><%= p.getCreated_at() %></td>
                                <td class="text-end pe-4">
                                    <a href="${pageContext.request.contextPath}/admin/check-report?id=<%= p.getId() %>"
                                       class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                        <i class="fas fa-search me-1"></i> Kiểm tra
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>