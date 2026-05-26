<%@ page import="igmini.model.User" %>
<%@ page import="igmini.model.Post" %>
<%@ page import="igmini.model.Comment" %>
<%@ page import="java.util.List" %>
<%@ page import="igmini.dao.impl.LikeDAOImpl" %>
<%@ page import="igmini.dao.impl.CommentDAOImpl" %>
<%@ page import="igmini.dao.CommentDAO" %>
<%@ page import="igmini.dao.LikeDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mini Instagram - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/releases/v6.0.0/css/all.min.css">
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

        .navbar {
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%);
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.2);
            padding: 15px 0;
        }

        .navbar-brand {
            font-size: 28px;
            font-weight: 700;
            color: white !important;
            letter-spacing: -1px;
        }

        .navbar-brand::before {
            content: "";
            display: inline-block;
            width: 30px;
            height: 30px;
            background: linear-gradient(135deg, #833AB4 0%, #FD1D1D 25%, #F56040 50%, #FCAF45 100%);
            border: 2px solid white;
            border-radius: 6px;
            margin-right: 8px;
            vertical-align: middle;
            position: relative;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
            transition: transform 0.3s ease;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            color: white;
            font-size: 14px;
            font-weight: 500;
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 14px;
        }

        .btn-logout:hover {
            background: white;
            color: #667eea;
        }


         /* Style cho nút nằm trong khối trắng khi không có bài viết */
         .no-posts .btn-create-post {
             color: #212529 !important;
             border: 2px solid #999999 !important;
             background: white !important;
             margin-top: 15px !important;
             padding: 12px 30px !important;
             border-radius: 15px !important;
             text-decoration: none !important;
             display: inline-flex !important;
             align-items: center !important;
             gap: 8px !important;
             font-weight: 600 !important;
             transition: all 0.3s ease !important;
         }

         .no-posts .btn-create-post:hover {
             background: #777777 !important;
             color: white !important;
             transform: translateY(-2px);
         }

         .navbar-nav .btn-create-post {
             background: rgba(255, 255, 255, 0.2) !important;
             color: white !important;
             border: 2px solid white !important;
             padding: 8px 16px !important;
             border-radius: 15px !important;
             text-decoration: none !important;
             font-weight: 600 !important;
             font-size: 14px !important;
             margin-right: 10px !important;
             display: inline-flex !important;
             align-items: center !important;
             gap: 5px !important;
             transition: all 0.3s ease !important;
         }

         .navbar-nav .btn-create-post:hover {
             background: #833AB4 !important;
             color: white !important;
             transform: translateY(-2px);
         }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .container-main {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
        }

        .welcome-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .welcome-section h1 {
            color: white;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .welcome-section p {
            color: white;
            font-size: 16px;
        }

        .posts-grid {
            margin-top: 30px;
        }

        .posts-title {
            color: white;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 25px;
            text-align: center;
        }

        .post-card {
            background: white;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        .post-image-container {
            position: relative;
            overflow: hidden;
            max-height: 600px; /* Dùng max-height để linh hoạt theo ảnh */
            background: #efefef;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .post-image {
            width: 100%;
            height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
            background: #555555;
        }

        .post-card:hover .post-image {
            transform: scale(1.05);
        }

        .post-content {
            padding: 20px;
        }

         .post-caption {
             color: #262626;
             font-size: 16px;
             line-height: 1.6;
             margin-bottom: 15px;
             white-space: normal;
             word-break: break-word;
             word-wrap: break-word;
             overflow-wrap: break-word;
         }

        .post-meta {
            color: #999;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .post-meta i {
            color: #833AB4;
        }

        /* Like button styles */
        .post-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .like-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            border: 1px solid #eee;
            background: white;
            color: #333;
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            transition: all 0.15s ease;
        }

        .like-button .fa-heart {
            font-size: 18px;
            color: #e74c3c;
        }

        .like-button.liked {
            background: linear-gradient(90deg, rgba(231,76,60,0.12), rgba(231,76,60,0.08));
            border-color: rgba(231,76,60,0.25);
            color: #e74c3c;
        }

        .like-count {
            color: #666;
            font-size: 14px;
        }

        /* Comment section styles */
        .comments-section {
            margin-top: 15px;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .comments-header {
            font-size: 13px;
            font-weight: 600;
            color: #666;
            margin-bottom: 12px;
        }

        .comments-list {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 12px;
        }

        .comment-item {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            flex-shrink: 0;
        }

        .comment-content {
            flex: 1;
            min-width: 0;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }

        .comment-username {
            font-weight: 600;
            color: #262626;
            font-size: 13px;
        }

        .comment-text {
            color: #262626;
            font-size: 13px;
            line-height: 1.4;
            word-break: break-word;
        }

        .comment-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 6px;
            font-size: 12px;
            color: #999;
        }

        .comment-time {
            cursor: help;
            text-decoration: underline wavy #ddd;
        }

        .comment-delete-btn {
            background: none;
            border: none;
            color: #e74c3c;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            padding: 0;
            transition: color 0.2s;
        }

        .comment-delete-btn:hover {
            color: #c0392b;
        }

        /* Comment form */
        .comment-form {
            display: flex;
            gap: 8px;
            align-items: flex-end;
        }

        .comment-form-group {
            flex: 1;
            position: relative;
        }

        .comment-input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 20px;
            font-size: 13px;
            font-family: inherit;
            resize: none;
            max-height: 100px;
            transition: border-color 0.2s;
        }

        .comment-input:focus {
            outline: none;
            border-color: #833AB4;
            box-shadow: 0 0 0 2px rgba(131, 58, 180, 0.1);
        }

        .comment-submit-btn {
            background: #833AB4;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .comment-submit-btn:hover:not(:disabled) {
            background: #6d2c8c;
            transform: scale(1.05);
        }

        .comment-submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .not-logged-comment-msg {
            font-size: 13px;
            color: #999;
            text-align: center;
            padding: 12px;
            background: #f9f9f9;
            border-radius: 12px;
        }



         .no-posts {
             background: white;
             border-radius: 15px;
             padding: 60px 20px;
             box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
             margin-top: 20px;

             display: flex;
             flex-direction: column;
             align-items: center;
             justify-content: center;
             text-align: center;
         }

            .no-posts i {
                font-size: 64px;
                color: #833AB4;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .no-posts p {
                font-size: 18px;
                margin-bottom: 20px;
            }

            .not-logged-in {
                background: white;
                border-radius: 15px;
                padding: 60px 30px;
                text-align: center;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            }

            .not-logged-in h2 {
                color: #333;
                font-size: 28px;
                margin-bottom: 20px;
                font-weight: 700;
            }

            .not-logged-in p {
                color: #666;
                font-size: 16px;
                margin-bottom: 30px;
            }

            @media (max-width: 768px) {
                .container-main {
                    padding: 10px;
                    margin: 20px auto;
                }

                .post-image-container {
                    height: 250px;
                }

                .welcome-section h1 {
                    font-size: 24px;
                }

                .nav-right {
                    gap: 10px;
                }

                .btn-create-post,
                .btn-logout {
                    padding: 6px 12px;
                    font-size: 12px;
                }
            }


    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="home">Mini Instagram</a>

            <button class="navbar-lg-toggler navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>




            <div class="collapse navbar-collapse" id="navbarNav">

                    <form action="search" method="GET" class="d-flex me-auto my-2 my-lg-0">
                        <input class="form-control me-2" type="search" name="query" placeholder="Tìm kiếm..." aria-label="Search" required>
                        <button class="btn btn-outline-secondary  btn-sm" type="submit">Tìm</button>
                    </form>


                <ul class="navbar-nav ms-lg-3 ms-auto align-items-center flex-row gap-3">
                    <%
                        igmini.model.User user = (igmini.model.User) session.getAttribute("user");
                        if (user != null) {
                    %>
                    <li class="nav-item">
                        <span class="text-white user-info">
                            <i class="fas fa-user-circle"></i> <%= user.getUsername() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a href="create-post" class="btn btn-primary btn-sm btn-create-post">
                            <i class="fas fa-plus"></i> Đăng bài
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="logout" class="btn btn-outline-danger btn-sm btn-logout">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </li>
                    <%
                    } else {
                    %>
                    <li class="nav-item">
                        <a href="login.jsp" class="btn btn-outline-light btn-sm btn-login">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </a>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-main">
        <%
            if (user != null) {
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
                    <a href="profile?userId=<%= p.getUser_id() %>">
                        <img src="${pageContext.request.contextPath}/<%= (p.getAvatar_url() != null && !p.getAvatar_url().isEmpty()) ? p.getAvatar_url() : "default-avatar.png" %>"
                             onerror="this.src='https://ui-avatars.com/api/?name=<%= p.getUsername() %>'"
                             style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;" class="me-2 border">
                     </a>

                    <a href="profile?userId=<%= p.getUser_id() %>" class="text-decoration-none fw-bold text-dark">
                        <%= p.getUsername() %>
                    </a>

                    <% if (user.getId() == p.getUser_id()) { %>
                    <a href="delete-post?id=<%= p.getId() %>"
                       class="btn btn-danger btn-sm ms-auto"
                       style="background:#e74c3c; border:none;"
                       onclick="return confirm('Bạn có chắc muốn xóa không?')">
                        Xóa
                    </a>
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
                          <button type="button" class='like-button <%= liked ? "liked" : "" %>' data-postid="<%= p.getId() %>">
                             <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"></i>
                             <span><%= liked ? "Liked" : "Thích" %></span>
                          </button>
                          <div class="like-count"><%= likeCount %> lượt thích</div>
                     </div>

                     <div class="post-caption" style="color:#222;">
                         <%= p.getCaption() %>
                     </div>
                     <div class="post-meta">
                         <i class="fas fa-clock"></i>
                         <span style="color:#555;">
                             <%= p.getCreatedAt() != null ? p.getCreatedAt().toString() : "" %>
                         </span>
                     </div>

                     <!-- Comment Section -->
                     <%
                         CommentDAO commentDAO = new CommentDAOImpl();
                         List<Comment> comments = commentDAO.getCommentsByPostId(p.getId());
                         int commentCount = comments.size();
                     %>
                     <div class="comments-section">
                         <% if (commentCount > 0) { %>
                         <div class="comments-header">
                             <i class="fas fa-comments" style="color:#833AB4; margin-right:5px;"></i>
                             <%= commentCount %> bình luận
                         </div>
                         <div class="comments-list">
                             <% for (Comment cmt : comments) { %>
                             <div class="comment-item">
                                 <img src="https://ui-avatars.com/api/?name=<%= cmt.getUsername() %>"
                                      alt="<%= cmt.getUsername() %>" class="comment-avatar">
                                 <div class="comment-content">
                                     <div class="comment-header">
                                         <span class="comment-username"><%= cmt.getUsername() %></span>
                                     </div>
                                     <div class="comment-text"><%= cmt.getContent() %></div>
                                     <div class="comment-meta">
                                         <span class="comment-time" title="<%= cmt.getCreated_at() %>">
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

                         <!-- Comment Form -->
                         <% if (user != null) { %>
                         <div class="comment-form">
                             <div class="comment-form-group">
                                 <textarea class="comment-input"
                                          placeholder="Viết bình luận..."
                                          data-postid="<%= p.getId() %>"
                                          rows="1"
                                          maxlength="500"></textarea>
                             </div>
                             <button class="comment-submit-btn" onclick="submitComment(<%= p.getId() %>)">
                                 <i class="fas fa-paper-plane"></i>
                             </button>
                         </div>
                         <% } else { %>
                         <div class="not-logged-comment-msg">
                             <a href="login.jsp" style="color:#833AB4; text-decoration:none;">Đăng nhập</a> để bình luận
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
                <i class="fas fa-images"></i>
                <p>Chưa có bài viết nào</p>
                 <a href="create_post.jsp" class="btn-create-post">
                     <i class="fas fa-plus-circle"></i> Tạo bài viết đầu tiên
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
            <a href="login.jsp" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Đăng nhập ngay
            </a>
        </div>
        <%
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // AJAX like button: send request to /like and update UI without reload
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.like-button').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    var postId = btn.getAttribute('data-postid');
                    if (!postId) return;
                    fetch('like?postId=' + encodeURIComponent(postId), {
                        method: 'GET',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    }).then(function(res) {
                        if (res.status === 401) {
                            window.location = 'login.jsp';
                            return null;
                        }
                        return res.json();
                    }).then(function(data) {
                        if (!data) return;
                        var liked = !!data.liked;
                        var count = data.count || 0;
                        if (liked) {
                            btn.classList.add('liked');
                            var icon = btn.querySelector('i'); if (icon) icon.className = 'fas fa-heart';
                            var txt = btn.querySelector('span'); if (txt) txt.textContent = 'Liked';
                        } else {
                            btn.classList.remove('liked');
                            var icon = btn.querySelector('i'); if (icon) icon.className = 'far fa-heart';
                            var txt = btn.querySelector('span'); if (txt) txt.textContent = 'Thích';
                        }
                        var container = btn.parentElement;
                        var countElem = container.querySelector('.like-count');
                        if (countElem) countElem.textContent = count + ' lượt thích';
                    }).catch(function(err) {
                        console.error('Like request failed', err);
                    });
                });
            });

            // Auto-expand textarea when typing
            document.querySelectorAll('.comment-input').forEach(function(textarea) {
                textarea.addEventListener('input', function(e) {
                    this.style.height = 'auto';
                    this.style.height = Math.min(this.scrollHeight, 100) + 'px';
                });
            });
        });

        // Submit comment via AJAX
        // 1. Hàm thêm bình luận
        function submitComment(postId) {
            var textarea = document.querySelector('textarea[data-postid="' + postId + '"]');
            var content = textarea.value.trim();

            if (!content) {
                alert('Vui lòng nhập bình luận');
                return;
            }

            // FIX: Tìm button đúng - button là sibling của div.comment-form-group, không phải sibling của textarea
            var btn = textarea.closest('.comment-form').querySelector('.comment-submit-btn');
            btn.disabled = true;
            btn.textContent = '...';

            // Sử dụng URLSearchParams thay cho FormData để request.getParameter() đọc được
            var params = new URLSearchParams();
            params.append('post_id_comment', postId); // Đã khớp với tham số trong Servlet của bạn
            params.append('content', content);

            fetch('comment', {
                method: 'POST',
                body: params,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            }).then(function(res) {
                if (res.status === 401) {
                    window.location = 'login.jsp';
                    return null;
                }
                return res.json();
            }).then(function(data) {
                if (!data) return;

                if (data.success) {
                    // Tải lại trang để cập nhật danh sách bình luận mới từ DB
                    location.reload();
                } else {
                    alert('Lỗi khi thêm bình luận: ' + (data.error || 'Unknown error'));
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                }
            }).catch(function(err) {
                console.error('Comment request failed', err);
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                alert('Lỗi khi gửi bình luận');
            });
        }

        // 2. Hàm xóa bình luận (Đã sửa lỗi biến content và id gửi đi)
        function deleteComment(commentId, postId) {
            if (!confirm('Bạn có chắc muốn xóa bình luận này?')) return;

            // Sử dụng URLSearchParams đồng bộ dữ liệu chuẩn x-www-form-urlencoded
            var params = new URLSearchParams();
            params.append('comment_id', commentId); // Gửi chính xác ID của comment cần xóa lên Server

            // Gọi chính xác đến Servlet xóa bình luận (comment-delete)
            fetch('comment-delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params
            }).then(function(res) {
                return res.json();
            }).then(function(data) {
                if (data && data.success) {
                    // Xóa thành công thì reload lại trang để mất dòng comment đó
                    location.reload();
                } else {
                    alert('Lỗi khi xóa bình luận');
                }
            }).catch(function(err) {
                console.error('Delete comment failed', err);
                alert('Lỗi khi xóa bình luận');
            });
        }
    </script>
    </script>


</body>
</html>