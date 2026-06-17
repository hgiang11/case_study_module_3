<%@ page import="igmini.model.Report" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - Kiểm duyệt báo cáo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; margin: 0; padding-top: 70px; }
        .top-navbar { height: 70px; background-color: #1a1d24; position: fixed; top: 0; left: 0; right: 0; z-index: 1030; display: flex; align-items: center; justify-content: space-between; padding: 0 24px; }
        .navbar-brand-custom { color: #ffffff; font-size: 1.35rem; font-weight: 700; text-decoration: none; display: flex; align-items: center; }
        .btn-view-news { background-color: #2c313c; color: #ffffff; border: 1px solid rgba(255,255,255,0.1); padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 0.95rem; }
        .sidebar { width: 260px; position: fixed; top: 70px; left: 0; bottom: 0; background-color: #1e222b; z-index: 1020; padding-top: 15px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.65); padding: 14px 24px; font-weight: 500; display: flex; align-items: center; text-decoration: none; }
        .sidebar .nav-link.active-menu { background-color: #0095f6 !important; color: #ffffff !important; }
        .main-content { margin-left: 260px; padding: 40px; }
        .preview-img { max-width: 100%; max-height: 400px; object-fit: contain; border-radius: 8px; }
    </style>
</head>
<body>

<div class="top-navbar">
    <a class="navbar-brand-custom" href="#">
        <i class="fas fa-user-shield text-warning me-2"></i><span>Admin Panel</span>
    </a>
    <a class="btn-view-news" href="${pageContext.request.contextPath}/home"><i class="fas fa-home me-1"></i> Xem Bản Tin</a>
</div>

<div class="sidebar">
    <nav class="nav flex-column">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users me-2"></i> Quản lý Thành viên</a>
        <a class="nav-link active-menu" href="${pageContext.request.contextPath}/admin/posts"><i class="fas fa-images me-2"></i> Quản lý Bài viết</a>
    </nav>
</div>

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex align-items-center mb-4">
            <a href="${pageContext.request.contextPath}/admin/posts" class="btn btn-outline-secondary me-3 rounded-circle"><i class="fas fa-arrow-left"></i></a>
            <h2 class="fw-bold m-0">Chi tiết đơn thư tố cáo</h2>
        </div>

        <%
            Report detail = (Report) request.getAttribute("reportDetail");
            if (detail != null) {
        %>
        <div class="row">
            <div class="col-md-5 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-danger text-white fw-bold py-3">
                        <i class="fas fa-info-circle me-2"></i>Thông tin phiếu phạt
                    </div>
                    <div class="card-body fs-6">
                        <p><strong>Mã đơn tố cáo:</strong> #<%= detail.getId() %></p>
                        <p><strong>Người gửi báo cáo:</strong> <span class="text-danger fw-bold">@<%= detail.getReporter_name() %></span> (ID: <%= detail.getReporter_id() %>)</p>
                        <p><strong>Ngày gửi đơn:</strong> <%= detail.getCreated_at() %></p>
                        <hr>
                        <p class="text-muted fw-bold">Lý do khiếu nại vi phạm:</p>
                        <div class="p-3 bg-light border-start border-danger border-4 rounded text-danger fw-medium italic">
                            "<%= detail.getReason() %>"
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-dark text-white fw-bold py-3">
                        <i class="fas fa-file-alt me-2"></i>Bài viết gốc trên hệ thống (Để đối chiếu)
                    </div>
                    <div class="card-body text-center bg-light d-flex flex-column justify-content-center align-items-center p-4">
                        <% if (detail.getPost_image_url() != null && !detail.getPost_image_url().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= detail.getPost_image_url() %>" class="preview-img shadow border mb-3">
                        <% } else { %>
                        <div class="p-5 text-muted bg-white border rounded mb-3 w-100">Bài viết này không đính kèm hình ảnh</div>
                        <% } %>

                        <div class="text-start w-100 bg-white p-3 rounded border">
                            <h6 class="fw-bold text-primary">Nội dung Caption bài viết:</h6>
                            <p class="m-0 text-secondary"><%= detail.getPost_caption() != null ? detail.getPost_caption() : "<i>Không có nội dung chữ</i>" %></p>
                        </div>
                    </div>

                    <div class="card-footer bg-white py-3 d-flex justify-content-end gap-3">
                        <a href="${pageContext.request.contextPath}/admin/posts?action=rejectReport&reportId=<%= detail.getId() %>"
                           class="btn btn-outline-secondary px-4 rounded-pill"
                           onclick="return confirm('Xác nhận báo cáo này SAI SỰ THẬT? Hệ thống sẽ hủy đơn tố cáo này.')">
                            <i class="fas fa-times-circle me-1"></i> Bác bỏ đơn (Báo cáo sai)
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/posts?action=delete&id=<%= detail.getPost_id() %>"
                           class="btn btn-danger px-4 rounded-pill"
                           onclick="return confirm('Bài viết thực sự vi phạm. Xác nhận xóa vĩnh viễn bài đăng này?')">
                            <i class="fas fa-gavel me-1"></i> Cưỡng chế xóa bài
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-warning">Không tìm thấy thông tin chi tiết của báo cáo này hoặc dữ liệu đã bị thay đổi.</div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>