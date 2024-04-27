public class AccountTriggerHandler {
    public static void setTypeProspect(List<Account> newAccounts) {
        
        for(Account acc : newAccounts){
            if(acc.Type == null){  
                acc.Type = 'Prospect'; 
            }
            if(acc.ShippingAddress != null){
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingState = acc.BillingState;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCountry = acc.BillingCountry;
            } 
           if(acc.Phone != null || acc.Website != null || acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
    }
    
    public static void defaultContact(List<Account> accUpdate){
        List<Contact> contactList = new List<Contact>();
        
        for(Account account : accUpdate){
            Contact cc = new Contact();
            cc.AccountId = account.Id;
            cc.LastName = 'DefaultContact';
            cc.Email = 'default@email.com';
            contactList.add(cc);
        }
        
        if(!contactList.isEmpty()){
            insert contactList;
        }
    }
}