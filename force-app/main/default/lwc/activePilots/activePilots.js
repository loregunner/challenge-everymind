import { LightningElement, wire } from 'lwc';
import getActiveContacts from '@salesforce/apex/PilotController.getActiveContacts';

const columns = [
    { label: 'Contact Name', fieldName: 'name' },
    { label: 'Team', fieldName: 'team' },
    { label: 'Main Sponsor', fieldName: 'mainSponsor' }
];

export default class ActivePilots extends LightningElement {
    columns = columns;
    contacts;
    error;

    @wire(getActiveContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.map((contact, index) => ({
                ...contact,
                indexTitle: `${index + 1}`
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
}