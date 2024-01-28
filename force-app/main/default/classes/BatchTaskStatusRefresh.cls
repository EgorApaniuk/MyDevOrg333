public with sharing class BatchTaskStatusRefresh implements Database.Batchable<SObject>, Database.Stateful {
    /* Database.AllowsCallouts */

    private Integer transactionCount;
    private Integer processedTasksCount;
    private String ownerId;

    public BatchTaskStatusRefresh(String ownerId) { // а вот и конструктор
        this.ownerId = ownerId;
        this.processedTasksCount = 0;
        this.transactionCount = 0;
    }

    public BatchTaskStatusRefresh() {
        this.processedTasksCount = 0;
        this.transactionCount = 0;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Status FROM Task WHERE Status != \'Completed\' AND Status != \'Overdue\' AND ActivityDate < TODAY';

        if (ownerId != null && ownerId != '') {
            query += ' AND OwnerId = \'' + ownerId + '\'';
        }

        return Database.getQueryLocator(query); // 50 millionovv
    }

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

    public void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // email.setToAddresses(new String[] {'egorzeynos@gmail.com'});
        email.setSubject('Batch Job Completed');
        email.setHtmlBody('The batch job has processed ' + processedTasksCount + '<br> tasks. Transactions: ' + transactionCount);
        email.setTargetObjectId('005WV000000AmubYAC');
        email.setSaveAsActivity(false);
        List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); //limit???
        if (!sendEmailResults[0].success) {
            System.debug(sendEmailResults[0].errors[0].message);
            System.debug('error occured!');
        } else {
            System.debug(sendEmailResults[0].success);
        }
    }
}



// BatchTaskStatusRefresh batchJob = new BatchTaskStatusRefresh();
// ID batchprocessid = Database.executeBatch(batchJob);
// AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
// FROM AsyncApexJob WHERE ID =: batchprocessid ];


// String ownerId = '';
// BatchTaskStatusRefresh batchJob = new BatchTaskStatusRefresh(ownerId);
// Database.executeBatch(batchJob, 1);