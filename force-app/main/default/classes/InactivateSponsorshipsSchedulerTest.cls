@isTest
public class InactivateSponsorshipsSchedulerTest {
    @isTest
    static void testSchedulerExecution() {
        Account sponsor = new Account(Name = 'Test Sponsor');
        insert sponsor;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Sponsorships__c sponsorship = new Sponsorships__c(
            Name = 'Test Sponsorship',
            Sponsor__c = sponsor.Id,
            Opportunity__c = opp.Id,
            Active__c = true,
            CustomCreationDate__c = Date.today().addDays(-366) 
        );
        insert sponsorship;

        InactivateSponsorshipsBatch batch = new InactivateSponsorshipsBatch();
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        List<Sponsorships__c> updatedSponsorships = [SELECT Id, Active__c FROM Sponsorships__c WHERE Sponsor__c = :sponsor.Id];
        System.assertEquals(false, updatedSponsorships[0].Active__c, 'El patrocinio debería estar inactivo.');
    }
}
