import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {GalleryComponent} from './gallery.component';
import {HttpClientModule} from '@angular/common/http';
// import { ScrollingModule } from '@angular/cdk/scrolling';
import {ThumbnailComponent} from './thumbnail.component';
import {PhotoSectionComponent} from './photo-section.component';
// import { InfiniteScrollModule } from 'ngx-infinite-scroll';
import {IonicModule} from '@ionic/angular';
import {SinglePhotoComponent} from './single-photo.component';
import {ImagePreloaderDirective} from './image-preloader.directive';
import {SinglePhotoModalComponent} from './single-photo-modal.component';
import {FullsizePhotoComponent} from './fullsize-photo.component';


@NgModule({
  declarations: [GalleryComponent, ThumbnailComponent, PhotoSectionComponent, SinglePhotoComponent, ImagePreloaderDirective, SinglePhotoModalComponent, FullsizePhotoComponent],
  exports: [
    GalleryComponent
  ],
  imports: [
    CommonModule,
    HttpClientModule,
    // ScrollingModule,
    // InfiniteScrollModule,
    IonicModule
  ]
})
export class PhotosModule {
}
