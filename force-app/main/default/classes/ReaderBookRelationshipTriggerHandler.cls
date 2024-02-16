/**
 * description  Reader_Book_Relationship__c Handler Class, used by Reader_Book_Relationship__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
public with sharing class ReaderBookRelationshipTriggerHandler {

    private List<Reader_Book_Relationship__c> newRecords;
    private Map<Id, Reader_Book_Relationship__c> newMap;
    private Map<Id, Reader_Book_Relationship__c> oldMap;

    /**
     * description  Class constructor
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public ReaderBookRelationshipTriggerHandler(List<Reader_Book_Relationship__c> newRecords,
                                                 Map<Id, Reader_Book_Relationship__c> newMap,
                                                 Map<Id, Reader_Book_Relationship__c> oldMap) {
        this.newRecords = newRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    /**
     * description  beforeInsert scenario handler
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public void beforeInsert() {
        checkDuplicateReaderBookRelationships();
    }

    /**
     * description  beforeUpdate scenario handler
     * @author      Egor Apaniuk
     * @since       12/02/2024
     */
    public void beforeUpdate() {
        checkDuplicateReaderBookRelationships();
    }

    /**
     * description  Method sorts RBRs and in case of duplicate throws an error.
     * @author      Egor Apaniuk
     * @since       09/02/2024
     */
    private void checkDuplicateReaderBookRelationships() {

        // TODO /////////////////////////////////////////////
        Set<Reader_Book_Relationship__c> newRecordsSet = newRecords;

        List<Id> readerIds = new List<Id>();
        List<Id> bookIds = new List<Id>();

        for(Reader_Book_Relationship__c rbr : newRecords) {
            if (rbr.Status__c == Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE) {
                readerIds.add(rbr.Reader__c);
                bookIds.add(rbr.Book__c);
            }
        }

        List<Reader_Book_Relationship__c> potentialDuplicates = ReaderBookRelationshipDAO.getByReaderBooksIds(readerIds, bookIds);
        Map<Id, List<Id>> booksByReader = new Map<Id, List<Id>>();

        for (Reader_Book_Relationship__c rbrDuplicate : potentialDuplicates) {
            if(booksByReader.containsKey(rbrDuplicate.Reader__c)) {
                booksByReader.get(rbrDuplicate.Reader__c).add(rbrDuplicate.Book__c);
            } else {
                booksByReader.put(rbrDuplicate.Reader__c, new List<Id>{rbrDuplicate.Book__c});
            }
        }

        for(Reader_Book_Relationship__c rbr : newRecords) {
            if (booksByReader.containsKey(rbr.Reader__c) && booksByReader.get(rbr.Reader__c).contains(rbr.Book__c)) {
                rbr.addError(Label.DuplicatesFound);
            }
        }
    }
}