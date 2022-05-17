public with sharing class TaskUtils {

    /**
     * Usage: Process Builder evaluates criteria when account
     * becomes "validated" then invokes this apex method to delete
     * the related "Validate Account" tasks. 
     */
    @InvocableMethod
    public static void accountsValidated( List<ID> accountIds ) {
        
        List<Task> tasks = new List<Task>([
			select 
            	id
            from
            	task
            where
            	whatId in :accountIds
            	and
            	subject = 'Validate Account'
        ]);
        
        delete tasks;
    }
    
    public static void remindOwners(List<Opportunity> oppList) {

    List<Task> taskList = new List<Task>();
    For(Opportunity opp : oppList) {
      Task newTask = new Task(
           WhatId = opp.Id,
           OwnerId = opp.OwnerId,
           ActivityDate = Date.today(),
          Subject = 'Update Opportunity',
           Description = 'Kindly close the ticket by the end of the day');
        taskList.add(newTask);
        }
        insert taskList;
    }
    
}