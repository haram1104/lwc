import {LightningElement, track} from 'lwc';
import {LwcUtil} from 'c/lwcUtil';
import init from '@salesforce/apex/CustomTableController.init';
import getAccountList from '@salesforce/apex/CustomTableController.getAccountList';
import {NavigationMixin} from "lightning/navigation";

export default class CustomTable extends NavigationMixin(LightningElement) {
    @track accountList;
    @track showSpinner = false;

    connectedCallback() {
        this.showSpinner = true;

        init().then(dw => {
            if(dw.result === 'SUCCESS') {
                this.accountList = dw.accountList;
                this.industryList = dw.industryList;
            } else {
                this.dispatchEvent(LwcUtil.setToast('ERROR', dw.result));
            }
        }).catch(error => {
            this.dispatchEvent(LwcUtil.setToast('ERROR', error));
            console.log(error);
        }).finally(() => {
            this.showSpinner = false;
        });
    }

    getAccountList() {
        this.showSpinner = true;

        getAccountList({
            params: {
                accountNumber: this.template.querySelector('[data-id="accountNumber"]').value,
                name: this.template.querySelector('[data-id="name"]').value,
                industry: this.template.querySelector('[data-id="industry"]').value,
                annualRevenueFrom: this.template.querySelector('[data-id="annualRevenueFrom"]').value,
                annualRevenueTo: this.template.querySelector('[data-id="annualRevenueTo"]').value
            }
        }).then(dw => {
            if(dw.result === 'SUCCESS') {
                this.accountList = dw.accountList;
            } else {
                this.dispatchEvent(LwcUtil.setToast('ERROR', dw.result));
            }
        }).catch(error => {
            this.dispatchEvent(LwcUtil.setToast('ERROR', error));
            console.log(error);
        }).finally(() => {
            this.showSpinner = false;
        });
    }

    navToRecord(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.recordId,
                actionName: "view"
            }
        });
    }

    enterSearch(event) {
        if(event.which === 13) {
            this.getAccountList();
        }
    }
}