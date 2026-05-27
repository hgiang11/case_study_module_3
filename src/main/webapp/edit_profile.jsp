<%@ page import="igmini.model.User" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 5/12/2026
  Time: 8:45 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Lấy thông tin người dùng từ Session
    User user = (User) session.getAttribute("user");

    // Nếu chưa đăng nhập thì đẩy về trang login cho an toàn
    if (user == null) {
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Profile - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #000;
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .edit-profile-container {
            background: #121212;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            padding: 50px;
            max-width: 600px;
            width: 100%;
            animation: slideUp 0.6s ease-out;
            border: 1px solid #262626;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .profile-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .profile-header h1 {
            color: #fff;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .profile-header p {
            color: #a0a0a0;
            font-size: 14px;
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 40px;
        }

        .avatar-circle {
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #0095f6, #00d4ff);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            color: white;
            border: 3px solid #404040;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .avatar-circle:hover {
            border-color: #0095f6;
            transform: scale(1.05);
        }




        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }

        .file-input-wrapper input[type="file"] {
            position: absolute;
            left: -9999px;
        }

        .file-input-label {
            display: block;
            padding: 12px 20px;
            background: #3a3a3a;
            color: #fff;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            font-size: 14px;
            border: 2px solid transparent;
        }

        .file-input-label:hover {
            background: #B39DDB;
            color: #000;
            border-color: #B39DDB;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            color: #fff;
            font-weight: 600;
            margin-bottom: 10px;
            display: block;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            background: #3a3a3a;
            border: 2px solid #404040;
            color: #fff;
            padding: 12px 15px;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control::placeholder {
            color: #808080;
        }

        .form-control:focus {
            background: #3a3a3a;
            border-color: #B39DDB;
            color: #fff;
            box-shadow: 0 0 0 0.2rem rgba(179, 157, 219, 0.25);
            outline: none;
        }

        .form-control:hover {
            border-color: #505050;
        }

        .btn-save {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 15px;
        }

        .btn-save:hover {
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(131, 58, 180, 0.4);
        }

        .btn-save:active {
            transform: translateY(0);
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
            color: #833AB4;
            text-decoration: none;
            font-size: 14px;
            text-align: center;
            width: 100%;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .btn-back:hover {
            color: #F56040;
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .edit-profile-container {
                padding: 30px;
            }

            .profile-header h1 {
                font-size: 24px;
            }

            .avatar-circle {
                width: 100px;
                height: 100px;
                font-size: 50px;
            }
        }
    </style>
</head>
<body>
    <div class="edit-profile-container">
        <div class="profile-header">
            <h1>🎨 Chỉnh Sửa Profile</h1>
            <p>Cập nhật thông tin cá nhân của bạn</p>
        </div>

        <form action="${pageContext.request.contextPath}/edit-profile" method="post" enctype="multipart/form-data">
            <div class="avatar-section">
                <div class="avatar-circle" id="avatarPreview">
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= user.getAvatarUrl() %>"
                         style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                    <% } else { %>
                    <i class="fas fa-user"></i>
                    <% } %>
                </div>

                <script>
                    document.getElementById('avatar').addEventListener('change', function(e) {
                        if (e.target.files && e.target.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function(event) {
                                document.getElementById('avatarPreview').innerHTML =
                                    '<img src="' + event.target.result + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
                            };
                            reader.readAsDataURL(e.target.files[0]);
                        }
                    });
                </script>
                <div class="file-input-wrapper">
                    <input type="file" name="avatar" id="avatar" accept="image/*">
                    <label for="avatar" class="file-input-label">
                        <i class="fas fa-cloud-upload-alt"></i> Chọn ảnh đại diện
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="username">
                    <i class="fas fa-user-tag"></i> Username
                </label>
                <input type="text" name="username" id="username" class="form-control" value="<%= user.getUsername() %>" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">
                    <i class="fas fa-envelope"></i> Email
                </label>
                <input type="email" name="email" id="email" class="form-control" value="<%= user.getEmail() %>" required>
            </div>

            <button type="submit" class="btn-save">
                <i class="fas fa-save"></i> Lưu Thay Đổi
            </button>
        </form>

        <a href="<%= request.getContextPath() %>/home" class="btn-back">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
