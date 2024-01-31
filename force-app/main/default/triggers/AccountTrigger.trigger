/**
 * description  Account trigger, triggers AccountHandler logic
 * @author      Egor Apaniuk
 * @since       26/01/2024
 */
trigger AccountTrigger on Account (after insert) {
    AccountHandler accountHandler = new AccountHandler(Trigger.new, Trigger.newMap, Trigger.oldMap);

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            accountHandler.afterInsert();
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