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
private class LeadProcessorTest {

    @isTest
    static void testLeadSourceUpdate() {
        //Create and insert 200 leads 
        List<Lead> leadsToInsert = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead leadToInsert = new Lead(LastName = 'Test Lead ' + i, Company = 'Test Company');
            leadsToInsert.add(leadToInsert);
        }
        insert leadsToInsert;
        //Update the Lead.LeadSource to 'Dreamforce'
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead leadToUpdate : leadsToInsert){
            leadToUpdate.LeadSource = 'Dreamforce';
            leadsToUpdate.add(leadToUpdate);
        }
        update leadsToUpdate;

        List<Id> updatedLeadIds = new List<Id>();
        for(Lead leadToUpdate : leadsToUpdate){
            updatedLeadIds.add(leadToUpdate.Id);
        }

        Test.startTest();
        
        LeadProcessor leadProcessor = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessor);


        Test.stopTest();

        //Check Leads
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE Id IN :updatedLeadIds];
        System.assertEquals(200, updatedLeads.size(), 'List size not the expected size.');

        //Check LeadSource for each Lead
        for(Lead updatedLead : updatedLeads){
            System.assertEquals('Dreamforce', updatedLead.LeadSource, 'LeadSource does not have the expected value');
        }

        


    }
}