public with sharing class LeadProcessor implements Database.Batchable<sObject> {
    public LeadProcessor() {

    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id FROM Lead]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope){
        for(Lead currentLead : scope){
            currentLead.LeadSource = 'Dreamforce';
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('BatchableContext = ' + bc);
        System.debug('Job is done');
    }
}