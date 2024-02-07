/**
 * description  Talon__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
trigger TalonTrigger on Talon__c (before insert) {
    TalonTriggerHandler talonTriggerHandler = new TalonTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            talonTriggerHandler.beforeInsert();
        }
    }
}