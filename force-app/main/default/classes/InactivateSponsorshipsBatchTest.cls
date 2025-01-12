@isTest
public class InactivateSponsorshipsBatchTest {
    @isTest
    static void testBypassValidation() {
        Account sponsor = new Account(Name = 'Test Sponsor');
        insert sponsor;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Sponsorships__c sponsorship = new Sponsorships__c(
            Name = 'Test Sponsorship',
            Sponsor__c = sponsor.Id,
            Opportunity__c = opp.Id,
            Active__c = true,
            Ignore_Validation__c = true 
        );
        insert sponsorship;

        Sponsorships__c duplicateSponsorship = new Sponsorships__c(
            Name = 'Duplicate Sponsorship',
            Sponsor__c = sponsor.Id,
            Opportunity__c = opp.Id,
            Active__c = true
        );

        Test.startTest();
        try {
            insert duplicateSponsorship;
            System.assert(false, 'Se esperaba un error por patrocinio duplicado.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The sponsor already has an active sponsorship.'));
        }
        Test.stopTest();

        Sponsorships__c insertedSponsorship = [SELECT Id, Active__c, Ignore_Validation__c 
                                               FROM Sponsorships__c 
                                               WHERE Id = :sponsorship.Id];
        System.assertEquals(true, insertedSponsorship.Active__c, 'El patrocinio debería estar activo.');
        System.assertEquals(true, insertedSponsorship.Ignore_Validation__c, 'La validación debería haber sido ignorada.');
    }
}
