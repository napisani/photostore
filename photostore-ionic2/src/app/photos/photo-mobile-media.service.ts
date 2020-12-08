import {Injectable, NgZone} from '@angular/core';
import {Media} from '@capacitor-community/media';


@Injectable({
  providedIn: 'root'
})
export class PhotoMobileMediaService {


  constructor(private zone: NgZone) {
  }

  getPhotos() {
    console.log('clicked');
    const m = new Media();
    m.getMedias().then((response) =>
      this.zone.run(() => (console.log('albums:', JSON.stringify(response))))
    );
  }
}
