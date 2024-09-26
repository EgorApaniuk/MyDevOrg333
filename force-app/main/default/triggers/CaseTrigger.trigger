/**
 * description  Case trigger, triggers CaseTriggerHandler logic
 * @author      Egor Apaniuk
 * @since       08/03/2024
 */
trigger CaseTrigger on Case (after insert) {
    CaseTriggerHandler caseTriggerHandler = new CaseTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            caseTriggerHandler.afterInsert();
        }
    }
}