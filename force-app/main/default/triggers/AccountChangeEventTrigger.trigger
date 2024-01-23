trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    for (AccountChangeEvent accountChangeEvent : Trigger.new) {
        System.debug('full event debug');
        System.debug(accountChangeEvent);
        System.debug('payload');
        System.debug(accountChangeEvent.ChangeEventHeader);
    }
}

// class testBatch implemets database.Batchable
// start select
// execute (batchable context, record collection,)
// stop/finish