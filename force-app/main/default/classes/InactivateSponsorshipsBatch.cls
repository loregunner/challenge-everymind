public with sharing class InactivateSponsorshipsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Active__c 
            FROM Sponsorships__c 
            WHERE CustomCreationDate__c < LAST_N_DAYS:365 AND Active__c = true
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Sponsorships__c> sponsorships = (List<Sponsorships__c>) scope;
        for (Sponsorships__c sponsorship : sponsorships) {
            sponsorship.Active__c = false;
        }
        update sponsorships;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job completed successfully.');
    }
}