public class TaskDeleteControllerExtension {
    private final Task task;
    private ApexPages.StandardController stdController;

    public TaskDeleteControllerExtension(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.task = (Task)stdController.getRecord();
    }

    public PageReference checkDeletePermission() {
        if (!canDelete()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, "You are not authorized to delete this Task."));
            return null;
        }

        return stdController.delete();
    }

    private boolean canDelete() {
        // Checking for custom permission
        if (!FeatureManagement.checkPermission('Task_Delete_Permission')) {
            return false;
        }

        // Additional logic
        if ($Profile.Name == 'System Administrator' || 
            ISBLANK(task.WhatId) || 
            LEFT(task.WhatId, 3) != '500' || 
            task.Status != 'Completed') {
            return true;
        }

        return false;
    }
}
