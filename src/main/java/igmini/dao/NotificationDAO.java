package igmini.dao;

import igmini.model.Notification;

import java.util.List;

public interface NotificationDAO {
    boolean addNotification(int userId, int senderId, String type, Integer postId);

    List<Notification> getNotificationsByUserId(int userId);
    boolean markAsRead(int userId);



    boolean createNotification(Notification noti);


    boolean insertAdminNotification(int userId, String type, Integer postId, String content);


    boolean insertSystemNotification(int userId, String type, Integer postId, String content);



    boolean insertSystemNotificationByPostId(int postId, String type, String content);
}





