import {
  Component,
  ElementRef,
  EventEmitter,
  HostListener,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
  ViewChild
} from '@angular/core';
import {Photo} from './photo';
import {PhotoSectionService} from './photo-section.service';

@Component({
  selector: 'photostore2-photo-section',
  templateUrl: './photo-section.component.html',
  styleUrls: ['./photo-section.component.scss']
})
export class PhotoSectionComponent implements OnInit, OnChanges {

  @ViewChild('section') section: ElementRef;


  @Input()
  items: Photo[] = [];
  @Input()
  maxPhotoHeight = 100;

  @Output()
  photoClicked = new EventEmitter<{ photo: Photo, section: Photo[] }>();

  scrHeight: number;
  scrWidth: number;

  rows: Photo[][] = [];


  constructor(private readonly photoSectionService: PhotoSectionService) {

  }

  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges): void {
    this.handleChange();
  }


  @HostListener('window:resize', ['$event'])
  handleScreenSizeChanged(event?) {
    this.handleChange();
  }

  handleChange() {
    // this.scrHeight = window.innerHeight;
    this.scrWidth = window.innerWidth;
    this.scrHeight = window.innerHeight;
    // this.scrWidth = this.section?.nativeElement?.offsetWidth
    console.log(`height: ${this.scrHeight} width: ${this.scrWidth}`);
    this.rows = this.photoSectionService.partitionSectionIntoRows(this.items,
      this.scrWidth, this.maxPhotoHeight);
    // console.log('rows built', this.rows);
    console.log('finished partitionSectionIntoRows');
  }

  handlePhotoClick(photo) {
    this.photoClicked.emit({photo: photo, section: this.items});
  }


}
