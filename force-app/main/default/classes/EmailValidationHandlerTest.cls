@isTest
private class EmailValidationHandlerTest {

    @isTest
    static void testValidateUniqueEmail() {
        Contact existingContact = new Contact(FirstName = 'Test', LastName = 'User', Email = 'testuser@example.com');
        insert existingContact;

        Contact newContact = new Contact(FirstName = 'New', LastName = 'User', Email = 'testuser@example.com');

        List<Contact> contacts = new List<Contact>{newContact};

        Test.startTest();

        EmailValidationHandler.validateUniqueEmail(contacts);

        Test.stopTest();

        System.assertNotEquals(0, newContact.getErrors().size(), 'Expected error for duplicate email not found.');

        Boolean hasDuplicateEmailError = false;
        for (Database.Error err : newContact.getErrors()) {
            if (err.getMessage().contains('This email is already registered in another contact.')) {
                hasDuplicateEmailError = true;
                break;
            }
        }

        System.assert(hasDuplicateEmailError, 'Expected duplicate email error not found.');
    }
}
