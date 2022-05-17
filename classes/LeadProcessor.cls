global class LeadProcessor implements Database.Batchable<sObject>{
    	 public Database.QueryLocator start(Database.BatchableContext bc) {
        	return Database.getQueryLocator([Select LeadSource From Lead ]);
    }
         public void execute(Database.BatchableContext bc, List<Lead> scope){
            for (Lead leads : scope) {
                    leads.LeadSource = 'Dreamforce';
                }
             update scope;
            }
            
	global void finish(Database.BatchableContext bc){   }  

}