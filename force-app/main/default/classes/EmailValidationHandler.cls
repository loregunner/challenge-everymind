public with sharing class EmailValidationHandler {

    public static void validateUniqueEmail(List<Contact> contacts) {
        Set<String> emails = new Set<String>();

        for (Contact cont : contacts) {
            if (cont.Email != null) {
                emails.add(cont.Email);
            }
        }

        List<Contact> existingContacts = [SELECT Id, Email FROM Contact WHERE Email IN :emails];

        Set<String> existingEmails = new Set<String>();
        for (Contact c : existingContacts) {
            existingEmails.add(c.Email);
        }

        for (Contact cont : contacts) {
            if (cont.Email != null && existingEmails.contains(cont.Email) && 
               (cont.Id == null || cont.Email != [SELECT Email FROM Contact WHERE Id = :cont.Id LIMIT 1].Email)) {
                cont.Email.addError('This email is already registered in another contact.');
            }
        }
    }
}
