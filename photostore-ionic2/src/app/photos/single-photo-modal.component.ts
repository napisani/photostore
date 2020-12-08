import { Component, Input, OnInit } from '@angular/core';
import { Photo } from './photo';
import { ModalController } from '@ionic/angular';

@Component({
    selector: 'single-photo-modal',
    templateUrl: './single-photo-modal.component.html',
    styleUrls: ['./single-photo-modal.component.scss']
})
export class SinglePhotoModalComponent implements OnInit {

    photoIdx = 2;

    @Input() photo: Photo;

    slideOptions = {
        initialSlide: 2,
        speed: 400
    };

    constructor(private readonly modalController: ModalController) {
    }

    ngOnInit(): void {
    }

    dismiss() {
        // using the injected ModalController this page
        // can "dismiss" itself and optionally pass back data
        this.modalController.dismiss({
            'dismissed': true
        });
    }
}
