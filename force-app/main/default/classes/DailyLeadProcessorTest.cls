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
private class DailyLeadProcessorTest {
    @TestSetup
    static void testScheduledJob(){
        List<Lead> leadsToInsert = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead leadToInsert = new Lead(LastName = 'Lead #: ' + i);
            leadsToInsert.add(leadToInsert);
        }
        insert leadsToInsert;
        //Get the IDs of the leads we just inserted
        Map<Id, Lead> leadMap = new Map<Id, Lead>(leadsToInsert);
        Lead<Id> leadIds = new List<Id>(leadMap.keySet());

        Test.startTest();

        String sch = '20 8 * * *';

        String jobId = System.schedule('Daily update of LeadSource', sch, new DailyLeadProcessor());

        //Verify the scheduled job has not run
        List<Lead> leadUpdateCheckPrior = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce' AND Id IN :leadIds];
        System.assertEquals(0, leadUpdateCheckPrior.size(), 'Dreamforce values exist before job has run');


        Test.stopTest();

        //Now that the scheduled job has run, check that the values were properly updated
        List<Lead> leadUpdateCheckAfter = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce' AND Id IN :leadIds];
        System.assertEquals(200,leadUpdateCheckAfter.size() , 'Did not find expected number of leads with LeadSource field updated to the correct value');
    }
}