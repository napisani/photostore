import { Component } from '@angular/core';
import { PhotosStoreService } from '../photos/photos-store.service';

@Component({
    selector: 'app-tab1',
    templateUrl: 'gallery-tab.page.html',
    styleUrls: ['gallery-tab.page.scss'],
})
export class GalleryTabPage {

    maxPhotoHeight = Math.floor(window.innerHeight / 2);
    photoHeight = Math.floor(window.innerHeight / 8);
    minPhotoHeight = 25;

    constructor() {
    }

}
