trigger OpportunityTrigger on Opportunity (before insert, before update, after update, after insert, after delete, before delete) {
        if (Trigger.isBefore) {
        }else {
            if(Trigger.isUpdate){
                if(Trigger.isBefore) {
                    OpportunityTriggerHandler.updateOpportunity(Trigger.new);
                }
            }if (Trigger.isDelete) {
               if(Trigger.isBefore) {
                OpportunityTriggerHandler.deleteOppotunity(Trigger.old);
               }
            }
      }
}