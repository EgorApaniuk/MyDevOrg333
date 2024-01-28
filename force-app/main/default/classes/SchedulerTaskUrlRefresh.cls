public class SchedulerTaskUrlRefresh implements Schedulable {
    public void execute(SchedulableContext SC) {
        BatchTaskUrlRefresh batchJob = new BatchTaskUrlRefresh();
        Database.executeBatch(batchJob, 1);
    }

}

//  Schedule the job to run every Friday at 5 AM
//  String jobId = System.schedule('TaskUrlRefreshJob', '0 5 * * FRI', new SchedulerTaskUrlRefresh());



