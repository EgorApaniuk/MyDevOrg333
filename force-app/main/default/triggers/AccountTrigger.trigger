trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountHandler.createRelatedContact(Trigger.new);
            // добавить в хэндлер реализацию логики по типу триггера
            // добавить передачу oldmap newmap new в хэндлер
        }
    }
}




/* dev console commands for quick test:

List<Account> accs = New List<Account>();
for (Integer i = 0; i < 200; i++){
String accName = 'XxX ' + i;
Account acc = new Account(Name = accName, Type = 'Prospect');
accs.add(acc);
}
insert accs;

List<Account> accsToDelete = [
SELECT Id FROM Account
WHERE Name LIKE '%XxX%'];
delete accsToDelete;

List<Contact> contactsToDelete = [
SELECT Id FROM Contact
WHERE Name LIKE '%XxX%'];
delete contactsToDelete;
*/