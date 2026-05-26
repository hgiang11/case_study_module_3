package igmini.dao;

public interface LikeDAO {
    boolean checkIfUserLiked(int user_id_like, int post_id_like);
    boolean insertLike(int user_id_like, int post_id_like);
    boolean deleteLike(int user_id_like, int post_id_like);
    int getLikeCount(int post_id_like);

}
