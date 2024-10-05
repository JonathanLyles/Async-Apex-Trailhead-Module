/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AddPrimaryContactTest {

    @TestSetup
    static void setup() {
        // TO DO: implement unit test
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < 50; i++){
            Account accNY = new Account(Name = 'NY Account' + i, BillingState = 'NY');
            Account accCA = new Account(Name = 'CA Account' + i, BillingState = 'CA');
            accountList.add(accNY);
            accountList.add(accCA);
        }
        insert accountList;
    }

    static testmethod void testQueueable(){
        
        Contact conNY = new Contact(LastName = 'NewYork-Contact');
        Contact conCA = new Contact(LastName = 'California-Contact');
        
        List<Contact> contactList = new List<Contact>();
        contactList.add(conNY);
        contactList.add(conCA);
        insert contactList;

      

        AddPrimaryContact forNY = new AddPrimaryContact((sObject) conNY,'NY');
        AddPrimaryContact forCA = new AddPrimaryContact((sObject) conCA,'CA');

        Test.startTest();
        
        Id jobNY = System.enqueueJob(forNY);
        Id jobCA = System.enqueueJob(forCA);

        Test.stopTest();
        
        List<Account> accList = [SELECT Id,(SELECT Id FROM CONTACTS WHERE Id = :conCA.Id) FROM ACCOUNT];
        System.assertEquals(50, accList.size(),'Number of CA Account with specified primary contact not the expected amount');
    }
}