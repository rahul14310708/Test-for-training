public class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> newContacts) {
        Set<String> emailsToCheck = new Set<String>();

        for (Contact c : newContacts) {
            if (String.isNotBlank(c.Email)) {
                emailsToCheck.add(c.Email.toLowerCase());
            }
        }

        if (emailsToCheck.isEmpty()) {
            return;
        }

        Map<String, Contact> existingContactsMap = new Map<String, Contact>();
        for (Contact existing : [
            SELECT Id, Email FROM Contact WHERE Email IN :emailsToCheck
        ]) {
            if (String.isNotBlank(existing.Email)) {
                existingContactsMap.put(existing.Email.toLowerCase(), existing);
            }
        }

        for (Contact c : newContacts) {
            String lowerEmail = c.Email != null ? c.Email.toLowerCase() : null;
            if (lowerEmail != null && existingContactsMap.containsKey(lowerEmail)) {
                c.addError('A contact with this email already exists: ' + c.Email);
            }
        }
    }
}