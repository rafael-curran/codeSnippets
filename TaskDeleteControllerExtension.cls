public without sharing class TaskDeleteControllerExtension {
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

        try {
            delete this.task
            // Redirect to the task list view after successful deletion
            return new PageReference('/lightning/o/Task/list');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error deleting task: ' + e.getMessage()));
            return null;
        }
    }

    private boolean canDelete() {
        // Check for custom permission
        if (!FeatureManagement.checkPermission('Task_Delete_Permission')) {
            return false;
        }

        return true;
    }
}