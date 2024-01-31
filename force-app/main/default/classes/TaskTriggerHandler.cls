 /**
 * 
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public with sharing class TaskTriggerHandler {
//TODO переписать по комментам
    private static final String TASK_OWNER_CHANGE_TITLE = 'Task Owner Change';
    private static final String TASK_OWNER_CHANGE_BODY = 'You are now the owner of task: ';
    private List<Task> newTasks;
    private Map<Id, Task> newTasksMap;
    private Map<Id, Task> oldTasksMap;

    BellNotificationService bellNotificationService = new BellNotificationService();

    public TaskTriggerHandler(List<Task> newTasks, Map<Id, Task> newTasksMap, Map<Id, Task> oldTasksMap) {
        this.newTasks = newTasks;
        this.newTasksMap = newTasksMap;
        this.oldTasksMap = oldTasksMap;
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

        for (Task newTask : newTasks) {
            Task oldTask = oldTasksMap.get(newTask.Id);
            if (newTask.OwnerId != oldTask.OwnerId) {
                bellNotificationService.sendBellNotification(
                    TASK_OWNER_CHANGE_TITLE,
                    TASK_OWNER_CHANGE_BODY + newTask.Subject,
                    newTask,
                    newTask.OwnerId
                );
                if (newTask.OwnerId != UserInfo.getUserId()) {
                    bellNotificationService.sendBellNotification(
                        TASK_OWNER_CHANGE_TITLE,
                        'Task: ' + newTask.Subject + ' has been reassigned to a new owner.',
                        newTask,
                        oldTask.OwnerId
                    );
                }
            }
        }
    }
}
