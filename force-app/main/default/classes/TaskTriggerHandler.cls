 /**
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public with sharing class TaskTriggerHandler {
    private List<Task> newTasks;
    private Map<Id, Task> newTasksIdS;
    private Map<Id, Task> oldTasksIds;

    public TaskTriggerHandler(List<Task> newTasks, Map<Id, Task> newTaksksIds, Map<Id, Task> oldTasksIds) {
        this.newTasks = newTasks;
        this.newTasksIdS = newTasksIdS;
        this.oldTasksIds = oldTasksIds;
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
            Task oldTask = oldTasksIds.get(task.Id);

            if (task.OwnerId != oldTask.OwnerId) {

                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    'Task Owner Change',
                    'You are now the owner of task: ' + task.Subject,
                    task,
                    task.OwnerId
                );
            } else if (task.OwnerId != UserInfo.getUserId()) {
                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    'Task Owner Change',
                    'You are now the owner of task: ' + task.Subject,
                    task,
                    task.OwnerId
                );

                BellNotificationService.sendBellNotificationTaskOwnerChange(
                    'Task Owner Change',
                    'Task: ' + task.Subject + ' has been reassigned to a new owner.',
                    task,
                    oldTask.OwnerId
                );
            }
        }
    }
}
