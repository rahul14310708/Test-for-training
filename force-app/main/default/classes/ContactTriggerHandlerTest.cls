@isTest
public class ContactTriggerHandlerTest {

    @testSetup
    static void setupData() {
       
        Contact existingContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert existingContact;
    }

    @isTest
    static void testDuplicateEmailPrevention() {
        Contact dupContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'JOHN.DOE@example.com' // Test case-insensitivity
        );

        Test.startTest();
        try {
            insert dupContact;
            System.assert(false, 'Expected a duplicate email error but insert succeeded.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('already exists'), 'Expected error message for duplicate email.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUniqueEmailSuccess() {
        Contact uniqueContact = new Contact(
            FirstName = 'Alice',
            LastName = 'Wonderland',
            Email = 'alice@example.com'
        );

        Test.startTest();
        insert uniqueContact;
        Test.stopTest();

        Contact inserted = [SELECT Id, Email FROM Contact WHERE Email = 'alice@example.com' LIMIT 1];
        System.assertNotEquals(null, inserted.Id, 'Expected contact to be inserted.');
    }

    @isTest
    static void testNullEmailIgnored() {
        Contact nullEmailContact = new Contact(
            FirstName = 'No',
            LastName = 'Email'
            
        );

        Test.startTest();
        insert nullEmailContact;
        Test.stopTest();

        System.assertNotEquals(null, nullEmailContact.Id, 'Contact with null email should be inserted.');
    }
}