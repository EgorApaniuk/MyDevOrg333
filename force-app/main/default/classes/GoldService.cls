public with sharing class GoldService extends Service {

    static {
        System.debug('sending email to support user from static block');
    }

    public override void createTask() {
        Task task = new Task();
        task.ActivityDate = date.today().addDays(1);
        task.Priority = 'High';

        insert task;
        System.debug('GoldService executed!!!');
    }
}

//котором создается таска с временем обработки 1 день и Priority = high
