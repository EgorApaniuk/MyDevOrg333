/**
 * description  Talon__c Handler Class, used by Talon__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
public with sharing class TalonTriggerHandler {
    //TODO вернуть старый нейминг, для юзера оставить "талон"
    //api name - reader book, label talon

    private List<Talon__c> newRecords;
    private Map<Id, Talon__c> newMap;
    private Map<Id, Talon__c> oldMap;

    /**
     * description  Class constructor
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public TalonTriggerHandler(List<Talon__c> newRecords, Map<Id, Talon__c> newMap, Map<Id, Talon__c> oldMap) {
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
        checkDuplicateTalon();
    }

    // private void checkDuplicateTalon() {
    public void checkDuplicateTalon() {
        List<Id> readerIds = new List<Id>();
        List<Id> bookIds = new List<Id>();
        for (Talon__c talon : newRecords) {
            readerIds.add(talon.Reader__c);
            bookIds.add(talon.Book__c);
        }

        List<Talon__c> duplicateTalons = [
            SELECT Id
            FROM Talon__c
            WHERE Book__c =: bookIds   //pavel
            AND Reader__c =: readerIds //egor
            AND Status__c = 'Active' // add const
        ]
    }
}