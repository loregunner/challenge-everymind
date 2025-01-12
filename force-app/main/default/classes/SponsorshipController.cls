public class SponsorshipController {
    public Contact contact { get; set; }
    public List<Sponsorships__c> sponsorships { get; set; }

    public SponsorshipController(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
        this.sponsorships = [SELECT Name, Sponsor__r.Name, Active__c FROM Sponsorships__c WHERE Pilot__c = :contact.Id];
    }
}