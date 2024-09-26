public with sharing virtual class Service {
    public virtual void createTask() {
        Task task = new Task();
        task.ActivityDate = date.today().addDays(2);
        task.Priority = 'Normal';

        insert task;
        System.debug('Service executed!!!');
    }

}

//таска с временем обработки 2 дня и Priority = normal
