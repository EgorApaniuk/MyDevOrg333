/**
 * description  Talon__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
trigger ReaderBookRelationshipTrigger on Reader_Book_Relationship__c (before insert, before update) {
    ReaderBookRelationshipTriggerHandler readerBookRelationshipTriggerHandler = new ReaderBookRelationshipTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            readerBookRelationshipTriggerHandler.beforeInsert();
        }
        if (Trigger.isUpdate) {
            readerBookRelationshipTriggerHandler.beforeUpdate();
        }
    }
}