// добавть комментаии
public without sharing class ReaderBookDAO {

    public List<Reader_Book_Relationship__c> getByReaderBooksIds(List<Id> readerIds, List<Id> booksIds) {
        return [
            SELECT Id, Reader__c, Book__c
            FROM Reader_Book_Relationship__c
            WHERE Reader__c IN :readerIds
            AND Book__c IN :booksIds
            AND Status__c = :Constants.READER_BOOK_REL_STATUS_ACTIVE
        ];
    }
}