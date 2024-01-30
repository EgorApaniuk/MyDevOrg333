/**
 * description  Service class to execute Bell Notifications
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public class BellNotificationService {

    /**
     * description  Sends Bell Notification
     * @author      Egor Apaniuk
     * @since       30/01/2024
     * @param       Notification title, body, Task object and receipient Id
     */
    public static void sendBellNotificationTaskOwnerChange(String title, String body, Task task, Id recipient) {
        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName = 'TaskOwnerChange'
        ];

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
            System.debug('Problem sending notification: ' + e.getMessage());
        }

    }

}
