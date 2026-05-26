package igmini.model;

import java.sql.Timestamp;

public class Post {
    private int id;
    private int userId;
    private String imageUrl;
    private String caption;
    private Timestamp createdAt;
    private String username; // Thêm trường username
    private String avatarUrl; // Thêm trường avatar_url

    public Post(int id, int userId, String imageUrl, String caption, Timestamp createdAt, String username, String avatarUrl) {
        this.id = id;
        this.userId = userId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.createdAt = createdAt;
        this.username = username;
        this.avatarUrl = avatarUrl;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Post() {
    }

    public Post(int userId, String caption, String imageUrl) {
        this.userId = userId;
        this.caption = caption;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Post(int id, int userId, String imagePath, String caption, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.imageUrl = imagePath;
        this.caption = caption;
        this.createdAt = createdAt;
    }
}
