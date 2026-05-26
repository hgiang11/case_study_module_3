package igmini.dao;

import igmini.model.User;

import java.util.List;

public interface UserDAO {

    boolean registerUser(User user);
    User checkLogin(String username, String password);
    boolean updateUser(User user);
    User getUserById(int id);
    List<User> searchUsers(String keyword, int currentUserId);


}