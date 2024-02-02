/**
 * description  Test Class for AccountTriggerHandler
 * @author      Egor Apaniuk
 * @since       31/01/2024
 */
@IsTest
public with sharing class AccountTriggerHandlerTest {

    /**
     * description  Setup test method.
     * @author      Egor Apaniuk
     * @since       31/01/2024
     */
    @testSetup
    static void setupTestData() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account testAcc = new Account(Name = 'test' + i, Type = Constants.ACCOUNT_TYPE_PROSPECT);
            accs.add(testAcc);
        }
        insert accs;
    }

    /**
     * description  Positive test method for afterInsert scenario
     * @author      Egor Apaniuk
     * @since       31/01/2024
     */
    @IsTest
    private static void testAfterInsertPositive() {
        String contactNameForSoql = AccountTriggerHandler.CONTACT_LAST_NAME + 'test%';
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName LIKE :contactNameForSoql];

        System.assertEquals(10, contacts.size(), '10 contacts should have been created');
    }
}