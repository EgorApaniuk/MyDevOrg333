public with sharing class LowPriorityService extends Service {

    public override void createTask() {
        Task task = new Task();
        task.ActivityDate = date.today().addDays(15);
        task.Priority = 'Low';

        insert task;
        System.debug('Low Service executed!!!');
    }
}