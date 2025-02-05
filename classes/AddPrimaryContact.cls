public class AddPrimaryContact implements Queueable {
	private Contact c;
    private String state;
    public AddPrimaryContact(Contact contact, String state) {
        this.c = contact;
        this.state = state;
    }
    
      public void execute(QueueableContext context) {
       List<Account> accounts = [Select ID, Name From Account WHERE BillingState =:state LIMIT 200];
        List<Contact> contacts = new List<Contact>();
        for(Account account: accounts){
            Contact con = c.clone(false, false,false, false);
            con.AccountId = account.Id;
            contacts.add(con);
            
        	}
        if(contacts.size()>0){
            insert contacts;
        	}
    }
}