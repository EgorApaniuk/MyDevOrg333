/**
 * description  Apex Controller for readerSummary LWC
 * @author      Egor Apaniuk
 * @since       14/02/2024
 */
public with sharing class ReaderBookSummaryController {

    /**
     * description
     * @author              Egor Apaniuk
     * @since               14/02/2024
     * @param   readerId    Id
     * @return  summary     ReaderSummary
     */
    @AuraEnabled(cacheable=true)
    public static ReaderSummary getReaderSummary(Id readerId) {
        List<Id> readerIds = new List<Id>{readerId};

        ReaderSummary summary = new ReaderSummary();

        summary.activeRBRCount = ReaderBookRelationshipDAO.getActiveNumberByReaderId(readerIds);
        summary.totalRBRCount = ReaderBookRelationshipDAO.getNumberByReaderId(readerIds);

        return summary;
    }

    /**
     * description          handles "Close Active Talons" button for one Reader
     * @author              Egor Apaniuk
     * @since               21/02/2024
     * @param   readerId    Id
     */
    @AuraEnabled
    public static void handleCloseActiveBRBs(Id readerId) { //? QUESTION: how to handle empty/null readerId input better?
        List<Id> readerIds = new List<Id>{readerId};

        List<Reader_Book_Relationship__c> activeRBRs = ReaderBookRelationshipDAO.getActiveByReaderId(readerIds);
        for (Reader_Book_Relationship__c brb : activeRBRs) {
            brb.Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_COMPLETE;
        }
        try {
            update activeRBRs;
        } catch (Exception e) {
            System.debug('exception throwed: ' + e);
        }
    }


    @TestVisible private class ReaderSummary {
        @AuraEnabled
        public Integer activeRBRCount { get; set; }
        @AuraEnabled
        public Integer totalRBRCount { get; set; }
    }
}
