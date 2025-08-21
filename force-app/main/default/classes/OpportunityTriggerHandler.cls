public class OpportunityTriggerHandler {

    public static void updateStageForUpgradeOpportunities(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        for (Opportunity opp : newList) {
            if (opp.Type == null) continue;

            if (opp.Type == 'Existing Customer - Upgrade') {
                
                if (opp.StageName != 'Perception Analysis') {
                    opp.StageName = 'Perception Analysis';
                }
            }
        }
    }
}