package igmini.model;

import java.sql.Timestamp;

public class Report {
    private int id;
    private int reporter_id;
    private int post_id;
    private int reporter_user_id;
    private String reason;
    private Timestamp created_at;


    private String reporter_name;     // Để nhận giá trị u1.username (reporter_name)
    private String post_caption;
    private String post_image_url;
    private String reportedUsername;

    public String getReporter_name() {
        return reporter_name;
    }

    public void setReporter_name(String reporter_name) {
        this.reporter_name = reporter_name;
    }

    public String getPost_caption() {
        return post_caption;
    }

    public void setPost_caption(String post_caption) {
        this.post_caption = post_caption;
    }

    public String getPost_image_url() {
        return post_image_url;
    }

    public void setPost_image_url(String post_image_url) {
        this.post_image_url = post_image_url;
    }

    public String getReportedUsername() {
        return reportedUsername;
    }

    public void setReportedUsername(String reportedUsername) {
        this.reportedUsername = reportedUsername;
    }

    public Report() {
    }

    public Report(int id, int reporter_id, int post_id, int reporter_user_id, String reason, Timestamp created_at) {
        this.id = id;
        this.reporter_id = reporter_id;
        this.post_id = post_id;
        this.reporter_user_id = reporter_user_id;
        this.reason = reason;
        this.created_at = created_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReporter_id() {
        return reporter_id;
    }

    public void setReporter_id(int reporter_id) {
        this.reporter_id = reporter_id;
    }

    public int getPost_id() {
        return post_id;
    }

    public void setPost_id(int post_id) {
        this.post_id = post_id;
    }

    public int getReporter_user_id() {
        return reporter_user_id;
    }

    public void setReporter_user_id(int reporter_user_id) {
        this.reporter_user_id = reporter_user_id;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }
}
