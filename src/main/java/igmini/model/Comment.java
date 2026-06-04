package igmini.model;

import java.time.LocalDateTime;

public class Comment {
    private int id;
    private int user_id_comment;
    private int post_id_comment;
    private String content;
    private LocalDateTime created_at;
    private String username;


    public Comment() {
    }

    public Comment(int id, int user_id_comment, int post_id_comment, String content, LocalDateTime created_at) {
        this.id = id;
        this.user_id_comment = user_id_comment;
        this.post_id_comment = post_id_comment;
        this.content = content;
        this.created_at = created_at;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id_comment() {
        return user_id_comment;
    }

    public void setUser_id_comment(int user_id_comment) {
        this.user_id_comment = user_id_comment;
    }

    public int getPost_id_comment() {
        return post_id_comment;
    }

    public void setPost_id_comment(int post_id_comment) {
        this.post_id_comment = post_id_comment;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
