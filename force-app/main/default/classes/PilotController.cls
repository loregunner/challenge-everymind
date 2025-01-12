public with sharing class PilotController {
    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> getActiveContacts() {
        List<ContactWrapper> contacts = new List<ContactWrapper>();
        for (Contact contact : [SELECT Id, Name, Team__c, (SELECT Name FROM Sponsorships__r ORDER BY Name__c DESC LIMIT 1) FROM Contact WHERE Active__c = True]) {
            String mainSponsor = contact.Sponsorships__r.isEmpty() ? '' : contact.Sponsorships__r[0].Name;
            contacts.add(new ContactWrapper(contact.Name, contact.Team__c, mainSponsor));
        }
        return contacts;
    }

    public class ContactWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String team;
        @AuraEnabled public String mainSponsor;

        public ContactWrapper(String name, String team, String mainSponsor) {
            this.name = name;
            this.team = team;
            this.mainSponsor = mainSponsor;
        }
    }
}