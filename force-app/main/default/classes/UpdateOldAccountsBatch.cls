global class UpdateOldAccountsBatch implements Database.Batchable<SObject>, Database.Stateful {

    private Date cutoffDate;
    private Integer totalProcessed = 0;
    private Integer totalUpdated = 0;

    global UpdateOldAccountsBatch(Date cutoffDate) {
        this.cutoffDate = cutoffDate;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Name, CreatedDate, LastModifiedDate
            FROM Account
            WHERE CreatedDate < :cutoffDate
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        totalProcessed += scope.size();
        for (Account acc : scope) {
            acc.Name = acc.Name + ' [Updated]'; // Example logic
        }
        update scope;
        totalUpdated += scope.size();
    }

    global void finish(Database.BatchableContext BC) {
        String subject = 'UpdateOldAccountsBatch Complete';
        String body = 'Batch job completed.' +
                      '\n\nTotal Processed: ' + totalProcessed +
                      '\nTotal Updated: ' + totalUpdated +
                      '\nCutoff Date: ' + cutoffDate.format();

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { 'rahul.patil@riveron.com' });
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        System.debug(body);
    }
}