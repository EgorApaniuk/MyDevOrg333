/**
 * description  Talon__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
trigger ReaderBookRelashionShipTrigger on Reader_Book_Relationship__c (before insert) {
    ReaderBookRelashionShipTriggerHandler readerBookRelashionShipTriggerHandler = new ReaderBookRelashionShipTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ReaderBookRelashionshipTriggerHandler.beforeInsert();
        }
    }
}