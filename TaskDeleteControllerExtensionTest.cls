@isTest
private class TaskDeleteControllerExtensionTest {

    @isTest
    static void testDeletePermissionDenied() {
        // Setup - create a Task record
        Task testTask = new Task(Subject = 'Test Task');
        insert testTask;

        // Mock standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(testTask);
        TaskDeleteControllerExtension controller = new TaskDeleteControllerExtension(stdController);

        // Mock the permission check to return false
        Test.startTest();
        Test.setFeaturePermission('Task_Delete_Permission', false);
        PageReference result = controller.checkDeletePermission();
        Test.stopTest();

        // Verify - No redirect and an error message is added
        System.assertEquals(null, result, 'There should be no redirection when permissions are denied');
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one error message');
        System.assertEquals('You are not authorized to delete this Task.', ApexPages.getMessages().get(0).getSummary());
    }

    @isTest
    static void testDeletePermissionGranted() {
        // Setup - create a Task record
        Task testTask = new Task(Subject = 'Test Task', Status = 'Open');
        insert testTask;

        // Mock standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(testTask);
        TaskDeleteControllerExtension controller = new TaskDeleteControllerExtension(stdController);

        // Mock the permission check to return true
        Test.startTest();
        Test.setFeaturePermission('Task_Delete_Permission', true);
        PageReference result = controller.checkDeletePermission();
        Test.stopTest();

        // Verify - Redirect to the list view and record is deleted
        System.assertNotEquals(null, result, 'There should be a redirection when permissions are granted');
        System.assertEquals('/lightning/o/Task/list', result.getUrl(), 'The redirection should go to the tasks list view');
        System.assert([SELECT Count() FROM Task WHERE Id = :testTask.Id] == 0, 'The task should be deleted');
    }

    @isTest
    static void testDeleteExceptionHandling() {
        // Setup - create a Task record and make it undeletable somehow, usually via trigger or validation
        Task testTask = new Task(Subject = 'Test Task');
        insert testTask;

        // Introduce a trigger or other mechanism here to prevent deletion if needed, otherwise simulate an error

        // Mock standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(testTask);
        TaskDeleteControllerExtension controller = new TaskDeleteControllerExtension(stdController);

        // Simulate an exception by expecting a delete to fail
        DmlException fakeException = new DmlException();
        fakeException.setMessage('Fake deletion error');

        Test.startTest();
        Test.setFeaturePermission('Task_Delete_Permission', true);
        try {
            // You can mock an exception here if possible, or set up data to naturally cause one
            delete testTask; // This should fail if you set it up to fail
            System.assert(false, 'Expected an exception to be thrown');
        } catch (Exception e) {
            // Catch the block to handle exception in test context
        }
        PageReference result = controller.checkDeletePermission();
        Test.stopTest();

        // Verify - No redirect and an error message is displayed
        System.assertEquals(null, result, 'There should be no redirection when an error occurs');
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one error message');
        System.assertTrue(ApexPages.getMessages().get(0).getSummary().contains('Error deleting task'), 'The error message should indicate a deletion error');
    }
}
