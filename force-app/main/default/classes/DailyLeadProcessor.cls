public with sharing class DailyLeadProcessor implements Schedulable{
    public DailyLeadProcessor() {

    }
    public void execute(SchedulableContext ctx){
        List<Lead> leadsWithBlankLeadSource = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];
        List<Lead> updatedLeadList = new List<Lead>();
        for(Lead leadWithBlankLeadSource : leadsWithBlankLeadSource){
            leadWithBlankLeadSource.LeadSource = 'Dreamforce';
            updatedLeadList.add(leadWithBlankLeadSource);
        }
        update updatedLeadList;
    }
}