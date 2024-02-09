/**
 * description  Reader_Book_Relationship__c Handler Class, used by Reader_Book_Relationship__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
public with sharing class ReaderBookRelashionshipTriggerHandler {
    //api name - reader book, label talon

    private List<Reader_Book_Relationship__c> newRecords;
    private Map<Id, Reader_Book_Relationship__c> newMap;
    private Map<Id, Reader_Book_Relationship__c> oldMap;

    /**
     * description  Class constructor
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public ReaderBookRelashionshipTriggerHandler(List<Reader_Book_Relationship__c> newRecords,
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
        // checkDuplicateTalon();
        checkDuplicateTalonGPT();
    }

    /**
     * description  duplicate finder done by chat gpt
     *              uses unique string readerId+bookId value to identify duplicates
     * @author      Egor Apaniuk
     * @since       09/02/2024
     */
    private void checkDuplicateTalon() {
        Set<Id> bookIds = new Set<Id>();
        Set<Id> readerIds = new Set<Id>();

        for (Reader_Book_Relationship__c relationship : newRecords) {
            bookIds.add(relationship.Book__c);
            readerIds.add(relationship.Reader__c);
        }

        List<Reader_Book_Relationship__c> existingRelationships = [
            SELECT Id, Status__c
            FROM Reader_Book_Relationship__c
            WHERE Book__c IN :bookIds
            AND Reader__c IN :readerIds
        ];

        Set<String> existingRelationshipKeySet = new Set<String>();

        for (Reader_Book_Relationship__c existingRelationship : [
            SELECT Reader__c, Book__c
            FROM Reader_Book_Relationship__c
            WHERE Status__c = 'Active'
        ]) {
            existingRelationshipKeySet.add(existingRelationship.Reader__c + '-' + existingRelationship.Book__c);
        }

        for (Reader_Book_Relationship__c newRelationship : newRecords) {
            String newRelationshipKey = newRelationship.Reader__c + '-' + newRelationship.Book__c;
            if (existingRelationshipKeySet.contains(newRelationshipKey)) {
                System.debug('Found duplicate!');
            }
        }
    }
}