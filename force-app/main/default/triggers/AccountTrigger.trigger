trigger AccountTrigger on Account (before insert, after insert) {
    if(Trigger.isInsert && Trigger.isBefore){
      AccountTriggerHandler.setTypeProspect(Trigger.new);
    }


if(Trigger.isInsert && Trigger.isAfter){
    AccountTriggerHandler.defaultContact(Trigger.new);
  }

}