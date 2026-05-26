package igmini.model;

import java.time.LocalDateTime;

public class Comment {
    private int id;
    private int userIdComment;
    private int postIdComment;
    private String content;
    private LocalDateTime createdAt;
    private String username; // Từ JOIN bảng users


    public Comment() {
    }

    public Comment(int id, int userIdComment, int postIdComment, String content, LocalDateTime createdAt) {
        this.id = id;
        this.userIdComment = userIdComment;
        this.postIdComment = postIdComment;
        this.content = content;
        this.createdAt = createdAt;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserIdComment() {
        return userIdComment;
    }

    public void setUserIdComment(int userIdComment) {
        this.userIdComment = userIdComment;
    }

    public int getPostIdComment() {
        return postIdComment;
    }

    public void setPostIdComment(int postIdComment) {
        this.postIdComment = postIdComment;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
