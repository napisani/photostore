import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { getWidthForDesiredHeight, Photo } from './photo';
import { PhotoApiService } from './photo-api.service';

@Component({
  selector: 'photostore2-fullsize-photo',
  templateUrl: './fullsize-photo.component.html',
  styleUrls: ['./fullsize-photo.component.scss']
})
export class FullsizePhotoComponent  implements OnChanges {
    @Input() photo: Photo;

    private subs = [];
    thumbSrc;

    constructor(private readonly photoService: PhotoApiService) {
    }

    ngOnChanges(changes: SimpleChanges): void {
        const id  = this.photo?.id;
        if(id){
            this.thumbSrc = this.photoService.getFullsizeUrl(this.photo)
        }

    }



}
