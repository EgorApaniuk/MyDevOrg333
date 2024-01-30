 /**
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

        for (Task task : newTasks) {
            Task oldTask = oldTasksMap.get(task.Id);
            //перепроверить логику
            if (task.OwnerId != oldTask.OwnerId) {

                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    TASK_OWNER_CHANGE_TITLE,
                    TASK_OWNER_CHANGE_BODY + task.Subject,
                    task,
                    task.OwnerId
                );
            } else if (task.OwnerId != UserInfo.getUserId()) {
                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    TASK_OWNER_CHANGE_TITLE,
                    TASK_OWNER_CHANGE_BODY + task.Subject,
                    task,
                    task.OwnerId
                );

                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    TASK_OWNER_CHANGE_TITLE,
                    'Task: ' + task.Subject + ' has been reassigned to a new owner.',
                    task,
                    oldTask.OwnerId
                );
            }
        }
        //создать мапку с тасками и рецепиентами
    }
}
