/**
 * description  Service class to execute Bell Notifications
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public class BellNotificationService {
// TODO get set ???
    private String notificationType = 'StandardNotificationType'; //TODO почитать про принцип DRY - Dont repeat yourself

    private CustomNotificationType customNotificationType {
        get {
            if (customNotificationType == null) {
                customNotificationType = [
                    SELECT Id, DeveloperName
                    FROM CustomNotificationType
                    WHERE DeveloperName =: notificationType
                ];
            }
            return customNotificationType;
        }
        set {}
    }

    public BellNotificationService() {
        System.debug(1);
    }

    public BellNotificationService(String notificationType) {
        System.debug(2);

        this.notificationType = notificationType;
    }

    /**
     * description              Sends Bell Notification
     * @author                  Egor Apaniuk
     * @since                   30/01/2024
     * @param title             String
     * @param body              String
     * @param targetRecordId    Id
     * @param recipientsIds     Set<String>
     */
    public void sendBellNotification(String title, String body, Id targetRecordId, Set<String> recipientsIds) {
    // public void sendBellNotification() {

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(customNotificationType.Id);
        notification.setTargetId(targetRecordId);

        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug(Constants.DEBUG_BELL_NOTIFICATION + e.getMessage());
        }

    }

}
