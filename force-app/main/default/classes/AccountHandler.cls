public with sharing class AccountHandler {

    private static final String CONTACT_LAST_NAME = 'Something ';

    public static void createRelatedContact(List<Account> newAccounts) {
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : newAccounts) { // bulking
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
