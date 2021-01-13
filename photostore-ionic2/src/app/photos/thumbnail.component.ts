import {Component, EventEmitter, Input, OnChanges, Output, SimpleChanges} from '@angular/core';
import {getWidthForDesiredHeight, Photo} from './photo';

@Component({
  selector: 'photostore2-thumbnail',
  templateUrl: './thumbnail.component.html',
  styleUrls: ['./thumbnail.component.scss']
})
export class ThumbnailComponent implements OnChanges {
  @Input() photo: Photo;

  @Input() maxHeight = 100;

  @Output() photoClicked = new EventEmitter<Photo>();
  private subs = [];
  thumbSrc;
  width = 100;

  constructor() {
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.thumbSrc = this.photo?.thumbnailPhotoFile?.base64URL;
    this.width = getWidthForDesiredHeight(this.maxHeight, this.photo.thumbnailPhotoFile);
  }

  handleClick(): void {
    this.photoClicked.emit(this.photo);
  }


}
