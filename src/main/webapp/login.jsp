<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        .login-card {
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            padding: 40px;
            animation: slideUp 0.5s ease-out;
            border: 1px solid #262626;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

        .login-card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 28px;
        }

        .login-card h2::before {
            content: "📸 ";
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: white;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: #f9f9f9;
        }

        .form-group input::placeholder {
            color: #999;
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        button[type="submit"]:active {
            transform: translateY(0);
        }

        .login-footer {
            text-align: center;
            margin-top: 25px;
            color: white;
            font-size: 14px;
        }

        .login-footer a {
            color: #0095f6;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-footer a:hover {
            color: #00b4d8;
        }
        @media (max-width: 480px) {
            .login-card {
                padding: 30px 20px;
            }

            .login-card h2 {
                font-size: 24px;
                margin-bottom: 25px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
         <div class="login-card">
             <h2><span class="logo-icon"></span>Đăng nhập</h2>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="username">Tên đăng nhập:</label>
                    <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>

                <button type="submit">Đăng nhập</button>
            </form>

            <div class="login-footer">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </div>
    </div>



    <%-- ĐOẠN CODE HIỂN THỊ THÔNG BÁO KHÓA TÀI KHOẢN --%>
    <%
        String errorParam = request.getParameter("error");
        if ("locked".equals(errorParam)) {
    %>
    <div style="color: red; background-color: #ffe6e6; border: 1px solid red; padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; font-weight: bold;">
        Tài khoản của bạn đã bị khóa do vi phạm quy chuẩn cộng đồng!
    </div>
    <%
        }
    %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>