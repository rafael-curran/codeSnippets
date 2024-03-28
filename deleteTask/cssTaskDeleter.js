import { LightningElement, api } from 'lwc';
import deleteTaskById from '@salesforce/apex/CCS_TaskDeletionController.deleteTaskById';

export default class CcsTaskDeleter extends LightningElement {
    @api recordId; // The ID of the CCS_Task__c record to delete

    deleteTask() {
        deleteTaskById({ taskId: this.recordId })
            .then(() => {
                this.dispatchEvent(new CustomEvent('close')); // Close the action
                // Optionally, dispatch a toast message here
            })
            .catch(error => {
                // Handle error
                // Optionally, dispatch a toast message here
            });
    }

    closeAction() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}
