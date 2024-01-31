/**
 * description  Account Handler Class, used by triggers
 * @author      Egor Apaniuk
 * @since       26/01/2024
 */
public with sharing class AccountHandler {
//TODO поменять названия переменных (<list>newRecords,newMap, oldMap)
//TODO добавить комментарии
    public static final String CONTACT_LAST_NAME = 'Something ';
    private List<Account> triggerNewAccounts;
    private Map<Id, Account> triggerNewAccountsIds;

    public AccountHandler(List<Account> triggerNewAccounts, Map<Id, Account> triggerNewAccountsIds) {
        this.triggerNewAccounts = triggerNewAccounts;
        this.triggerNewAccountsIds = triggerNewAccountsIds;
    }

    /**
     * description  Executes afterInsert trigger scenario
     * @author      Egor Apaniuk
     * @since       26/01/2024
     */
    public void afterInsert() {
        createRelatedContact();
    }

    /**
     * description  Method creates related Contacts if Account Type = Prospect
     * @author      Egor Apaniuk
     * @since       26/01/2024
     */
    private void createRelatedContact() {
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
