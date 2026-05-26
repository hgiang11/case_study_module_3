-- ============================================
-- SQL INIT SCRIPT - IgMini Database Schema
-- Best Practice: Normalized 3NF Design
-- ============================================

-- 1. Bảng Users (Người dùng)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Bảng Posts (Bài viết)
CREATE TABLE IF NOT EXISTS posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    caption TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Bảng Likes (Lượt thích)
CREATE TABLE IF NOT EXISTS likes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_like (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Bảng Comments (Bình luận) - NORMALIZED & OPTIMIZED
CREATE TABLE IF NOT EXISTS comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id_comment INT NOT NULL,           -- FK → users.id
    post_id_comment INT NOT NULL,           -- FK → posts.id
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id_comment) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id_comment) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- INDEXES - Tối ưu hiệu năng query
-- ============================================

-- Index cho comments (lấy comments theo post)
CREATE INDEX idx_comments_post_id ON comments(post_id_comment);

-- Index cho comments (lấy comments theo user)
CREATE INDEX idx_comments_user_id ON comments(user_id_comment);

-- Index cho likes (tối ưu lấy likes theo post)
CREATE INDEX idx_likes_post_id ON likes(post_id);

-- Index cho posts (lấy posts theo user)
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- ============================================
-- VIEWS (Optional) - Lấy bình luận kèm tên user
-- ============================================

CREATE OR REPLACE VIEW v_comments_with_username AS
SELECT 
    c.id,
    c.user_id_comment,
    c.post_id_comment,
    c.content,
    c.created_at,
    u.username,
    u.avatar_url
FROM comments c
INNER JOIN users u ON c.user_id_comment = u.id;

-- Usage: SELECT * FROM v_comments_with_username WHERE post_id_comment = 1;

-- ============================================
-- Sample Data (Tùy chọn)
-- ============================================

-- Chèn user test
INSERT INTO users (username, email, password, avatar_url, bio) 
VALUES 
    ('trinhgiang', 'tg@gmail.com', 'hashed_pass_123', 'uploads/avatar_1.jpg', 'Web Developer'),
    ('user2', 'user2@gmail.com', 'hashed_pass_456', NULL, 'Designer');

-- Chèn bài viết
INSERT INTO posts (user_id, image_url, caption) 
VALUES 
    (1, 'uploads/post_1.jpg', 'Beautiful sunset! '),
    (2, 'uploads/post_2.jpg', 'Vacation time ✈️');

-- Chèn bình luận (sử dụng JOIN)
INSERT INTO comments (user_id_comment, post_id_comment, content) 
VALUES 
    (2, 1, 'Amazing shot! ❤️'),
    (1, 2, 'Looks awesome! '),
    (2, 1, 'Where is this place?');

-- Chèn like
INSERT INTO likes (user_id, post_id) 
VALUES 
    (1, 2),
    (2, 1),
    (2, 2);

-- ============================================
-- QUERIES (Ví dụ sử dụng)
-- ============================================

-- Q1: Lấy tất cả comments của bài viết ID=1 (JOIN username)
SELECT 
    c.id,
    c.content,
    c.created_at,
    u.username
FROM comments c
JOIN users u ON c.user_id_comment = u.id
WHERE c.post_id_comment = 1
ORDER BY c.created_at ASC;

-- Q2: Lấy số lượt comment của bài viết
SELECT COUNT(*) AS comment_count
FROM comments
WHERE post_id_comment = 1;

-- Q3: Xóa comment
DELETE FROM comments WHERE id = 1;

-- Q4: Lấy số lượt like của bài viết
SELECT COUNT(*) AS like_count
FROM likes
WHERE post_id = 1;

-- Q5: Kiểm tra user đã like bài viết chưa
SELECT COUNT(*) > 0 AS is_liked
FROM likes
WHERE user_id = 1 AND post_id = 2;

-- ============================================
-- WHY THIS DESIGN IS OPTIMAL
-- ============================================

/*
✅ Normalization (3NF):
   - Không redundant data (username chỉ lưu ở users, không ở comments)
   - Consistent: khi user đổi username, tự động reflect ở tất cả comments

✅ Data Integrity:
   - FOREIGN KEY ensures referential integrity
   - ON DELETE CASCADE: tự động xóa comments khi user/post bị xóa
   - UNIQUE KEY trên likes: tránh user like 1 post nhiều lần

✅ Performance:
   - Indexes trên FK columns: tối ưu JOIN query
   - Smart schema: chỉ lưu ID, có thể JOIN khi cần

✅ Scalability:
   - Dễ mở rộng (thêm followers, notifications, v.v.)
   - Clean separation of concerns
   - Easy to migrate/backup

✅ Code Maintenance:
   - DAO queries rõ ràng, dễ hiểu
   - Model mapping straightforward
   - No duplicated update logic
*/
