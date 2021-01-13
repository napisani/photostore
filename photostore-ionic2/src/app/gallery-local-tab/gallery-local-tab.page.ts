import {Component} from '@angular/core';
import {GalleryType} from '../photos/gallery-type';
import 'capacitor-photo-library'
import {Plugins} from '@capacitor/core';

@Component({
  selector: 'app-tab1',
  templateUrl: 'gallery-local-tab.page.html',
  styleUrls: ['gallery-local-tab.page.scss'],
})
export class GalleryLocalTabPage {

  maxPhotoHeight = Math.floor(window.innerHeight / 2);
  photoHeight = Math.floor(window.innerHeight / 3);
  minPhotoHeight = 25;
  galleryType = GalleryType;

  photoSrc

  constructor() {
  }

  handleButton(): void {
    Plugins.PhotoLibrary.getPhotos().then(imgs => {
      this.photoSrc = imgs.images[0].dataUrl
      // console.log('imgs', JSON.stringify(imgs));
    }).catch(err => {
      console.log('err', JSON.stringify(err));
    });

    // this.photosMobile.getPhotos(1).subscribe((f) => {
    //   console.log(f);
    // });
    // const m = new Media();
    // m.getMedias().then((response) => {
    //     this.photoSrc = response.medias[0].data;
    //
    //   }
    // this.zone.run(() => (console.log('albums:', JSON.stringify(response))))
    ;
  }

}
