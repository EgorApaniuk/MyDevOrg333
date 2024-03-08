/**
 * description  Serive class for sending single email messages
 * @author      Egor Apaniuk
 * @since       08/03/2024
 */
public with sharing virtual class EmailService {

    public String subject;
    public String targetObjectId;
    public Boolean saveAsActivity;
    public String htmlBody;

    public EmailService() {}

    /**
     * description              object constructor method
     * @author                  Egor Apaniuk
     * @since                   08/03/2024
     * @param   subject         String
     * @param   SaveAsActivity  Boolean
     * @param   HtmlBody        String
     * @param   targetObjectId  Id
     */
    public EmailService(String subject, Boolean SaveAsActivity, String HtmlBody, Id targetObjectId) {
        this.subject = subject;
        this.saveAsActivity = saveAsActivity;
        this.htmlBody = htmlBody;
        this.targetObjectId = targetObjectId;
    }

    /**
     * description  Method that executes messaging.sendEmail with provided params
     * @author      Egor Apaniuk
     * @since       08/03/2024
     */
    public virtual void sendEmail() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        email.setTargetObjectId(targetObjectId);
        email.setSaveAsActivity(saveAsActivity);

        List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        if (!sendEmailResults[0].success) {
            System.debug(Constants.DEBUG_EMAIL_NOTIFICATION + sendEmailResults[0].errors[0].message);
        } else {
            System.debug(sendEmailResults[0].success);
        }
    }
}