@IsTest
public with sharing class AccountHandlerTest {
//TODO вынести создание аккаунтов в сетап добавить комментарии

    @IsTest
    private static void testAfterInsertPositive() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account testAcc = new Account(Name = 'test' + i, Type = Constants.ACCOUNT_TYPE_PROSPECT);
            accs.add(testAcc);
        }
        insert accs;

        String contactNameForSoql = AccountHandler.CONTACT_LAST_NAME + 'test%';
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName LIKE :contactNameForSoql];

        System.assertEquals(10, contacts.size(), '10 contacts should have been created');
    }
}