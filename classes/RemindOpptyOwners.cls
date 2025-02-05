public class RemindOpptyOwners implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Opportunity> opptys = [SELECT Id, Name, OwnerId, CloseDate
            FROM Opportunity
            WHERE IsClosed = False AND
            CloseDate < TODAY];
        // Create a task for each opportunity in the list
        TaskUtils.remindOwners(opptys);
    }
    
    RemindOpptyOwners reminder = new RemindOpptyOwners();
	// Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
	String sch = '20 30 8 10 2 ?';
	String jobID = System.schedule('Remind Opp Owners', sch, reminder);
}