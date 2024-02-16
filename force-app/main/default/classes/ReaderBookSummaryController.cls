/**
 * description  Apex Controller for readerSummary LWC
 * @author      Egor Apaniuk
 * @since       14/02/2024
 */
public with sharing class ReaderBookSummaryController {

    /**
     * description  
     * @author      Egor Apaniuk
     * @since       14/02/2024
     * @param       123
     * @return      123
     */
    @AuraEnabled(cacheable=true)
    public static ReaderSummary getReaderSummary(Id readerId) {
        ReaderSummary summary = new ReaderSummary();
        //перенести соклы в ДАО
        summary.currentlyReadingCount = [SELECT COUNT() FROM Reader_Book_Relationship__c
                                         WHERE Reader__c = :readerId AND Status__c = 'Active'];//TODO добавить константу

        summary.totalReadCount = [SELECT COUNT() FROM Reader_Book_Relationship__c
                                  WHERE Reader__c = :readerId];

        return summary;
    }

    private class ReaderSummary {
        @AuraEnabled
        public Integer currentlyReadingCount { get; set; }
        @AuraEnabled
        public Integer totalReadCount { get; set; }
    }
}
