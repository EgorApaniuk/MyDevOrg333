/**
 * description  Case Handler Class, used by Case trigger
 * @author      Egor Apaniuk
 * @since       08/03/2024
 */
public with sharing class CaseTriggerHandler {

    private static final String CASE_TIER_LOW = 'Low';
    private static final String CASE_TIER_DEFAULT = 'Default';
    private static final String CASE_TIER_GOLD = 'Gold';

    private List<Case> newRecords;
    private Map<Id, Case> newMap;
    private Map<Id, Case> oldMap;

    public CaseTriggerHandler(List<Case> newRecords, Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        this.newRecords = newRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    public void afterInsert() {
        handleService();
    }

    private void handleService() {
        for (Case newCase : newRecords) {
            if (newCase.Tier__c == CASE_TIER_LOW) {

                new ServiceHandler().createTaskFromHandler(new LowPriorityService());

            } else if (newCase.Tier__c == CASE_TIER_DEFAULT) {

                new ServiceHandler().createTaskFromHandler(new Service());
                new EmailServiceSupport().sendEmail();

            } else if (newCase.Tier__c == CASE_TIER_GOLD) {

                new ServiceHandler().createTaskFromHandler(new GoldService());
                new EmailServiceSupport().sendEmail();
            }
        }
    }
}
//* AccountTriggerHandler > SercviceHandler > service > goldService
//* EmailService