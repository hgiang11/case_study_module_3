package igmini.utils;

/**
 * Helper for a one‑time message stored in the HTTP session.
 * The message is automatically removed after it is read, so it only appears once.
 */
public class FlashMessage {
    private static final String KEY = "FLASH_MESSAGE";

    /** Store a flash message in the session */
    public static void set(jakarta.servlet.http.HttpSession session, String message) {
        if (session != null) {
            session.setAttribute(KEY, message);
        }
    }

    /** Retrieve and remove the flash message from the session */
    public static String get(jakarta.servlet.http.HttpSession session) {
        if (session == null) return null;
        Object obj = session.getAttribute(KEY);
        if (obj instanceof String) {
            session.removeAttribute(KEY);
            return (String) obj;
        }
        return null;
    }
}