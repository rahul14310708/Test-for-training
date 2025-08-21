trigger OpportunityTrigger on Opportunity (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            OpportunityTriggerHandler.updateStageForUpgradeOpportunities(Trigger.new, Trigger.oldMap);
        }
    }
}