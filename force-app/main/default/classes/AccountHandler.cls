/**
 * description  Account Handler Class, used by Account trigger
 * @author      Egor Apaniuk
 * @since       26/01/2024
 */
public with sharing class AccountHandler {
    // TODO привести к общему неймингу все хэндлеры

    public static final String CONTACT_LAST_NAME = 'Something ';
    private List<Account> newRecords;
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;

    public AccountHandler(List<Account> newRecords, Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        this.newRecords = newRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
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
        for (Account acc : this.newRecords) {
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
