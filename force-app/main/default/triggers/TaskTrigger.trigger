trigger TaskTrigger on Task (after update) {
    TaskTriggerHandler taskHandler = new TaskTriggerHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            taskHandler.afterUpdate();
        }
    }
}