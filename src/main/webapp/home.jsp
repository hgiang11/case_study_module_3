<%@ page import="igmini.model.User" %>
<%@ page import="igmini.model.Post" %>
<%@ page import="igmini.model.Comment" %>
<%@ page import="java.util.List" %>
<%@ page import="igmini.dao.impl.LikeDAOImpl" %>
<%@ page import="igmini.dao.impl.CommentDAOImpl" %>
<%@ page import="igmini.dao.CommentDAO" %>
<%@ page import="igmini.dao.LikeDAO" %>
<%@ page import="igmini.model.Notification" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mini Instagram - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #fafafa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
        }

        /* Khắc phục đè màu navbar của Bootstrap */
        .navbar {
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%) !important;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.2);
            padding: 12px 0;
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: 700;
            color: white !important;
            letter-spacing: -1px;
            display: flex;
            align-items: center;
        }

        .navbar-brand::before {
            content: "";
            display: inline-block;
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%);
            border: 2px solid white;
            border-radius: 8px;
            margin-right: 8px;
        }

        .navbar-brand:hover {
            transform: scale(1.03);
            transition: transform 0.3s ease;
        }

        /* Tinh chỉnh thanh tìm kiếm bo tròn */
        .search-container {
            max-width: 260px;
            width: 100%;
        }
        .search-input {
            border-radius: 20px !important;
            background: rgba(255, 255, 255, 0.9) !important;
            font-size: 14px;
            padding-left: 15px;
            border: none !important;
        }
        .search-input:focus {
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.3) !important;
            background: white !important;
        }

        .user-info {
            color: white;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.2) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            padding: 6px 16px !important;
            border-radius: 20px !important;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 13px !important;
        }

        .btn-logout:hover {
            background: white !important;
            color: #FD1D1D !important;
        }

        .navbar-nav .btn-create-post {
            background: white !important;
            color: #FD1D1D !important;
            border: none !important;
            padding: 6px 16px !important;
            border-radius: 20px !important;
            text-decoration: none !important;
            font-weight: 700 !important;
            font-size: 13px !important;
            margin-right: 5px !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 5px !important;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1) !important;
            transition: all 0.3s ease !important;
        }

        .navbar-nav .btn-create-post:hover {
            background: rgba(255,255,255,0.9) !important;
            transform: translateY(-1px);
        }

        .btn-login {
            background: white !important;
            color: #833AB4 !important;
            padding: 8px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            display: inline-block;
        }

        .container-main {
            max-width: 600px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .welcome-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        /* Sửa màu hiển thị chữ Welcome tránh bị ẩn */
        .welcome-section h1 {
            color: #262626;
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .welcome-section p {
            color: #666;
            font-size: 14px;
        }

        /* Sửa màu hiển thị tiêu đề danh sách bài viết */
        .posts-title {
            color: #262626;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .post-card {
            background: white;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
            overflow: hidden;
        }

        .post-image-container {
            background: #efefef;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .post-image {
            width: 100%;
            height: auto;
            max-height: 550px;
            object-fit: cover;
        }

        .post-content {
            padding: 15px;
        }

        .post-caption {
            color: #262626;
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 12px;
        }

        .post-meta {
            color: #999;
            font-size: 12px;
            border-top: 1px solid #f0f0f0;
            padding-top: 12px;
        }

        .post-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 10px;
        }

        .like-button {
            background: none;
            border: none;
            padding: 0;
            color: #262626;
            cursor: pointer;
        }

        .like-button .fa-heart {
            font-size: 24px;
        }

        .like-button .fas.fa-heart {
            color: #ed4956;
        }

        .like-count {
            color: #262626;
            font-weight: 600;
            font-size: 14px;
        }

        .comments-section {
            margin-top: 12px;
            border-top: 1px solid #f0f0f0;
            padding-top: 12px;
        }

        .comments-header {
            font-size: 14px;
            font-weight: 600;
            color: #8e8e8e;
            margin-bottom: 10px;
        }

        .comments-list {
            max-height: 240px;
            overflow-y: auto;
            margin-bottom: 12px;
        }

        .comment-item {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .comment-content {
            flex: 1;
        }

        .comment-username {
            font-weight: 600;
            color: #262626;
            margin-right: 6px;
        }

        .comment-text {
            color: #262626;
            display: inline;
        }

        .comment-meta {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 4px;
            font-size: 11px;
            color: #8e8e8e;
        }

        .comment-delete-btn {
            background: none;
            border: none;
            color: #ed4956;
            cursor: pointer;
            font-weight: 600;
            padding: 0;
        }

        .comment-form {
            display: flex;
            gap: 8px;
            align-items: center;
            border-top: 1px solid #f0f0f0;
            padding-top: 10px;
        }

        .comment-form-group {
            flex: 1;
        }

        .comment-input {
            width: 100%;
            padding: 6px 0;
            border: none;
            font-size: 14px;
            resize: none;
            max-height: 80px;
        }
        .comment-input:focus {
            outline: none;
        }

        .comment-submit-btn {
            background: none;
            color: #0095f6;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .no-posts {
            background: white;
            border-radius: 12px;
            padding: 50px 20px;
            border: 1px solid #dee2e6;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .no-posts i {
            font-size: 50px;
            color: #262626;
            margin-bottom: 15px;
        }

        .no-posts p {
            font-size: 16px;
            font-weight: 600;
            color: #262626;
        }

        .no-posts .btn-create-post {
            color: white !important;
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 50%, #FCAF45 100%) !important;
            margin-top: 15px;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

        .not-logged-in {
            background: white;
            border-radius: 15px;
            padding: 50px 30px;
            text-align: center;
            border: 1px solid #dee2e6;
        }

        .not-logged-in h2 {
            color: #262626;
            font-size: 24px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        @media (max-width: 768px) {
            .search-container {
                display: none;
            }
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid px-lg-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">Mini Instagram</a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex me-auto my-2 my-lg-0 search-container">
                <input class="form-control search-input" type="search" name="query" placeholder="Tìm kiếm..." aria-label="Search" required>
            </form>

            <ul class="navbar-nav ms-auto align-items-center flex-row gap-3">
                <%
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        List<Notification> homeNotiList = (List<Notification>) request.getAttribute("homeNotiList");
                        Long unreadCount = (Long) request.getAttribute("unreadCount");
                        if (unreadCount == null) unreadCount = 0L;
                %>
                <li class="nav-item">
                    <span class="text-white user-info">
                        <i class="fas fa-user-circle me-1"></i> <%= user.getUsername() %>
                    </span>
                </li>

                <% if ("ADMIN".equals(user.getRole())) { %>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-warning rounded-pill fw-bold px-3" style="font-size: 13px;">
                        <i class="fas fa-user-shield"></i> Quản lý
                    </a>
                </li>
                <% } %>

                <li class="nav-item dropdown">
                    <a class="nav-link position-relative text-white" href="#" id="dropdownNoti" data-bs-toggle="dropdown" aria-expanded="false" style="font-size: 1.1rem; padding: 6px 10px;">
                        <i class="fas fa-bell"></i>
                        <% if (unreadCount > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem; padding: 3px 6px;">
                            <%= unreadCount %>
                        </span>
                        <% } %>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-0" aria-labelledby="dropdownNoti" style="width: 360px; max-height: 400px; overflow-y: auto; border-radius: 12px; margin-top: 10px;">
                        <li class="p-3 border-bottom bg-white sticky-top" style="border-top-left-radius: 12px; border-top-right-radius: 12px;">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0 fw-bold text-dark">Thông báo</h6>
                                <a href="${pageContext.request.contextPath}/notifications" class="text-primary small text-decoration-none">Xem tất cả</a>
                            </div>
                        </li>

                        <div class="noti-content-list">
                            <%
                                if (homeNotiList != null && !homeNotiList.isEmpty()) {
                                    for (Notification n : homeNotiList) {
                            %>
                            <li>
                                <div class="dropdown-item p-3 d-flex align-items-center justify-content-between border-bottom <%= n.isRead() ? "" : "bg-light fw-bold" %>" style="white-space: normal;">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width: 35px; height: 35px; border-radius: 50%; overflow:hidden; background: #eee; flex-shrink: 0;">
                                            <% if (n.getSenderAvatarUrl() != null && !n.getSenderAvatarUrl().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/<%= n.getSenderAvatarUrl() %>" style="width:100%; height:100%; object-fit:cover;">
                                            <% } else { %>
                                            <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-secondary text-white small"><i class="fas fa-user"></i></div>
                                            <% } %>
                                        </div>

                                        <div style="font-size: 0.85rem; color: #262626;">
                                            <span class="text-primary"><%= n.getSenderUsername() %></span>
                                            <% if ("LIKE".equals(n.getType())) { %> đã thích bài viết của bạn.
                                            <% } else if ("COMMENT".equals(n.getType())) { %> đã bình luận về bài viết.
                                            <% } else if ("FOLLOW".equals(n.getType())) { %> đã bắt đầu theo dõi bạn.
                                            <% } %>
                                            <div class="text-muted fw-normal" style="font-size: 0.75rem;">
                                                <%= n.getCreatedAt() != null && n.getCreatedAt().toString().length() >= 16 ? n.getCreatedAt().toString().substring(5, 16) : n.getCreatedAt() %>
                                            </div>
                                        </div>
                                    </div>

                                    <% if (n.getPostId() != null) { %>
                                    <a href="${pageContext.request.contextPath}/post-detail?id=<%= n.getPostId() %>" class="btn btn-sm btn-outline-secondary py-0 px-2 rounded-pill" style="font-size: 0.75rem;">Xem</a>
                                    <% } else { %>
                                    <a href="${pageContext.request.contextPath}/profile?userId=<%= n.getSenderId() %>" class="btn btn-sm btn-outline-primary py-0 px-2 rounded-pill" style="font-size: 0.75rem;">Xem</a>
                                    <% } %>
                                </div>
                            </li>
                            <%
                                }
                            } else {
                            %>
                            <li class="text-center p-4 text-muted small">Bạn không có thông báo nào mới.</li>
                            <% } %>
                        </div>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/create-post" class="btn-create-post">
                        <i class="fas fa-plus"></i> Đăng bài
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        Đăng xuất
                    </a>
                </li>
                <%
                } else {
                %>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">
                        Đăng nhập
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<div class="container-main">
    <%
        if (user != null) {
            String reportMsg = (String) session.getAttribute("message");
            if (reportMsg != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i> <%= reportMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
            session.removeAttribute("message");
        }
    %>

    <div class="welcome-section">
        <h1>Chào mừng, <%= user.getUsername() %>! 👋</h1>
        <p>Email: <%= user.getEmail() %></p>
    </div>

    <div class="posts-grid">
        <h2 class="posts-title"><i class="fas fa-images"></i> Bài viết gần đây</h2>
        <%
            List<Post> posts = (List<Post>) request.getAttribute("postList");
            LikeDAO likeDAO = new LikeDAOImpl();
            if (posts != null && !posts.isEmpty()) {
                for(Post p : posts) {
        %>
        <div class="post-card">
            <div class="p-3 d-flex align-items-center border-bottom">
                <a href="${pageContext.request.contextPath}/profile?userId=<%= p.getUser_id() %>">
                    <img src="<%= (p.getAvatarUrl() != null && !p.getAvatarUrl().isEmpty()) ? request.getContextPath() + "/" + p.getAvatarUrl() : "https://ui-avatars.com/api/?name=" + p.getUsername() %>"
                         style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;" class="me-2 border">
                </a>

                <a href="${pageContext.request.contextPath}/profile?userId=<%= p.getUser_id() %>" class="text-decoration-none fw-bold" style="color: #262626;">
                    <%= p.getUsername() %>
                </a>

                <% if (user.getId() == p.getUser_id()) { %>
                <a href="${pageContext.request.contextPath}/delete-post?id=<%= p.getId() %>"
                   class="btn btn-sm ms-auto"
                   style="background: none; border:none; color: #ed4956; font-weight: 600;"
                   onclick="return confirm('Bạn có chắc muốn xóa không?')">
                    Xóa
                </a>
                <% } else { %>
                <button type="button" class="btn btn-sm ms-auto text-danger fw-bold"
                        style="background: none; border:none;"
                        data-bs-toggle="modal" data-bs-target="#reportPostModal"
                        data-post-id="<%= p.getId() %>" onclick="preparePostReportId(this)">
                    Báo cáo
                </button>
                <% } %>

            </div>

            <div class="post-image-container">
                <img src="${pageContext.request.contextPath}/<%= p.getImage_url() %>" class="post-image">
            </div>

            <div class="post-content">
                <div class="post-actions">
                    <%
                        int likeCount = likeDAO.getLikeCount(p.getId());
                        boolean liked = false;
                        if (user != null) {
                            liked = likeDAO.checkIfUserLiked(user.getId(), p.getId());
                        }
                    %>
                    <button type="button" class="like-button <%= liked ? "liked" : "" %>" data-postid="<%= p.getId() %>">
                        <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"></i>
                    </button>
                    <div class="like-count"><%= likeCount %> lượt thích</div>
                </div>

                <div class="post-caption">
                    <span class="fw-bold me-2"><%= p.getUsername() %></span><%= p.getCaption() %>
                </div>
                <div class="post-meta">
                         <span>
                             <%= p.getCreated_at() != null ? p.getCreated_at().toString() : "" %>
                         </span>
                </div>

                <%
                    CommentDAO commentDAO = new CommentDAOImpl();
                    List<Comment> comments = commentDAO.getCommentsByPostId(p.getId());
                    int commentCount = comments.size();
                %>
                <div class="comments-section">
                    <% if (commentCount > 0) { %>
                    <div class="comments-header">
                        Xem tất cả <%= commentCount %> bình luận
                    </div>
                    <div class="comments-list">
                        <% for (Comment cmt : comments) { %>
                        <div class="comment-item">
                            <div class="comment-content">
                                <span class="comment-username"><%= cmt.getUsername() %></span>
                                <div class="comment-text"><%= cmt.getContent() %></div>
                                <div class="comment-meta">
                                         <span>
                                             <%= cmt.getCreated_at() != null ? cmt.getCreated_at().toString().substring(0, 10) : "" %>
                                         </span>
                                    <% if (user != null && user.getId() == cmt.getUser_id_comment()) { %>
                                    <button class="comment-delete-btn" onclick="deleteComment(<%= cmt.getId() %>, <%= p.getId() %>)">
                                        Xóa
                                    </button>

                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>

                    <% if (user != null) { %>
                    <div class="comment-form">
                        <div class="comment-form-group">
                            <textarea class="comment-input" placeholder="Thêm bình luận..." data-postid="<%= p.getId() %>" rows="1" maxlength="500"></textarea>
                        </div>
                        <button class="comment-submit-btn" onclick="submitComment(<%= p.getId() %>)">Đăng</button>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="no-posts">
            <i class="far fa-image"></i>
            <p>Chưa có bài viết nào</p>
            <a href="${pageContext.request.contextPath}/create-post" class="btn-create-post">
                <i class="fas fa-plus"></i> Tạo bài viết đầu tiên
            </a>
        </div>
        <%
            }
        %>
    </div>
    <%
    } else {
    %>
    <div class="not-logged-in">
        <h2>Chào mừng đến Mini Instagram! 📸</h2>
        <p>Vui lòng đăng nhập để xem bài viết và chia sẻ khoảnh khắc của bạn.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn-login" style="background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 50%, #FCAF45 100%) !important; color: white !important;">
            Đăng nhập ngay
        </a>
    </div>
    <%
        }
    %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.like-button').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                var postId = btn.getAttribute('data-postid');
                if (!postId) return;
                fetch('${pageContext.request.contextPath}/like?postId=' + encodeURIComponent(postId), {
                    method: 'GET',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                }).then(function(res) {
                    if (res.status === 401) {
                        window.location = '${pageContext.request.contextPath}/login';
                        return null;
                    }
                    return res.json();
                }).then(function(data) {
                    if (!data) return;
                    var liked = !!data.liked;
                    var count = data.count || 0;
                    var icon = btn.querySelector('i');
                    if (liked) {
                        btn.classList.add('liked');
                        if (icon) icon.className = 'fas fa-heart';
                    } else {
                        btn.classList.remove('liked');
                        if (icon) icon.className = 'far fa-heart';
                    }
                    var container = btn.parentElement;
                    var countElem = container.querySelector('.like-count');
                    if (countElem) countElem.textContent = count + ' lượt thích';
                }).catch(function(err) {
                    console.error('Like request failed', err);
                });
            });
        });

        document.querySelectorAll('.comment-input').forEach(function(textarea) {
            textarea.addEventListener('input', function(e) {
                this.style.height = 'auto';
                this.style.height = Math.min(this.scrollHeight, 80) + 'px';
            });
        });
    });

    function submitComment(postId) {
        var textarea = document.querySelector('textarea[data-postid="' + postId + '"]');
        var content = textarea.value.trim();
        if (!content) return;

        var btn = textarea.closest('.comment-form').querySelector('.comment-submit-btn');
        btn.disabled = true;

        var params = new URLSearchParams();
        params.append('post_id_comment', postId);
        params.append('content', content);

        fetch('${pageContext.request.contextPath}/comment', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            }
        }).then(function(res) {
            if (res.status === 401) {
                window.location = '${pageContext.request.contextPath}/login';
                return null;
            }
            return res.json();
        }).then(function(data) {
            if (data && data.success) {
                location.reload();
            } else {
                alert('Lỗi khi thêm bình luận');
                btn.disabled = false;
            }
        }).catch(function(err) {
            btn.disabled = false;
        });
    }

    function deleteComment(commentId, postId) {
        if (!confirm('Bạn có chắc muốn xóa bình luận này?')) return;
        var params = new URLSearchParams();
        params.append('comment_id', commentId);

        fetch('${pageContext.request.contextPath}/comment-delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                if (data && data.success) location.reload();
            });
    }
</script>
<div class="modal fade" id="reportPostModal" tabindex="-1" aria-labelledby="reportPostModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 12px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark" id="reportPostModalLabel">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>Báo cáo bài viết
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form action="${pageContext.request.contextPath}/report" method="POST">
                <div class="modal-body px-4">
                    <input type="hidden" name="postId" id="submitReportPostId">
                    <p class="text-muted small mb-3">Tại sao bạn muốn báo cáo bài viết này? Lựa chọn của bạn giúp đội ngũ Admin kiểm duyệt nội dung chính xác hơn.</p>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="reason" id="reason1" value="Nội dung nhạy cảm, đồi trụy" checked>
                        <label class="form-check-label fw-semibold text-secondary" for="reason1">Nội dung nhạy cảm, đồi trụy</label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="reason" id="reason2" value="Bạo lực, kích động bạo lực">
                        <label class="form-check-label fw-semibold text-secondary" for="reason2">Bạo lực, kích động bạo lực</label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="reason" id="reason3" value="Ngôn từ gây thù ghét, quấy rối">
                        <label class="form-check-label fw-semibold text-secondary" for="reason3">Ngôn từ gây thù ghét, quấy rối</label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="reason" id="reason4" value="Spam hoặc lừa đảo">
                        <label class="form-check-label fw-semibold text-secondary" for="reason4">Spam hoặc lừa đảo</label>
                    </div>
                </div>
                <div class="modal-footer border-top-0 pb-4 px-4">
                    <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">Gửi báo cáo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function preparePostReportId(button) {
        var postId = button.getAttribute('data-post-id');
        document.getElementById('submitReportPostId').value = postId;
    }
</script>
</body>
</html>