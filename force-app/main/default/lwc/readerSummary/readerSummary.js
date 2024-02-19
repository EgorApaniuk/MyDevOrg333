import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getReaderSummary from '@salesforce/apex/ReaderBookSummaryController.getReaderSummary';
import handleCloseActiveBRBs from '@salesforce/apex/ReaderBookSummaryController.handleCloseActiveBRBs';
import { refreshApex } from '@salesforce/apex';

export default class ReaderSummary extends LightningElement {
    @api recordId;
    activeRBRCount;
    totalRBRCount;

    @wire(getReaderSummary, { readerId: '$recordId' })
    wiredReaderSummary({ error, data }) {
        if (data) {
            this.activeRBRCount = data.activeRBRCount;
            this.totalRBRCount = data.totalRBRCount;
        } else if (error) {
            console.error(error);
        }
    }

    handleCloseActiveBRBs() {
        console.log(this.recordId);
        handleCloseActiveBRBs({ readerId: this.recordId })
            .then(() => {
                this.showToast('Success', Constants.ACTIVE_BRB_UPDATED_TO_COMPLETE, 'success');
                return refreshApex(this.wiredReaderSummary);
            })
            .catch(error => {
                this.showToast('Error', 'Error closing active talons: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
