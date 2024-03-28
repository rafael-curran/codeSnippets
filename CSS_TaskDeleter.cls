// Apex Controller: CCS_TaskDeletionController.cls
public with sharing class CCS_TaskDeletionController {
    @AuraEnabled
    public static void deleteTaskById(Id taskId) {
        try {
            delete [SELECT Id FROM CCS_Task__c WHERE Id = :taskId LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error during deletion: ' + e.getMessage());
        }
    }
}
