public with sharing class InactivateSponsorshipsScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        InactivateSponsorshipsBatch batch = new InactivateSponsorshipsBatch();
        Database.executeBatch(batch);
    }
}