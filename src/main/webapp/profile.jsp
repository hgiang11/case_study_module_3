<%@ page import="igmini.model.User" %>
<%@ page import="igmini.model.Post" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/releases/v6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .profile-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            margin: 30px auto;
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .stats {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 20px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            display: block;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }

        .posts-grid {
            padding: 30px;
        }

        .post-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .post-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .post-card:hover .post-image {
            transform: scale(1.05);
        }

        .post-content {
            padding: 20px;
        }

        .post-caption {
            color: #333;
            line-height: 1.6;
            margin-bottom: 10px;
        }

        .post-date {
            color: #666;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .navbar {
            background: #000 !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            border-bottom: 1px solid #262626;
        }

        .btn-gradient {
            background: #0095f6;
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .btn-gradient:hover {
            background: #0077cc;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fab fa-instagram"></i> Mini Instagram
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/create-post">
                <i class="fas fa-plus"></i> Đăng bài
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="profile-container">
        <%
            // 1. Lấy người đang đăng nhập (để biết bạn là ai)
            User currentUser = (User) session.getAttribute("user");

            // 2. Lấy người sở hữu trang profile đang xem (từ Servlet gửi sang)
            User profileUser = (User) request.getAttribute("profileUser");

            if (profileUser == null) {
                profileUser = currentUser;
            }

            List<Post> userPosts = (List<Post>) request.getAttribute("userPosts");
            int postCount = (userPosts != null) ? userPosts.size() : 0;

            // 3. Kiểm tra xem bạn có đang xem trang của chính mình không?
            boolean isMyProfile = (currentUser != null && profileUser != null && currentUser.getId() == profileUser.getId());

            // --- BỔ SUNG NHẬN DỮ LIỆU ĐẾM TỪ SERVLET TRUYỀN SANG ---
            int followerCount = (request.getAttribute("followerCount") != null) ? (int) request.getAttribute("followerCount") : 0;
            int followingCount = (request.getAttribute("followingCount") != null) ? (int) request.getAttribute("followingCount") : 0;
        %>

        <div class="profile-header">
            <div class="avatar" style="overflow: hidden; background: #fff;">
                <% if (profileUser.getAvatarUrl() != null && !profileUser.getAvatarUrl().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= profileUser.getAvatarUrl() %>"
                     style="width: 100%; height: 100%; object-fit: cover;">
                <% } else { %>
                <i class="fas fa-user" style="color: #667eea;"></i>
                <% } %>
            </div>
            <h2><%= profileUser.getUsername() %></h2>
            <p class="mb-3"><%= profileUser.getEmail() %></p>

            <%-- BƯỚC 3: KIỂM TRA QUYỀN ĐÃ ĐƯỢC TỐI ƯU THEO DÕI / ĐANG THEO DÕI --%>
            <% if (isMyProfile) { %>
            <a href="${pageContext.request.contextPath}/edit-profile" class="btn btn-sm btn-light mb-3" style="border-radius: 20px; font-weight: 600;">
                <i class="fas fa-edit"></i> Chỉnh sửa trang cá nhân
            </a>
            <% } else {
                boolean isFollowing = false;
                if (request.getAttribute("isFollowing") != null) {
                    isFollowing = (boolean) request.getAttribute("isFollowing");
                }
            %>
            <button id="btn-follow" data-userid="<%= profileUser.getId() %>"
                    class="btn btn-sm <%= isFollowing ? "btn-secondary" : "btn-primary" %> mb-3"
                    style="border-radius: 20px; font-weight: 600; padding: 5px 25px; border: none;">
                <i class="<%= isFollowing ? "fas fa-user-check" : "fas fa-user-plus" %>"></i>
                <span class="button-text"><%= isFollowing ? " Đang theo dõi" : " Theo dõi" %></span>
            </button>
            <% } %>

            <div class="stats">
                <div class="stat-item">
                    <span class="stat-number"><%= postCount %></span>
                    <span class="stat-label">Bài viết</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number"><%= followerCount %></span>
                    <span class="stat-label">Người theo dõi</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number"><%= followingCount %></span>
                    <span class="stat-label">Đang theo dõi</span>
                </div>
            </div>
        </div>

        <div class="posts-grid">
            <h4 class="mb-4">
                <i class="fas fa-images"></i>
                <%= isMyProfile ? "Bài viết của tôi" : "Bài viết của " + profileUser.getUsername() %>
            </h4>

            <% if (userPosts != null && !userPosts.isEmpty()) { %>
            <div class="row">
                <% for (Post post : userPosts) { %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="post-card">
                        <% if (post.getImage_url() != null && !post.getImage_url().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= post.getImage_url() %>" class="post-image">
                        <% } else { %>
                        <div class="post-image" style="background: #f0f0f0; display: flex; align-items: center; justify-content: center; height: 300px;">
                            <i class="fas fa-image" style="font-size: 48px; color: #ccc;"></i>
                        </div>
                        <% } %>
                        <div class="post-content">
                            <p class="post-caption"><%= post.getCaption() %></p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="post-date">
                                    <i class="far fa-calendar"></i> <%= (post.getCreated_at() != null) ? post.getCreated_at().toString().substring(0, 10) : "Mới đây" %>
                                </small>
                                <% if (isMyProfile) { %>
                                <a href="${pageContext.request.contextPath}/delete-post?id=<%= post.getId() %>"
                                   class="btn btn-outline-danger btn-sm"
                                   style="border-radius: 10px; padding: 2px 10px;"
                                   onclick="return confirm('Bạn có chắc muốn xóa khoảnh khắc này không?')">
                                    <i class="fas fa-trash-alt" style="font-size: 12px;"></i> Xóa
                                </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-camera"></i>
                <h5>Chưa có bài viết nào</h5>
                <p>Hãy chia sẻ khoảnh khắc đầu tiên của bạn!</p>
                <a href="${pageContext.request.contextPath}/create-post" class="btn btn-gradient">
                    <i class="fas fa-plus"></i> Tạo bài viết đầu tiên
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var btnFollow = document.getElementById('btn-follow');
        if (btnFollow) {
            btnFollow.addEventListener('click', function() {
                var userId = btnFollow.getAttribute('data-userid');

                fetch('${pageContext.request.contextPath}/follow?userId=' + userId)
                    .then(function(res) {
                        if (res.status === 401) {
                            window.location = '${pageContext.request.contextPath}/login';
                            return null;
                        }
                        return res.json();
                    })
                    .then(function(data) {
                        if (data && data.success) {
                            var icon = btnFollow.querySelector('i');
                            var textSpan = btnFollow.querySelector('.button-text');

                            if (data.isFollowing) {
                                textSpan.textContent = ' Đang theo dõi';
                                btnFollow.className = 'btn btn-sm btn-secondary mb-3';
                                if(icon) icon.className = 'fas fa-user-check';
                            } else {
                                textSpan.textContent = ' Theo dõi';
                                btnFollow.className = 'btn btn-sm btn-primary mb-3';
                                if(icon) icon.className = 'fas fa-user-plus';
                            }
                            // Tải lại trang sau khi cập nhật thành công để cập nhật lại bộ đếm chính xác
                            window.location.reload();
                        }
                    }).catch(function(err) {
                    console.error('Lỗi kết nối tính năng follow AJAX:', err);
                });
            });
        }
    });
</script>
</body>
</html>