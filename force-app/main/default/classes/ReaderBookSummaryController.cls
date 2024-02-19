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
        ReaderSummary summary = new ReaderSummary();

        summary.activeRBRCount = ReaderBookRelationshipDAO.getActiveRBRsNumberByReaderId(readerId);
        summary.totalRBRCount = ReaderBookRelationshipDAO.getAllRBRsNumberByReaderId(readerId);

        return summary;
    }

    @AuraEnabled
    public static void handleCloseActiveBRBs(Id readerId) {
        System.debug('handleCloseActiveBRBs STARTED');
        List<Reader_Book_Relationship__c> activeRBRs = ReaderBookRelationshipDAO.getActiveRBRsByReaderId(readerId);
        for (Reader_Book_Relationship__c brb : activeRBRs) {
            brb.Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_COMPLETE;
        }
        try {
            update activeRBRs;
        } catch (Exception e) {
            System.debug('exception throwed: ' + e);
        }
        System.debug('handleCloseActiveBRBs RAN');
    }


    @TestVisible private class ReaderSummary {  //? вопрос - можно ли использовать тествизибл?
        @AuraEnabled
        public Integer activeRBRCount { get; set; }
        @AuraEnabled
        public Integer totalRBRCount { get; set; }
    }
}
