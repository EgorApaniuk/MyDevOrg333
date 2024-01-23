public with sharing class AccountHandler {

    public static final String CONTACT_LAST_NAME = 'Something ';

    public static void afterInsert(List<Account> triggerNewAccounts, Map<Id, Account> triggerNewAccountsIds) {
        createRelatedContact(triggerNewAccounts, triggerNewAccountsIds);
    }

    private static void createRelatedContact(List<Account> newAccounts, Map<Id, Account> newAccountsIds) {
        System.debug(newAccountsIds);
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : newAccounts) {
            if (acc.Type == Constants.ACCOUNT_TYPE_PROSPECT) {
                Contact newContact = new Contact();
                newContact.LastName = CONTACT_LAST_NAME + acc.Name;
                newContact.AccountId = acc.Id;

                newContacts.add(newContact);
            }
        }

        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }

}
