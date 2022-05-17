public class AccountProcessor {
	@future(callout=true)
    public static void countContacts(Set<id> setId) {
         List<Account> lstAccount = [select id,Number_of_Contacts__c , (select id from contacts ) from account where id in :setId ];
         List<Account> lstAccountsIds = new List<Account>();
         for(Account a:lstAccount){
            a.Number_of_Contacts__c = [select Count() from Contact where AccountId =:a.Id];
            lstAccountsIds.add(a);
        }
        update lstAccountsIds;
    }
}