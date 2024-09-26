/**
 * description  Serive class for sending single email messages for Support
 * @author      Egor Apaniuk
 * @since       08/03/2024
 */
public with sharing class EmailServiceSupport extends EmailService {

    private static final String SUPPORT_AGENT_ROLE = 'CEO'; //! User's role, that will receive an email

    /**
     * description              object constructor. targetObjectId is calculated through DAO
     * @author                  Egor Apaniuk
     * @since                   08/03/2024
     * @param   subjectLabel    String
     * @param   htmlBodyLabel   String
     * @param   saveAsActivity  Boolean
     */
    //? кажется нельзя динамически предоставить название лейбла
    public EmailServiceSupport () {
        this.subject = Label.DuplicatesFound; //^some "email to support agent" label should be used here
        this.htmlBody = Label.DuplicatesFound;
        this.saveAsActivity = false;

        List<User> usersWithRole = UserDAO.getByRole(SUPPORT_AGENT_ROLE);
        this.targetObjectId = usersWithRole[0].Id;
    }
}