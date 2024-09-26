
/**
 * description  DAO class for User Object
 * @author      Egor Apaniuk
 * @since       08/03/2024
 */
public with sharing class UserDAO {
    /**
     * description      SOQLs Users by their Role Name
     * @param readerIds List<Id>
     * @param booksIds  List<Id>
     * @author          Egor Apaniuk
     * @since           08/03/2024
     */
    public static List<User> getByRole(String roleName) {
        Id roleId = [SELECT Id FROM UserRole WHERE Name = :roleName LIMIT 1].Id;

        List<User> usersWithRole = [SELECT Id FROM User WHERE UserRoleId = :roleId];

        return usersWithRole;
    }
}