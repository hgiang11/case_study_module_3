package igmini.model;

import java.sql.Timestamp;
public class Notification {

    private int id;
    private int userId;
    private int senderId;
    private String type;
    private Integer postId; // dùng Integer để có thể nhận giá trị null (khi follow)
    private boolean isRead;
    private Timestamp createdAt;

    private String senderUsername;
    private String senderAvatarUrl;

    private String content;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Notification() {
    }

    public Notification(int id, int userId, int senderId, String type, Integer postId, boolean isRead, Timestamp createdAt, String senderUsername, String senderAvatarUrl) {
        this.id = id;
        this.userId = userId;
        this.senderId = senderId;
        this.type = type;
        this.postId = postId;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.senderUsername = senderUsername;
        this.senderAvatarUrl = senderAvatarUrl;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getSenderUsername() {
        return senderUsername;
    }

    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getSenderAvatarUrl() {
        return senderAvatarUrl;
    }

    public void setSenderAvatarUrl(String senderAvatarUrl) {
        this.senderAvatarUrl = senderAvatarUrl;
    }
}
