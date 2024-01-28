public with sharing class AccountHandler {

    public static final String CONTACT_LAST_NAME = 'Something ';
    private List<Account> triggerNewAccounts;
    private Map<Id, Account> triggerNewAccountsIds;

    public AccountHandler(List<Account> triggerNewAccounts, Map<Id, Account> triggerNewAccountsIds) {
        this.triggerNewAccounts = triggerNewAccounts;
        this.triggerNewAccountsIds = triggerNewAccountsIds;
    }

    public void afterInsert() {
        createRelatedContact();
    }

    private void createRelatedContact() {
        System.debug(this.triggerNewAccountsIds);
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : this.triggerNewAccounts) {
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
