@isTest
public class AddPrimaryContactTest {
	@testSetup
    static void setup(){
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0; i<50; i++){
            testAccounts.add(new Account(BillingState = 'NY', name = 'QueueTest ' + i));
        }
        for(Integer j=0; j<50; j++){
            testAccounts.add(new Account(BillingState = 'CA', name = 'QueueTest ' + j));
        }
        insert testAccounts;
        
    }
    
    static testMethod void test(){
        Contact con = new Contact(FirstName = 'Queueable', LastName = 'Apex');
        insert con;
        String state = 'CA';
        Test.startTest();
        AddPrimaryContact primContact = new AddPrimaryContact(con, state);
        System.enqueueJob(primContact);
        Test.stopTest();
        
        System.assertEquals(50, [SELECT count() FROM Contact WHERE accountId IN (Select id from Account WHERE BillingState =:state)]);
    } 
}