public with sharing class OpportunityTriggerHandler {
    public static List AmountValidation (List<Opportunity> oppInvaidAmounts) {
        for (Opportunity opp : oppInvaidAmounts) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than or equal to 5000');
                oppInvaidAmounts.add(opp);
            }
        }
           return oppInvaidAmounts;
    }


    public static void deleteCloseWonOpportunity(){
        Set<Id> closedWonOpportunityIds = new Set<Id>();
        Map<Id, Id> opportunityAccountIds = new Map<Id, Id>();
    
        for (Opportunity opp : closedWonOpportunityIds) {
            if (opp.StageName == 'Closed Won') {
                closedWonOpportunityIds.add(opp.Id);
                opportunityAccountIds.put(opp.Id, opp.AccountId);
            }
        }
    
        // Query related Account industries
        Map<Id, Account> accountIndustries = new Map<Id, Account>(
            [SELECT Id, Industry FROM Account WHERE Id IN :opportunityAccountIds.values()]
        );
    
        // Check if the Account industry is 'Banking' and if so, prevent deletion of the opportunity
        for (Id oppId : closedWonOpportunityIds) {
            if (accountIndustries.containsKey(opportunityAccountIds.get(oppId)) && 
                accountIndustries.get(opportunityAccountIds.get(oppId)).Industry == 'Banking') {
                Opportunity opp = Trigger.oldMap.get(oppId);
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }

    public static void setPrimaryContact(){
     
        // Collect the IDs of the opportunities being updated
        Set<Id> updatedOpportunityIds = new Set<Id>();
        for (Opportunity opp : Trigger.new) {
            if (Trigger.oldMap.get(opp.Id).PrimaryContact__c != opp.PrimaryContact__c) {
                updatedOpportunityIds.add(opp.Id);
            }
        }
    
        // If no opportunities are being updated, exit
        if (updatedOpportunityIds.isEmpty()) {
            return;
        }
    
        // Query for the related accounts of the updated opportunities
        List<Account> relatedAccounts = [SELECT Id, (SELECT Id, Name, Title FROM Contacts WHERE Title = 'CEO') FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :updatedOpportunityIds)];
    
        // Map to hold the CEO contacts by account ID
        Map<Id, Contact> ceoContactsByAccountId = new Map<Id, Contact>();
    
        // Populate the map with CEO contacts
        for (Account acc : relatedAccounts) {
            for (Contact con : acc.Contacts) {
                if (con.Title == 'CEO') {
                    ceoContactsByAccountId.put(acc.Id, con);
                    break; // No need to search further once CEO is found
                }
            }
        }
    
        // Update the primary contact on the opportunities
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opp :  opportunitiesToUpdate) {
            if (ceoContactsByAccountId.containsKey(opp.AccountId)) {
                opp.PrimaryContact__c = ceoContactsByAccountId.get(opp.AccountId).Id;
                opportunitiesToUpdate.add(opp);
            }
        }
    
        // Perform the update
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }
}
