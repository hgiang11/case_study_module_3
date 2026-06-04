<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="igmini.model.Post" %>
<html>
<head>
    <title>Chỉnh Sửa Bài Viết - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa; /* Nền ngoài màu trắng xám nhẹ giống hệt trang Home */
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: #212529;
        }

        /* Ép cứng thanh Navbar màu đen tuyền sang xịn như trang Profile của bạn */
        .navbar-custom {
            background-color: #000000 !important;
            border-bottom: 1px solid #262626;
            padding: 12px 0;
        }
        .navbar-brand-custom {
            color: #ffffff !important;
            font-weight: 800;
            font-size: 22px;
            text-decoration: none;
        }

        /* Khối hộp bọc form chỉnh sửa */
        .edit-post-container {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            margin: 40px auto;
            max-width: 600px;
            border: 1px solid #efefef;
            overflow: hidden;
        }

        /* Tiêu đề dải màu hồng cam thương hiệu */
        .edit-post-header {
            background: linear-gradient(135deg, #ff1f5a 0%, #ff5e3a 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 10px;
            padding: 12px;
            border: 1px solid #ced4da;
        }
        .form-control:focus {
            border-color: #ff5e3a;
            box-shadow: 0 0 0 0.2rem rgba(255, 94, 58, 0.25);
        }

        /* Nút Lưu Thay Đổi Gradient rực rỡ */
        .btn-gradient {
            background: linear-gradient(45deg, #ff1f5a, #ff5e3a, #ff9033);
            border: none;
            color: white !important;
            padding: 12px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            opacity: 0.9;
            box-shadow: 0 4px 15px rgba(255, 31, 90, 0.3);
        }

        .btn-cancel {
            background-color: #efefef;
            color: #212529;
            font-weight: 600;
            border-radius: 25px;
            padding: 12px;
            border: none;
            transition: background 0.2s;
        }
        .btn-cancel:hover {
            background-color: #e2e2e2;
        }

        /* Khung hiển thị xem trước ảnh cũ */
        .preview-img-container {
            width: 100%;
            max-height: 350px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #efefef;
            margin-bottom: 15px;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<%
    // Lấy đối tượng bài viết cần sửa từ Servlet truyền sang
    Post post = (Post) request.getAttribute("post");
%>

<nav class="navbar-custom">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand-custom">
            <i class="fab fa-instagram me-2"></i>Mini Instagram
        </a>
    </div>
</nav>

<div class="container">
    <div class="edit-post-container shadow">

        <div class="edit-post-header">
            <h3 class="fw-bold m-0"><i class="fas fa-edit me-2"></i>Chỉnh sửa bài viết</h3>
            <p class="m-0 opacity-75 mt-1" style="font-size: 14px;">Thay đổi nội dung hoặc cập nhật caption của khoảnh khắc</p>
        </div>

        <div class="p-4 p-md-5">
            <form action="${pageContext.request.contextPath}/edit-post" method="POST">
                <input type="hidden" name="id" value="<%= (post != null) ? post.getId() : "" %>">

                <div class="mb-4">
                    <label class="form-label"><i class="fas fa-image me-2"></i>Hình ảnh bài viết</label>
                    <div class="preview-img-container d-flex align-items-center justify-content-center">
                        <% if (post != null && post.getImage_url() != null && !post.getImage_url().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= post.getImage_url() %>" style="width: 100%; height: 100%; object-fit: cover;">
                        <% } else { %>
                        <div class="py-5 text-muted"><i class="fas fa-image fa-3x"></i><p class="m-0 mt-2">Bài viết không có ảnh</p></div>
                        <% } %>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="caption" class="form-label"><i class="fas fa-comment-alt me-2"></i>Nội dung (Caption)</label>
                    <textarea class="form-control" id="caption" name="caption" rows="4" placeholder="Viết gì đó về khoảnh khắc này..." required><%= (post != null) ? post.getCaption() : "" %></textarea>
                </div>

                <div class="row g-3">
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-cancel w-100 text-center text-decoration-none d-block">
                            Hủy bỏ
                        </a>
                    </div>
                    <div class="col-6">
                        <button type="submit" class="btn btn-gradient w-100">
                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                        </button>
                    </div>
                </div>
            </form>
        </div>

    </div>
</div>

</body>
</html>