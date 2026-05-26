package igmini.dao;
import igmini.model.Comment;

import java.util.List;

public interface CommentDAO {
    boolean insertComment(int userId, int postId, String content);
    List<Comment> getCommentsByPostId(int postId);
    boolean deleteComment(int commentId);
    int getCommentCount(int postId);

}
