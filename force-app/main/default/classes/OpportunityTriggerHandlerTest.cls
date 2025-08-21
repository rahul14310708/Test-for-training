@isTest
public class OpportunityTriggerHandlerTest {

    @isTest
    static void testUpgradeTypeSetsStage() {
        // Create an opportunity with Type = 'Existing Customer - Upgrade'
        Opportunity opp = new Opportunity(
            Name = 'Upgrade Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Type = 'Existing Customer - Upgrade'
        );
        insert opp;

        // Reload to verify trigger updated StageName
        Opportunity result = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Perception Analysis', result.StageName, 'Stage should be updated for upgrade type');
    }

    @isTest
    static void testNonUpgradeTypeDoesNotChangeStage() {
        // Create an opportunity with a different Type
        Opportunity opp = new Opportunity(
            Name = 'New Business Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Type = 'New Customer'
        );
        insert opp;

        // Reload to verify StageName remains unchanged
        Opportunity result = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Prospecting', result.StageName, 'Stage should not be updated for other types');
    }

    @isTest
    static void testNullTypeDoesNotChangeStage() {
        // Create an opportunity with Type = null
        Opportunity opp = new Opportunity(
            Name = 'Null Type Opportunity',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30),
            Type = null
        );
        insert opp;

        Opportunity result = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Qualification', result.StageName, 'Stage should not change when Type is null');
    }

    @isTest
    static void testUpdateFromDifferentTypeToUpgrade() {
        // Create an Opportunity with non-upgrade type
        Opportunity opp = new Opportunity(
            Name = 'Will Become Upgrade',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Type = 'New Customer'
        );
        insert opp;

        // Update to "Existing Customer - Upgrade"
        opp.Type = 'Existing Customer - Upgrade';
        update opp;

        Opportunity result = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Perception Analysis', result.StageName, 'Stage should update after type changes to Upgrade');
    }

    @isTest
    static void testAlreadyCorrectStageNotOverwritten() {
        // Create opportunity where stage is already "Perception Analysis"
        Opportunity opp = new Opportunity(
            Name = 'Already Correct Stage',
            StageName = 'Perception Analysis',
            CloseDate = Date.today().addDays(30),
            Type = 'Existing Customer - Upgrade'
        );
        insert opp;

        Opportunity result = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Perception Analysis', result.StageName, 'Stage should remain unchanged if already correct');
    }
}