trigger Trigger_Account on Account (before insert, after insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            TriggerAccountHandler.accountDataInsert(Trigger.new);
        }
        if(Trigger.isAfter){
            TriggerAccountHandler.sendEmail(Trigger.new);
        }
    }
}