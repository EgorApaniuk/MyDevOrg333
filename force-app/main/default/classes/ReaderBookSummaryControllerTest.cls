/**
 * description  Test Class for ReaderBookSummaryController
 * @author      Egor Apaniuk
 * @since       14/02/2024
 */
@isTest
private class ReaderBookSummaryControllerTest {
    @isTest
    static void testGetReaderSummary() {
        Reader__c testReader = new Reader__c(Name = 'Test Reader');
        insert testReader;

        List<Book__c> testBooks = new List<Book__c>{
            new Book__c(Name = 'Book 1'),
            new Book__c(Name = 'Book 2'),
            new Book__c(Name = 'Book 3')
        };
        insert testBooks;

        List<Reader_Book_Relationship__c> testRelationships = new List<Reader_Book_Relationship__c>{
            new Reader_Book_Relationship__c(Reader__c = testReader.Id, Book__c = testBooks[0].Id, Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE),
            new Reader_Book_Relationship__c(Reader__c = testReader.Id, Book__c = testBooks[1].Id, Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE),
            new Reader_Book_Relationship__c(Reader__c = testReader.Id, Book__c = testBooks[2].Id, Status__c = Constants.READER_BOOK_RELATIONSHIP_STATUS_COMPLETE)
        };
        insert testRelationships;

        ReaderBookSummaryController.ReaderSummary result = ReaderBookSummaryController.getReaderSummary(testReader.Id);

        System.assertEquals(2, result.activeRBRCount, 'Incorrect currently reading count');
        System.assertEquals(3, result.totalRBRCount, 'Incorrect total read count');
    }
}
