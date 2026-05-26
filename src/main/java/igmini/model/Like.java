package igmini.model;

public class Like {
    private int id;
    private int userIdLike;
    private int postIdLike;

    public Like(int id, int userIdLike, int postIdLike) {
        this.id = id;
        this.userIdLike = userIdLike;
        this.postIdLike = postIdLike;
    }

    public Like() {
    }

    public Like(int userIdLike, int postIdLike) {
        this.userIdLike = userIdLike;
        this.postIdLike = postIdLike;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserIdLike() {
        return userIdLike;
    }

    public void setUserIdLike(int userIdLike) {
        this.userIdLike = userIdLike;
    }

    public int getPostIdLike() {
        return postIdLike;
    }

    public void setPostIdLike(int postIdLike) {
        this.postIdLike = postIdLike;
    }
}
