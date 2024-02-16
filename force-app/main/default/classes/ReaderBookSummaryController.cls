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

        summary.currentlyReadingCount = ReaderBookRelationshipDAO.getActiveBooksNumberByReaderId(readerId);
        summary.totalReadCount = ReaderBookRelationshipDAO.getAllBooksNumberByReaderId(readerId);

        return summary;
    }

    @TestVisible private class ReaderSummary {  //? вопрос - можно ли использовать тествизибл?
        @AuraEnabled
        public Integer currentlyReadingCount { get; set; }
        @AuraEnabled
        public Integer totalReadCount { get; set; }
    }
}
