/**
 * description  Test Class for ReaderBookRelationshipTriggerHandler
 * @author      Egor Apaniuk
 * @since       12/02/2024
 */
@isTest
private class ReaderBookRelationshipTriggerHandlerTest {

    /**
     * description  Test Data setup
     * @author      Egor Apaniuk
     * @since       12/02/2024
     */
    @testSetup
    private static void setup() {

        List<Reader__c> readers = new List<Reader__c>();
        readers.add(new Reader__c(Name = 'John'));
        readers.add(new Reader__c(Name = 'Sam'));
        insert readers;

        List<Book__c> books = new List<Book__c>();
        books.add(new Book__c(Name = 'John\'s book'));
        books.add(new Book__c(Name = 'Sam\'s book'));
        insert books;

    }

    /**
     * description  Negative single rbr Insert test.
     * @author      Egor Apaniuk
     * @since       12/02/2024
     */
    @isTest
    static void testBeforeInsert_Duplicate() {

        List<Reader_Book_Relationship__c> activeRbrs = new List<Reader_Book_Relationship__c>();

        List<Reader__c> readers = [SELECT Id FROM Reader__c LIMIT 2];
        List<Book__c> books = [SELECT Id FROM Book__c LIMIT 2];

        for (Reader__c reader : readers) {
            for (Book__c book : books) {
                Reader_Book_Relationship__c rbr = new Reader_Book_Relationship__c(
                    Reader__c = reader.Id,
                    Book__c = book.Id,
                    Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
                );
                activeRbrs.add(rbr);
            }
        }
        insert activeRbrs;

        Reader_Book_Relationship__c duplicateRecord = new Reader_Book_Relationship__c(
            Reader__c = readers[0].Id,
            Book__c = books[0].Id,
            Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
        );


        try {
            insert duplicateRecord;
            System.assert(false, 'Duplicates should have been found, error shoud have been catched');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Duplicates Found'), 'Expected error message not found');
        }

    }

    /**
     * description  Negative multiple rbr Insert test.
     * @author      Egor Apaniuk
     * @since       12/02/2024
     */
    @isTest
    static void testBeforeInsert_Negative() {

        List<Reader_Book_Relationship__c> newRecords = new List<Reader_Book_Relationship__c>();

        List<Reader__c> readers = [SELECT Id FROM Reader__c LIMIT 2];
        List<Book__c> books = [SELECT Id FROM Book__c LIMIT 2];

        for (Reader__c reader : readers) {
            for (Book__c book : books) {
                Reader_Book_Relationship__c rbr = new Reader_Book_Relationship__c(
                    Reader__c = reader.Id,
                    Book__c = book.Id,
                    Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
                );
                newRecords.add(rbr);
            }
        }

        Reader_Book_Relationship__c duplicateRecord = new Reader_Book_Relationship__c(
            Reader__c = readers[0].Id,
            Book__c = books[0].Id,
            Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
        );
        newRecords.add(duplicateRecord);

        insert newRecords;

        List<Reader_Book_Relationship__c> insertedRecords = [
            SELECT Id
            FROM Reader_Book_Relationship__c
            WHERE Status__c =: Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
        ];

        System.assertEquals(4, insertedRecords.size(), 'More records were inserted then expected');
    }
}
