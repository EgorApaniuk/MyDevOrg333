 /**
 * description  Trigger handler for Task obj
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public with sharing class TaskTriggerHandler {

    private static final String TASK_OWNER_CHANGE_TITLE = 'Task Owner Change';
    private static final String TASK_OWNER_CHANGE_BODY = 'You are now the owner of task: ';

    private List<Task> newRecords;
    private Map<Id, Task> newMap;
    private Map<Id, Task> oldMap;
    private BellNotificationService bellNotificationService = new BellNotificationService();

    public TaskTriggerHandler(List<Task> newRecords, Map<Id, Task> newMap, Map<Id, Task> oldMap) {
        this.newRecords = newRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    public void afterUpdate () {
        sendBellNotification();
    }

    /**
     * description  Sends Bell Notification in 2 scenarios:
     *              1) when the owner reassignes Task by himself - Notification goes to the new owner
     *              2) when the Task is reassigned by someone else - Notification goes to the new and old owner
     * @author      Egor Apaniuk
     * @since       30/01/2024
     */
    private void sendBellNotification() {

        for (Task newTask : newRecords) {
            Task oldTask = oldMap.get(newTask.Id);
            if (newTask.OwnerId != oldTask.OwnerId) {
                Set<String> recepients = new Set<String>();
                recepients.add(newTask.OwnerId);

                bellNotificationService.sendBellNotification(
                    TASK_OWNER_CHANGE_TITLE,
                    TASK_OWNER_CHANGE_BODY + newTask.Subject,
                    newTask.Id,
                    recepients
                );
                if (newTask.OwnerId != UserInfo.getUserId()) {
                    bellNotificationService.sendBellNotification(
                        TASK_OWNER_CHANGE_TITLE,
                        'Task: ' + newTask.Subject + ' has been reassigned to a new owner.',
                        newTask.Id,
                        recepients
                    );
                }
            }
        }
    }
}
