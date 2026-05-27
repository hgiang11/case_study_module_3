package igmini.dao;

public interface FollowDAO {
    boolean follow(int followerId, int followingId);
    boolean unfollow(int followerId, int followingId);
    boolean isFollowing(int followerId, int followingId);
    int getFollowerCount(int userId); // Đếm số người đang theo dõi user này
    int getFollowingCount(int userId); // Đếm số người mà user này đang theo dõi
}