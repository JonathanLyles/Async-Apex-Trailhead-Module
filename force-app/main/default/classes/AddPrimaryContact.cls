public with sharing class AddPrimaryContact implements Queueable {
    Contact con;
    String state;

    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }

    public void execute(QueueableContext context){
        List<Account> accountList = [SELECT Id FROM Account WHERE BillingState = :state LIMIT 200];
        List<Contact> contactList = new List<Contact>();
        for(Account acc : accountList){
            Contact newContact = this.con.clone();
            newContact.AccountId = acc.Id;
            contactList.add(newContact);
        }
        insert contactList;
    }
}