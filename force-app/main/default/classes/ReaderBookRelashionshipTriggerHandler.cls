/**
 * description  Reader_Book_Relationship__c Handler Class, used by Reader_Book_Relationship__c trigger
 * @author      Egor Apaniuk
 * @since       07/02/2024
 */
public with sharing class ReaderBookRelashionshipTriggerHandler {
    //api name - reader book, label talon

    private List<Reader_Book_Relationship__c> newRecords;
    private Map<Id, Reader_Book_Relationship__c> newMap;
    private Map<Id, Reader_Book_Relationship__c> oldMap;

    ReaderBookDAO rbDAO = new ReaderBookDAO();

    /**
     * description  Class constructor
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public ReaderBookRelashionshipTriggerHandler(List<Reader_Book_Relationship__c> newRecords,
                                                 Map<Id, Reader_Book_Relationship__c> newMap,
                                                 Map<Id, Reader_Book_Relationship__c> oldMap) {
        this.newRecords = newRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    /**
     * description  beforeInsert scenario handler
     * @author      Egor Apaniuk
     * @since       07/02/2024
     */
    public void beforeInsert() {
        // checkDuplicateTalon();
        // checkDuplicateTalonGPT();
        checkDuplicates();
    }

    /**
     * description  beforeUpdate scenario handler
     * @author      Egor Apaniuk
     * @since       11/02/2024
     */
    public void beforeUpdate() {
        checkDuplicates();
    }

    /**
     * description  check Reader Book Relationship duplicates by Reader, Book and Active status
     * @author      Egor Apaniuk
     * @since       11/02/2024
     */
    public void checkDuplicates() {
        List<Id> readerIds = new List<Id>();
        List<Id> bookIds = new List<Id>();
        for (Reader_Book_Relationship__c rb : newRecords) {
            readerIds.add(rb.Reader__c);
            bookIds.add(rb.Book__c);
        }

        List<Reader_Book_Relationship__c> readerBookPotentialDuplicates = rbDAO.getByReaderBooksIds(readerIds, bookIds);
        Map<Id, List<Id>> booksByReader = new Map<Id, List<Id>>();
                for (Reader_Book_Relationship__c rbDup : readerBookPotentialDuplicates) {
            if (booksByReader.containsKey(rbDup.Reader__c)) {
                booksByReader.get(rbDup.Reader__c).add(rbDup.Book__c);
            } else {
                booksByReader.put(rbDup.Reader__c, new List<Id>{ rbDup.Book__c });
            }
        }

        for (Reader_Book_Relationship__c rb : newRecords) {
            if (booksByReader.containsKey(rb.Reader__c) && booksByReader.get(rb.Reader__c).contains(rb.Book__c)) {
                //перед деплоем добавить кастом лейбл на орг
                rb.addError(Label.ThereAreDuplicates);
            }
        }
    }
}