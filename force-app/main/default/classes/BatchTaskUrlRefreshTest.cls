@isTest
private class BatchTaskUrlRefreshTest {

    @isTest
    static void testBatchExecution() {

        Task testTask = new Task(
            Subject = 'Test Task',
            Pokemon__c = 'charmander',
            Status = 'Not Started'
        );
        insert testTask;


        Test.startTest();
        BatchTaskUrlRefresh batchJob = new BatchTaskUrlRefresh();
        Database.executeBatch(batchJob, 1);
        Test.stopTest();

        Task updatedTask = [SELECT Id, testURL__c FROM Task WHERE Id = :testTask.Id LIMIT 1];
        System.assertEquals('https://pokeapi.co/api/v2/pokemon/4/', updatedTask.testURL__c,
                            'url field wasn\'t updated correclty');
    }
}
