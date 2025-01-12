trigger ValidateActiveSponsorship on Sponsorships__c (before insert, before update) {
    Set<Id> sponsorIds = new Set<Id>();

    for (Sponsorships__c p : Trigger.new) {
        if (p.Ignore_Validation__c == true) {
            continue;
        }

        if (Trigger.isInsert || (Trigger.isUpdate && p.Sponsor__c != Trigger.oldMap.get(p.Id).Sponsor__c)) {
            sponsorIds.add(p.Sponsor__c);
        }
    }

    System.debug('Sponsor IDs: ' + sponsorIds);

    if (!sponsorIds.isEmpty()) {
        List<Sponsorships__c> activeSponsorships = [
            SELECT Id, Sponsor__c 
            FROM Sponsorships__c 
            WHERE Sponsor__c IN :sponsorIds AND Active__c = true
        ];

        System.debug('Active Sponsorships: ' + activeSponsorships);

        Map<Id, List<Sponsorships__c>> sponsorToActiveSponsorships = new Map<Id, List<Sponsorships__c>>();
        for (Sponsorships__c s : activeSponsorships) {
            if (!sponsorToActiveSponsorships.containsKey(s.Sponsor__c)) {
                sponsorToActiveSponsorships.put(s.Sponsor__c, new List<Sponsorships__c>());
            }
            sponsorToActiveSponsorships.get(s.Sponsor__c).add(s);
        }

        System.debug('Sponsor to Active Sponsorships Map: ' + sponsorToActiveSponsorships);

        for (Sponsorships__c p : Trigger.new) {
            if (p.Ignore_Validation__c == true) {
                continue;
            }

            if (sponsorToActiveSponsorships.containsKey(p.Sponsor__c)) {
                for (Sponsorships__c activeSponsorship : sponsorToActiveSponsorships.get(p.Sponsor__c)) {
                    if (activeSponsorship.Id != p.Id) {
                        System.debug('Duplicate found for Sponsor ID: ' + p.Sponsor__c);
                        p.addError('The sponsor already has an active sponsorship.');
                    }
                }
            }
        }
    }
}
