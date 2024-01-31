/**
 * description  Service class to execute Bell Notifications
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public class BellNotificationService {
// TODO get set ???
    private final String STANDARD_NOTIFICATION_TYPE_DEVELOPER_NAME = 'StandardNotificationType';

    private String notificationType; //TODO почитать про принцип DRY - Dont repeat yourself

    public BellNotificationService() {}

    public BellNotificationService(String notificationType) {
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
    public void sendBellNotification(String title, String body, Task task, Id recipient) { // вместо таски надо принимать айди
        //айдишки ресипиентов должны приходить сетом

        CustomNotificationType customNotificationType = new CustomNotificationType(); 
        //customNotificationType вынести это в верх, это же просто разовая инициализация
        String notificationType = this.notificationType != null ? this.notificationType : STANDARD_NOTIFICATION_TYPE_DEVELOPER_NAME;

        customNotificationType = [
            SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName =: notificationType
        ]; //? перенести внутрь конструктора???

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(customNotificationType.Id);
        notification.setTargetId(task.id);

        Set<String> recipients = new Set<String>();
        recipients.add(recipient);
        try {
            notification.send(recipients);
        }
        catch (Exception e) {
            System.debug(Constants.DEBUG_BELL_NOTIFICATION + e.getMessage());
        }

    }

}
