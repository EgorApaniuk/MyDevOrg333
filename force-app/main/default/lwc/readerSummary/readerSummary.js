import { LightningElement, api, wire } from 'lwc';
import getReaderSummary from '@salesforce/apex/ReaderBookSummaryController.getReaderSummary';

export default class ReaderSummary extends LightningElement {
    @api recordId;
    currentReadingCount;
    totalReadCount;

    @wire(getReaderSummary, { readerId: '$recordId' })
    wiredReaderSummary({ error, data }) {
        if (data) {
            this.currentReadingCount = data.currentlyReadingCount;
            this.totalReadCount = data.totalReadCount;
        } else if (error) {
            console.error(error);
        }
    }
}
