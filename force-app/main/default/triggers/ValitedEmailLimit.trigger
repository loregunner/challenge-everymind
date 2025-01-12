trigger ValitedEmailLimit on Contact (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        EmailValidationHandler.validateUniqueEmail(Trigger.new);
    }
}
