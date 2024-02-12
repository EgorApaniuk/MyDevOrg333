/**
 * description  Reader_Book_Relationship__c Handler Class, used by Reader_Book_Relationship__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
public with sharing class ReaderBookRelashionshipTriggerHandler {

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

    public void beforeInsert() {
        // checkDuplicateTalon();
    }

    public void beforeUpdate() {
        // checkDuplicateTalon();
    }

    /**
     * description  123
     * @author      Egor Apaniuk
     * @since       09/02/2024
     */
    private void checkDuplicateTalon() {
        
    }
}