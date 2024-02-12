/**
 * description  DAO class for Reader_Book_Relationship__c object
 * @author      Egor Apaniuk
 * @since       12/02/2024
 */
public with sharing class ReaderBookRelationshipDAO {

    /**
     * description      SOQLs RBRs by Readers and Books Ids and Status to find potential active duplicates
     * @param readerIds List<Id>
     * @param booksIds  List<Id>
     * @author          Egor Apaniuk
     * @since           12/02/2024
     */
    public static List<Reader_Book_Relationship__c> getByReaderBooksIds(List<Id> readerIds, List<Id> bookIds) {
        return [
            SELECT Id, Book__c, Reader__c, Status__c
            FROM Reader_Book_Relationship__c
            WHERE Reader__c IN :readerIds
            AND Book__c IN :bookIds
            AND Status__c = :Constants.READER_BOOK_RELATIONSHIP_STATUS_ACTIVE
        ];
    }
}