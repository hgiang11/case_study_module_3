<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đổi Mật Khẩu - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #000000; /* Nền đen tuyền toàn trang giống profile */
            color: #ffffff;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        .custom-card {
            background-color: #121212; /* Màu xám tối của form card */
            border: 1px solid #262626;
            border-radius: 16px;
            max-width: 500px;
            width: 100%;
        }
        .form-label {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #a8a8a8;
            margin-bottom: 8px;
        }
        .form-control {
            background-color: #262626 !important; /* Ô input màu xám đậm */
            border: 1px solid #363636 !important;
            color: #ffffff !important;
            padding: 12px 16px;
            border-radius: 8px;
        }
        .form-control:focus {
            background-color: #313131 !important;
            border-color: #555555 !important;
            box-shadow: none !important;
        }
        /* Nút Lưu Gradient dực dỡ giống nút Lưu Thay Đổi */
        .btn-gradient {
            background: linear-gradient(45deg, #b2006d, #ff5e3a, #ff9033);
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            transition: opacity 0.2s;
        }
        .btn-gradient:hover {
            opacity: 0.9;
            color: white;
        }
        .btn-back {
            color: #a8a8a8;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: color 0.2s;
        }
        .btn-back:hover {
            color: #7a46e6; /* Màu tím khi hover link quay lại giống của bạn */
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100">

<div class="custom-card p-4 mx-3 shadow-lg">
    <div class="text-center mb-4">
        <h2 class="fw-bold mb-2" style="font-size: 28px;">
            <i class="fa-solid fa-key" style="color: #ff5e3a;"></i> Đổi Mật Khẩu
        </h2>
        <p style="color: #a8a8a8; font-size: 14px;">Cập nhật mật khẩu bảo mật tài khoản của bạn</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger border-0 text-center py-2" style="background-color: #3a1616; color: #ff8585; border-radius: 8px; font-size: 14px;">
        <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/change-password" method="POST">
        <div class="mb-3">
            <label class="form-label"><i class="fas fa-lock me-1"></i> Mật khẩu hiện tại</label>
            <input type="password" name="oldPassword" class="form-control" placeholder="Nhập mật khẩu cũ" required>
        </div>

        <div class="mb-3">
            <label class="form-label"><i class="fas fa-shield-alt me-1"></i> Mật khẩu mới</label>
            <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required>
        </div>

        <div class="mb-4">
            <label class="form-label"><i class="fas fa-check-double me-1"></i> Xác nhận mật khẩu mới</label>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
        </div>

        <div class="d-grid gap-2 mb-3">
            <button type="submit" class="btn btn-gradient">
                <i class="fas fa-save me-2"></i> Lưu Thay Đổi
            </button>
        </div>

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/home" class="btn-back">
                <i class="fas fa-arrow-left me-1"></i> Quay lại
            </a>
        </div>
    </form>
</div>

</body>
</html>