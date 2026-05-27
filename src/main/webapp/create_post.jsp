<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 5/11/2026
  Time: 10:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng bài mới - Mini Instagram</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            background: #000;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        .create-post-container {
            width: 100%;
            max-width: 500px;
            padding: 20px;
        }

        .create-post-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
            padding: 40px;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .create-post-card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 32px;
        }

        .create-post-card h2::before {
            content: "📸 ";
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #555;
            font-weight: 600;
            font-size: 16px;
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 16px;
            resize: vertical;
            min-height: 120px;
            transition: all 0.3s ease;
            font-family: inherit;
            line-height: 1.5;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
            background: #f9f9f9;
        }

        .form-group textarea::placeholder {
            color: #999;
            font-style: italic;
        }

        .file-upload-area {
            position: relative;
            border: 3px dashed #667eea;
            border-radius: 15px;
            padding: 40px 20px;
            text-align: center;
            background: linear-gradient(135deg, #f8f9ff 0%, #e8f2ff 100%);
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 10px;
        }

        .file-upload-area:hover {
            border-color: #764ba2;
            background: linear-gradient(135deg, #f0f2ff 0%, #e0e8ff 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
        }

        .file-upload-area.dragover {
            border-color: #28a745;
            background: linear-gradient(135deg, #f0fff0 0%, #e8ffe8 100%);
        }

        .file-upload-area input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0;
            cursor: pointer;
        }

        .upload-icon {
            font-size: 48px;
            color: #833AB4;
            margin-bottom: 15px;
            transition: color 0.3s ease;
        }

        .file-upload-area:hover .upload-icon {
            color: #F56040;
        }

        .upload-text {
            color: #555;
            font-size: 18px;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .upload-subtext {
            color: #777;
            font-size: 14px;
        }

        .file-preview {
            margin-top: 15px;
            display: none;
        }

        .file-preview img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .file-name {
            margin-top: 10px;
            color: #333;
            font-weight: 500;
            word-break: break-all;
        }

        .btn-create-post {
            width: 100%;
            padding: 15px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 18px;
            font-weight: 700;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
            margin-top: 20px;
        }

        .btn-create-post:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.7);
        }

        .btn-create-post:active {
            transform: translateY(-1px);
        }

        .btn-create-post i {
            margin-right: 8px;
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
        }

        .back-link a {
            color: #0095f6;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .back-link a:hover {
            color: #00d4ff;
        }

        @media (max-width: 576px) {
            .create-post-card {
                padding: 30px 20px;
                margin: 10px;
            }

            .create-post-card h2 {
                font-size: 28px;
                margin-bottom: 25px;
            }

            .file-upload-area {
                padding: 30px 15px;
            }

            .upload-icon {
                font-size: 36px;
            }
        }
    </style>
</head>
<body>
    <div class="create-post-container">
        <div class="create-post-card">
            <h2>Chia sẻ khoảnh khắc</h2>
            <form action="${pageContext.request.contextPath}/create-post" method="post" enctype="multipart/form-data" id="postForm">
                <div class="form-group">
                    <label for="image">Ảnh của bạn:</label>
                    <div class="file-upload-area" id="fileUploadArea">
                        <input type="file" id="image" name="image" accept="image/*" required>
                        <div class="upload-icon">
                            <i class="fas fa-cloud-upload-alt"></i>
                        </div>
                        <div class="upload-text">Kéo thả ảnh vào đây hoặc click để chọn</div>
                        <div class="upload-subtext">Hỗ trợ: JPG, PNG, GIF (tối đa 10MB)</div>
                    </div>
                    <div class="file-preview" id="filePreview">
                        <img id="previewImg" src="" alt="Preview">
                        <div class="file-name" id="fileName"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="caption">Mô tả:</label>
                    <textarea id="caption" name="caption" placeholder="Hãy kể về khoảnh khắc này... ✨" required></textarea>
                </div>

                <button type="submit" class="btn-create-post">
                    <i class="fas fa-share"></i> Chia sẻ ngay
                </button>
            </form>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý preview ảnh
        const imageInput = document.getElementById('image');
        const filePreview = document.getElementById('filePreview');
        const previewImg = document.getElementById('previewImg');
        const fileName = document.getElementById('fileName');
        const fileUploadArea = document.getElementById('fileUploadArea');

        imageInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    filePreview.style.display = 'block';
                    fileName.textContent = file.name;
                    fileUploadArea.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        });

        // Xử lý drag and drop
        fileUploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            fileUploadArea.classList.add('dragover');
        });

        fileUploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
        });

        fileUploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageInput.files = files;
                imageInput.dispatchEvent(new Event('change'));
            }
        });

        // Validation form
        document.getElementById('postForm').addEventListener('submit', function(e) {
            const caption = document.getElementById('caption').value.trim();
            if (caption.length < 5) {
                e.preventDefault();
                alert('Mô tả phải có ít nhất 5 ký tự!');
                return false;
            }
        });
    </script>
</body>
</html>
