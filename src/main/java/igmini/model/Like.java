package igmini.model;

public class Like {
    private int id;
    private int user_id_like;
    private int post_id_like;

    public Like(int id, int user_id_like, int post_id_like) {
        this.id = id;
        this.user_id_like = user_id_like;
        this.post_id_like = post_id_like;
    }

    public Like() {
    }

    public Like(int user_id_like, int post_id_like) {
        this.user_id_like = user_id_like;
        this.post_id_like = post_id_like;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id_like() {
        return user_id_like;
    }

    public void setUser_id_like(int user_id_like) {
        this.user_id_like = user_id_like;
    }

    public int getPost_id_like() {
        return post_id_like;
    }

    public void setPost_id_like(int post_id_like) {
        this.post_id_like = post_id_like;
    }
}
