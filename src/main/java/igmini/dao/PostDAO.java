package igmini.dao;
import igmini.model.Post;

import java.util.List;


public interface PostDAO {
    List<Post> getAllPosts();
    List<Post> getPostsByUserId(int user_id);
    boolean deletePost(int post_id);
    Post getPostById(int id);
    boolean createPost(Post post);

    List<Post> getAllPostsForAdmin();
    List<Post> getReportedPosts();

    boolean deletePostByAdmin(int post_id);

    boolean updatePost(Post post);
}
