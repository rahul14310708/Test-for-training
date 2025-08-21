global class ScheduleOldAccountsBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        Date cutoff = Date.today().addYears(-1);

        UpdateOldAccountsBatch batch = new UpdateOldAccountsBatch(cutoff);
        Database.executeBatch(batch, 200);
    }
}