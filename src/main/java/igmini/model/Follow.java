package igmini.model;

public class Follow {
    private int follower_id;
    private int following_id;

    public Follow() {
    }

    public Follow(int following_id, int follower_id) {
        this.following_id = following_id;
        this.follower_id = follower_id;
    }

    public int getFollower_id() {
        return follower_id;
    }

    public void setFollower_id(int follower_id) {
        this.follower_id = follower_id;
    }

    public int getFollowing_id() {
        return following_id;
    }

    public void setFollowing_id(int following_id) {
        this.following_id = following_id;
    }
}
