import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, unsubscribe } from 'lightning/empApi';

import getReaderSummary from '@salesforce/apex/ReaderBookSummaryController.getReaderSummary';
import handleCompleteActiveBRBs from '@salesforce/apex/ReaderBookSummaryController.handleCompleteActiveBRBs';
//? QUESTION: каким должен быть порядок импортов в ЛВЦ?	| Вроде такой форматинг правильный.

const ALL_RBRS_COMPLETED_MESSAGE = 'All Talons were Completed! ';
const ERROR_WHILE_COMPLETING_RBRS_MESSAGE = 'Error closing active talons: ';

/**
 * description      This component 1) shows summary: number of All and Active Reader's RBRs
 *                  2) "Completes" all Reader's RBRs with Status__c = 'Active' on handleCompleteActiveBRBs
 * @author          Egor Apaniuk
 * @since           22/02/2024
 */
export default class ReaderSummary extends LightningElement {
    @api recordId;

    data;
    isDataLoaded = false;
    isCompleteButtonDisabled = false;
    wiredReaderSummaryResult;
    channelName = '/event/ReadEvent__e';
    subscription = {};

    /**
     * description      On connected callback handler. Subscribes to the ReadEvent__e channel
     *                  This allows to refresh LWC on RBR insert, update, delete
     * @author          Egor Apaniuk
     * @since           22/02/2024
     */
    async connectedCallback () {
        this.subscription = await subscribe(this.channelName, -1, response => {
            return refreshApex(this.wiredReaderSummaryResult);
        })
    }

    /**
     * description      On disconnected callback handler. Unsubscribes from ReadEvent__e channel.
     * @author          Egor Apaniuk
     * @since           22/02/2024
     */
    disconnectedCallback () {
        unsubscribe(this.subscription)
    }

    /**
     * description      This reactive method gets number of all and Active Reader's RBRs.
     * @author          Egor Apaniuk
     * @since           22/02/2024
     */
    @wire(getReaderSummary, { readerId: '$recordId' })
    getReaderSummary(result) {
        this.wiredReaderSummaryResult = result;
        const {data, error} = result;
        if (data) {
            this.isDataLoaded= true;
            this.data = data;
            this.calculateIsCompleteButtonDisabledFlag(data.activeRBRCount);
        }
    }

    /**
     * description      This handler sets all Active Reader's RBRs Status__c to 'Complete'.
     * @author          Egor Apaniuk
     * @since           22/02/2024
     */
    handleCompleteActiveBRBs() {
        handleCompleteActiveBRBs({ readerId: this.recordId })
            .then(() => {
                this.showToast('Success', ALL_RBRS_COMPLETED_MESSAGE, 'success');
                return refreshApex(this.wiredReaderSummaryResult);
            })
            .catch(error => {
                this.showToast('Error', ERROR_WHILE_COMPLETING_RBRS_MESSAGE + error?.body?.message, 'error');
            });
    }

    /**
     * description      Checks activeRBRCount to set the proper condition for the 'Complete Active Talons' button
     * @author          Egor Apaniuk
     * @since           22/02/2024
     */
    calculateIsCompleteButtonDisabledFlag(activeRBRCount) {
        this.isCompleteButtonDisabled = activeRBRCount > 0 ? false : true;
    }

    /**
     * description  This method shows toast messages
     * @param       title
     * @param       message
     * @param       variant
     * @author      Egor Apaniuk
     * @since       22/02/2024
     */
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
