package igmini.dao;

import igmini.model.Notification;

import java.util.List;

public interface NotificationDAO {
    boolean addNotification(int userId, int senderId, String type, Integer postId);

    List<Notification> getNotificationsByUserId(int userId);
    boolean markAsRead(int userId);
}
