package igmini.dao;
import igmini.model.Post;

import java.util.List;


public interface PostDAO {
    boolean insertPost(Post post);
    List<Post> getAllPosts();
    List<Post> getPostsByUserId(int userId);
    boolean deletePost(int postId);
    Post getPostById(int id);
    boolean createPost(Post post);


}
