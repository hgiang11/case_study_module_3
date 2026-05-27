package igmini.model;

import java.sql.Timestamp;

public class Post {
    private int id;
    private int user_id;
    private String image_url;
    private String caption;
    private Timestamp created_at;
    private String username; // Thêm trường username
    private String avatarUrl; // Thêm trường avatar_url

    public Post(int id, int user_id, String image_url, String caption, Timestamp created_at, String username, String avatarUrl) {
        this.id = id;
        this.user_id = user_id;
        this.image_url = image_url;
        this.caption = caption;
        this.created_at = created_at;
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

    public Post(int user_id, String caption, String image_url) {
        this.user_id = user_id;
        this.caption = caption;
        this.image_url = image_url;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Post(int id, int user_id, String imagePath, String caption, Timestamp created_at) {
        this.id = id;
        this.user_id = user_id;
        this.image_url = imagePath;
        this.caption = caption;
        this.created_at = created_at;
    }
}
