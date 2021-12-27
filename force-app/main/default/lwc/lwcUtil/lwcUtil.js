import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export class LwcUtil {

    static setToast(type, message) {
        return new ShowToastEvent({
            title: type,
            variant: type,
            message: message
        });
    }
}