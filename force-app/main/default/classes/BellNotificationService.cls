/**
 * description  Service class to execute Bell Notifications
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public class BellNotificationService {

    private static final String STANDARD_NOTIFICATION_TYPE_DEVELOPER_NAME = 'StandardNotificationType';

    private String notificationType;

    BellNotificationService() {}

    BellNotificationService(String notificationType) {
        this.notificationType = notificationType;
    }

    /**
     * description          Sends Bell Notification
     * @author              Egor Apaniuk
     * @since               30/01/2024
     * @param title         String
     * @param body          String
     * @param task          Task
     * @param receipient    Id
     */
    public static void sendBellNotification(String title, String body, Task task, Id recipient) {
        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName =: STANDARD_NOTIFICATION_TYPE_DEVELOPER_NAME
        ]; // сделать общий notification type

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(task.id);

        Set<String> recipients = new Set<String>();
        recipients.add(recipient);
        try {
            notification.send(recipients);
        }
        catch (Exception e) {
            System.debug(Constants.EXCEPTION_NOTIFICATION_DEBUG + e.getMessage());
        }

    }

}
