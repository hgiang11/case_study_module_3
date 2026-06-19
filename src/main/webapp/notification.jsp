<%@ page import="igmini.model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Thông báo của bạn</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5" style="max-width: 600px;">
  <div class="card shadow-sm border-0" style="border-radius: 15px;">
    <div class="card-header bg-white py-3 d-flex align-items-center gap-2">
      <a href="${pageContext.request.contextPath}/home" class="text-dark"><i class="fas fa-arrow-left"></i></a>
      <h5 class="mb-0 fw-bold">Thông báo</h5>
    </div>
    <div class="card-body p-0">
      <%
        List<Notification> notiList = (List<Notification>) request.getAttribute("notiList");
        if (notiList != null && !notiList.isEmpty()) {
          for (Notification n : notiList) {

            // 🚨 TRƯỜNG HỢP 1: THÔNG BÁO TỪ HỆ THỐNG / ADMIN (Bảo mật tuyệt đối danh tính)
            if ("SYSTEM_DELETE".equals(n.getType()) || "REPORT".equals(n.getType()) || n.getSenderId() == 0) {

              // Tùy biến màu sắc giao diện theo từng loại hình phạt
              String bgColor = "#fff2f2"; // Đỏ nhạt cho xóa bài
              String iconColor = "text-danger";
              String badgeText = "Ban quản trị hệ thống";

              if ("REPORT".equals(n.getType())) {
                bgColor = "#fff9e6"; // Vàng nhạt cảnh báo cho bài viết bị báo cáo
                iconColor = "text-warning";
                badgeText = "Cảnh báo hệ thống";
              }
      %>
      <div class="p-3 d-flex align-items-center justify-content-between border-bottom <%= n.isRead() ? "" : "bg-light fw-bold" %>" style="background-color: <%= bgColor %>;">
        <div class="d-flex align-items-center gap-3">
          <div style="width: 45px; height: 45px; border-radius: 50%; overflow:hidden; background: #fff; display:flex; align-items:center; justify-content:center; border: 1px solid #eee;">
            <i class="fas fa-user-shield <%= iconColor %>" style="font-size: 20px;"></i>
          </div>

          <div>
            <span class="<%= iconColor %> fw-bold"><%= badgeText %></span>
            <div class="text-dark small my-1"><%= n.getContent() != null ? n.getContent() : "" %></div>
            <div class="text-muted small fw-normal">
              <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0, 16) : "" %>
            </div>
          </div>
        </div>

        <%-- Nếu chỉ là cảnh báo REPORT (bài viết chưa bị xóa), vẫn cho user bấm vào xem lại bài viết của họ --%>
        <% if ("REPORT".equals(n.getType()) && n.getPostId() != null) { %>
        <a href="${pageContext.request.contextPath}/report?id=<%= n.getPostId() %>" class="btn btn-sm btn-outline-warning rounded-pill">Xem bài</a>
        <% } %>
      </div>
      <%


      } else {
        // 👥 TRƯỜNG HỢP 2: THÔNG BÁO TỪ NGƯỜI DÙNG KHÁC (LIKE, COMMENT, FOLLOW)
      %>
      <div class="p-3 d-flex align-items-center justify-content-between border-bottom <%= n.isRead() ? "" : "bg-light fw-bold" %>">
        <div class="d-flex align-items-center gap-3">
          <div style="width: 45px; height: 45px; border-radius: 50%; overflow:hidden; background: #eee; display:flex; align-items:center; justify-content:center;">
            <% if (n.getSenderAvatarUrl() != null && !n.getSenderAvatarUrl().isEmpty()) { %>
            <img src="${pageContext.request.contextPath}/<%= n.getSenderAvatarUrl() %>" style="width:100%; height:100%; object-fit:cover;">
            <% } else { %>
            <i class="fas fa-user text-muted"></i>
            <% } %>
          </div>

          <div>
            <span class="text-primary">
              <%= n.getSenderUsername() != null ? "@" + n.getSenderUsername() : "@User" %>
            </span>

            <% if ("LIKE".equals(n.getType())) { %>
            đã thích bài viết của bạn.
            <% } else if ("COMMENT".equals(n.getType())) { %>
            đã bình luận về bài viết của bạn.
            <% } else if ("FOLLOW".equals(n.getType())) { %>
            đã bắt đầu theo dõi bạn.
            <% } %>

            <% if(n.getContent() != null && !n.getContent().isEmpty() && !"LIKE".equals(n.getType()) && !"FOLLOW".equals(n.getType())) { %>
            <div class="text-secondary small fst-italic mt-1">"<%= n.getContent() %>"</div>
            <% } %>

            <div class="text-muted small fw-normal">
              <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0, 16) : "" %>
            </div>
          </div>
        </div>

        <%-- Kiểm tra an toàn: Nếu là loại SYSTEM_DELETE thì bài viết đã mất, không hiện nút Xem bài nữa --%>
        <% if (n.getPostId() != null && !"SYSTEM_DELETE".equals(n.getType())) { %>
        <a href="${pageContext.request.contextPath}/post-detail?id=<%= n.getPostId() %>" class="btn btn-sm btn-outline-secondary rounded-pill">Xem</a>
        <%-- 🚨 ĐOẠN CHÈN THÊM: Chỉ hiển thị nút Xem Profile khi đây KHÔNG PHẢI thông báo cưỡng chế xóa bài từ hệ thống --%>
        <% } else if (!"SYSTEM_DELETE".equals(n.getType())) { %>
        <a href="${pageContext.request.contextPath}/profile?userId=<%= n.getSenderId() %>" class="btn btn-sm btn-outline-primary rounded-pill">Xem Profile</a>
        <% } %>
      </div>
      <%
          }
        }
      } else {
      %>
      <div class="text-center p-5 text-muted">
        <i class="far fa-bell" style="font-size: 40px; opacity:0.5;"></i>
        <p class="mt-2 mb-0">Bạn chưa có thông báo nào mới.</p>
      </div>
      <% } %>
    </div>
  </div>
</div>
</body>
</html>