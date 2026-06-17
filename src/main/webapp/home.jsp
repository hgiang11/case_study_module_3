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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #f8f9fa; /* Màu nền trắng xám nhẹ đồng bộ */
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
            color: #212529;
        }

        /* 🖤 Navbar màu đen tuyền trơn sạch sẽ, không còn nút Đăng bài nữa */
        .navbar-custom {
            background-color: #000000 !important;
            border-bottom: 1px solid #262626;
            padding: 12px 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .navbar-brand-custom {
            font-size: 22px;
            font-weight: 800;
            color: white !important;
            text-decoration: none;
            letter-spacing: -0.5px;
        }

        .search-container {
            max-width: 240px;
            width: 100%;
        }
        .search-input {
            border-radius: 20px !important;
            background: #262626 !important;
            font-size: 14px;
            padding-left: 15px;
            border: 1px solid #363636 !important;
            color: white !important;
        }
        .search-input::placeholder {
            color: #8e8e8e;
        }
        .search-input:focus {
            box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.2) !important;
            background: #363636 !important;
        }

        .user-info {
            color: #efefef;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-logout {
            background: transparent !important;
            color: #b3b3b3 !important;
            border: none !important;
            padding: 6px 12px !important;
            border-radius: 20px !important;
            text-decoration: none;
            transition: all 0.2s ease;
            font-weight: 600;
            font-size: 13px !important;
        }
        .btn-logout:hover {
            color: #ff3b30 !important;
        }

        .container-main {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 15px;
        }

        /* ✨ KHỐI HỘP CHÀO MỪNG KẾT HỢP ĐĂNG BÀI NHANH (MỚI) */
        .welcome-section {
            background: white;
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            border: 1px solid #efefef;
        }
        .welcome-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            border-bottom: 1px solid #f2f2f2;
            padding-bottom: 14px;
        }
        .welcome-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #dee2e6;
        }
        .welcome-text h1 {
            color: #212529;
            font-size: 18px;
            font-weight: 700;
            margin: 0;
        }
        .welcome-text p {
            font-size: 13px;
            color: #8e8e8e;
            margin: 0;
        }

        /* Thanh giả lập ô nhập liệu để click chuyển hướng sang trang Đăng bài */
        .create-post-trigger {
            background-color: #f0f2f5;
            border-radius: 25px;
            padding: 10px 20px;
            color: #65676b;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            justify-content: space-between;
            text-decoration: none !important;
        }
        .create-post-trigger:hover {
            background-color: #e4e6eb;
            color: #65676b;
        }
        .post-icon-badge {
            background: linear-gradient(45deg, #ff1f5a, #ff5e3a);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            box-shadow: 0 4px 8px rgba(255, 31, 90, 0.2);
        }

        .posts-title {
            color: #212529;
            font-size: 19px;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Thẻ bài viết */
        .post-card {
            background: white;
            border-radius: 16px;
            margin-bottom: 30px;
            border: 1px solid #efefef;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            overflow: hidden;
        }

        .post-image-container {
            background: #fafafa;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
        }

        .post-image {
            width: 100%;
            height: auto;
            max-height: 580px;
            object-fit: cover;
        }

        .post-content {
            padding: 18px;
        }

        .post-caption {
            color: #212529;
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 12px;
        }

        .post-meta {
            color: #8e8e8e;
            font-size: 12px;
            border-top: 1px solid #f8f9fa;
            padding-top: 12px;
        }

        .post-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 12px;
        }

        .like-button {
            background: none;
            border: none;
            padding: 0;
            color: #212529;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .like-button:hover {
            transform: scale(1.1);
        }
        .like-button .fa-heart {
            font-size: 24px;
        }
        .like-button .fas.fa-heart {
            color: #ff3b30;
        }

        .like-count {
            color: #212529;
            font-weight: 700;
            font-size: 14px;
        }

        .comments-section {
            margin-top: 14px;
            border-top: 1px solid #f8f9fa;
            padding-top: 14px;
        }

        .comments-header {
            font-size: 14px;
            font-weight: 600;
            color: #8e8e8e;
            margin-bottom: 10px;
        }

        .comments-list {
            max-height: 200px;
            overflow-y: auto;
            margin-bottom: 12px;
        }

        .comment-item {
            display: flex;
            gap: 10px;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .comment-username {
            font-weight: 700;
            color: #212529;
            margin-right: 6px;
        }

        .comment-text {
            color: #212529;
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
            color: #ff3b30;
            cursor: pointer;
            font-weight: 600;
            padding: 0;
        }

        .comment-form {
            display: flex;
            gap: 10px;
            align-items: center;
            border-top: 1px solid #f8f9fa;
            padding-top: 12px;
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
            background: transparent;
        }
        .comment-input:focus {
            outline: none;
        }

        .comment-submit-btn {
            background: none;
            color: #0095f6;
            border: none;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
        }

        .no-posts {
            background: white;
            border-radius: 20px;
            padding: 60px 20px;
            border: 1px solid #efefef;
            text-align: center;
        }

        .no-posts i {
            font-size: 48px;
            color: #8e8e8e;
            margin-bottom: 15px;
        }

        .not-logged-in {
            background: white;
            border-radius: 20px;
            padding: 60px 30px;
            text-align: center;
            border: 1px solid #efefef;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
        }

        .not-logged-in h2 {
            font-size: 24px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        @media (max-width: 768px) {
            .search-container {
                display: none;
            }
        }





        .suggestion-sidebar {
            position: absolute;
            top: 15px;               /* Căn cao bằng với phần "Chào mừng, izlne.a!" */
            left: calc(100% + 30px); /* Đẩy hẳn ra ngoài cạnh phải của khối chính 30px */
            width: 300px;            /* Độ rộng của cột gợi ý */
            height: fit-content;
            background: #ffffff;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Đổ bóng nhẹ giống các card của bạn */
        }
    </style>
</head>
<body class="bg-light d-flex flex-column min-vh-100">


<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container-fluid px-lg-4">
        <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/home">
            <i class="fab fa-instagram me-2"></i>Mini Instagram
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex me-auto my-2 my-lg-0 search-container ms-4">
                <input class="form-control search-input" type="search" name="query" placeholder="Tìm kiếm..." aria-label="Search" required>
            </form>

            <ul class="navbar-nav ms-auto align-items-center flex-row gap-2">
                <%
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        List<Notification> homeNotiList = (List<Notification>) request.getAttribute("homeNotiList");
                        Long unreadCount = (Long) request.getAttribute("unreadCount");
                        if (unreadCount == null) unreadCount = 0L;
                %>
                <li class="nav-item me-2">
                    <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none user-info">
                        <i class="fas fa-user-circle me-1"></i> <%= user.getUsername() %>
                    </a>
                </li>

                <% if ("ADMIN".equals(user.getRole())) { %>
                <li class="nav-item me-2">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-warning rounded-pill fw-bold px-3" style="font-size: 13px;">
                        <i class="fas fa-user-shield"></i> Quản lý
                    </a>
                </li>
                <% } %>

                <li class="nav-item dropdown me-2">
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
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        Đăng xuất
                    </a>
                </li>
                <%
                } else {
                %>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-light rounded-pill px-3 fw-bold">
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


<div class="container py-4 flex-grow-1">

<div class="container-main position-relative">

    <div class="suggestion-sidebar d-none d-xl-block">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <span class="text-secondary fw-bold small">Gợi ý cho bạn</span>
            <a href="#" class="text-dark fw-bold small text-decoration-none" style="font-size: 12px;">Xem tất cả</a>
        </div>

        <div class="suggestion-list">
            <%
                List<User> suggestedUsers = (List<User>) request.getAttribute("suggestedUsers");
                if (suggestedUsers != null && !suggestedUsers.isEmpty()) {
                    for (User su : suggestedUsers) {
            %>
            <div class="d-flex justify-content-between align-items-center mb-3" style="width: 280px;">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/<%= (su.getAvatarUrl() != null && !su.getAvatarUrl().isEmpty()) ? su.getAvatarUrl() : "assets/images/default-avatar.png" %>"
                         class="rounded-circle border me-2"
                         style="width: 36px; height: 36px; object-fit: cover;">
                    <div class="d-flex flex-column">
                        <span class="fw-bold text-dark small">@<%= su.getUsername() %></span>
                        <span class="text-muted extra-small" style="font-size: 11px;">Gợi ý cho bạn</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/interaction/follow?action=follow&id=<%= su.getId() %>"
                   class="btn btn-sm btn-link text-primary fw-bold text-decoration-none small p-0" style="font-size: 12px;">
                    Theo dõi
                </a>
            </div>
            <%




                }
            } else {
            %>
            <p class="text-muted small fst-italic text-center my-2">Không có gợi ý mới.</p>
            <% } %>
        </div>
    </div>


</div>
<div class="container-main">
    <%
        if (user != null) {
            String reportMsg = (String) session.getAttribute("message");
            if (reportMsg != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
        <i class="fas fa-check-circle me-2"></i> <%= reportMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
            session.removeAttribute("message");
        }
    %>

    <div class="welcome-section shadow-sm">
        <div class="welcome-header">
            <img src="https://ui-avatars.com/api/?name=<%= user.getUsername() %>&background=ff5e3a&color=fff" class="welcome-avatar" alt="Avatar">
            <div class="welcome-text">
                <h1>Chào mừng, <%= user.getUsername() %>! 👋</h1>
                <p>Hôm nay bạn thế nào? Chia sẻ một khoảnh khắc mới nhé.</p>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/create-post" class="create-post-trigger">
            <span>Bạn đang nghĩ gì thế?</span>
            <div class="post-icon-badge">
                <i class="fas fa-plus"></i>
            </div>
        </a>
    </div>

    <div class="posts-grid">
        <h2 class="posts-title"><i class="fas fa-stream text-danger"></i> Bảng tin khoảnh khắc</h2>
        <%
            List<Post> posts = (List<Post>) request.getAttribute("postList");
            LikeDAO likeDAO = new LikeDAOImpl();
            if (posts != null && !posts.isEmpty()) {
                for(Post p : posts) {

                    String rawImgUrl = p.getImage_url();
                    String finalImgUrl = "";
                    if(rawImgUrl != null) {
                        if(rawImgUrl.startsWith("http") || rawImgUrl.startsWith("/")) {
                            finalImgUrl = request.getContextPath() + rawImgUrl;
                        } else {
                            finalImgUrl = request.getContextPath() + "/" + rawImgUrl;
                        }
                    }
        %>
        <div class="post-card">
            <div class="p-3 d-flex align-items-center border-bottom">
                <a href="${pageContext.request.contextPath}/profile?userId=<%= p.getUser_id() %>">
                    <img src="<%= (p.getAvatarUrl() != null && !p.getAvatarUrl().isEmpty()) ? request.getContextPath() + "/" + p.getAvatarUrl() : "https://ui-avatars.com/api/?name=" + p.getUsername() %>"
                         style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;" class="me-2 border">
                </a>

                <a href="${pageContext.request.contextPath}/profile?userId=<%= p.getUser_id() %>" class="text-decoration-none fw-bold" style="color: #212529; font-size: 14px;">
                    <%= p.getUsername() %>
                </a>

                <% if (user.getId() == p.getUser_id()) { %>
                <a href="${pageContext.request.contextPath}/delete-post?id=<%= p.getId() %>"
                   class="btn btn-sm ms-auto"
                   style="background: none; border:none; color: #ff3b30; font-weight: 600; font-size: 13px;"
                   onclick="return confirm('Bạn có chắc muốn xóa bài viết này không?')">
                    Xóa
                </a>
                <% } else { %>
                <button type="button" class="btn btn-sm ms-auto text-danger fw-bold"
                        style="background: none; border:none; font-size: 13px;"
                        data-bs-toggle="modal" data-bs-target="#reportPostModal"
                        data-post-id="<%= p.getId() %>" onclick="preparePostReportId(this)">
                    Báo cáo
                </button>
                <% } %>
            </div>

            <div class="post-image-container">
                <img src="<%= finalImgUrl %>" class="post-image" alt="Post Image">
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
                         <i class="far fa-clock me-1"></i><%= p.getCreated_at() != null ? p.getCreated_at().toString() : "" %>
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
        <div class="no-posts shadow-sm">
            <i class="far fa-images d-block text-muted"></i>
            <p class="fw-semibold">Chưa có bài viết nào trên hệ thống</p>
        </div>
        <%
            }
        %>
    </div>
    <%
    } else {
    %>
    <div class="not-logged-in shadow-sm">
        <h2 class="fw-bold">📸 Chào mừng đến Mini Instagram!</h2>
        <p class="text-muted mb-4">Vui lòng đăng nhập để theo dõi bài viết và chia sẻ khoảnh khắc tuyệt vời của bạn.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-danger rounded-pill px-4 py-2 fw-bold" style="background: linear-gradient(45deg, #ff1f5a, #ff5e3a) !important; border:none;">
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
                    console.error('Like failed', err);
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

    function preparePostReportId(btn) {
        var postId = btn.getAttribute('data-post-id');
        document.getElementById('submitReportPostId').value = postId;
    }
</script>

<div class="modal fade" id="reportPostModal" tabindex="-1" aria-labelledby="reportPostModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 16px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark" id="reportPostModalLabel">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>Báo cáo bài viết
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/report" method="POST">
                <div class="modal-body px-4">
                    <input type="hidden" name="postId" id="submitReportPostId">
                    <p class="text-muted small mb-3">Tại sao bạn muốn báo cáo bài viết này? Lựa chọn của bạn giúp đội ngũ Admin kiểm duyệt chính xác hơn.</p>
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
</div>

<footer class="bg-black text-white-50 border-top border-secondary text-xs" style="padding: 2px 0; height: 24px; line-height: 20px; margin-top: auto;">
    <div class="container d-flex justify-content-between align-items-center" style="max-width: 935px; height: 100%;">
        <div style="opacity: 0.6; font-size: 11px; display: flex; align-items: center;">
            &copy; 2026 Mini Instagram. All rights reserved.
        </div>
        <div class="d-flex gap-3 text-white-50" style="opacity: 0.6; font-size: 11px; display: flex; align-items: center;">
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-facebook"></i></a>
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-twitter-x"></i></a>
            <a href="#" class="text-white-50 text-decoration-none"><i class="bi bi-instagram"></i></a>
        </div>
    </div>
</footer>
</body>
</html>