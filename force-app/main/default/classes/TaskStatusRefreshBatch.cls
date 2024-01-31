/**
 * description  Service class to execute Bell Notifications
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
public with sharing class TaskStatusRefreshBatch implements Database.Batchable<SObject>, Database.Stateful {

    private Integer transactionCount = 0;
    private Integer processedTasksCount = 0;
    private String ownerId;

    public TaskStatusRefreshBatch(String ownerId) {
        this.ownerId = ownerId;
    }

    public TaskStatusRefreshBatch() {}

    /**
     * description  Start method for batch. Gets expired Tasks.
     * @author      Egor Apaniuk
     * @since       30/01/2024
     */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Status FROM Task WHERE Status != \'Completed\' AND Status != \'Overdue\' AND ActivityDate < TODAY';

        if (ownerId != null && ownerId != '') {
            query += ' AND OwnerId = \'' + ownerId + '\'';
        }

        return Database.getQueryLocator(query); // limit = 50 000 000 records
    }

    /**
     * description  Execute method for batch. Sets Overdue status to expired tasks.
     * @author      Egor Apaniuk
     * @since       30/01/2024
     */
    public void execute(Database.BatchableContext BC, List<Task> overdueTasks) {
        List<Task> tasksToUpdate = new List<Task>();
        for (Task task : overdueTasks) {
            task.Status = 'Overdue';
            tasksToUpdate.add(task);
            processedTasksCount++;
        }

        update tasksToUpdate;
        transactionCount++;
    }

    /**
     * description  Execute method for batch. Sends an email to admin's User.Email
     *              It allows not to record sent emails in the SF limits
     * @author      Egor Apaniuk
     * @since       30/01/2024
     */
    public void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Batch Job Completed');
        email.setHtmlBody('The batch job has processed ' + processedTasksCount + '<br> tasks. Transactions: ' + transactionCount);
        email.setTargetObjectId('005WV000000AmubYAC'); // admin's User Id
        email.setSaveAsActivity(false);
        List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        if (!sendEmailResults[0].success) {
            System.debug(sendEmailResults[0].errors[0].message);
            System.debug('error occured!');
        } else {
            System.debug(sendEmailResults[0].success);
        }
    }
}


// TaskStatusRefreshBatch batchJob = new TaskStatusRefreshBatch();
// ID batchprocessid = Database.executeBatch(batchJob);
// AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
// FROM AsyncApexJob WHERE ID =: batchprocessid ];


// String ownerId = '';
// TaskStatusRefreshBatch batchJob = new TaskStatusRefreshBatch(ownerId);
// Database.executeBatch(batchJob, 1);