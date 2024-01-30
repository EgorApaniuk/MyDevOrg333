/**
 * description  fasddasdasads
 * @author      Egor Apaniuk
 * @since       30/01/2024
 */
trigger TaskTrigger on Task (after update) {
    TaskTriggerHandler taskHandler = new TaskTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            taskHandler.afterUpdate();
        }
    }
}