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
        for (Case newCase : newRecords) {
            System.debug('newCase.Tier__c ' + newCase.Tier__c);

            if (newCase.Tier__c == CASE_TIER_LOW) {
                handleService(new LowPriorityService());
            } else if (newCase.Tier__c == CASE_TIER_DEFAULT) {
                handleService(new Service());
            } else if (newCase.Tier__c == CASE_TIER_GOLD) {
                handleService(new GoldService());
            } else {
            }
        }
    }


    private void handleService(Service service) {
        new ServiceHandler().createTaskFromHandler(service);
    }
}
