import {Component} from '@angular/core';
import {PhotoMobileMediaService} from '../photos/photo-mobile-media.service';
import {PhotoApiService} from '../photos/photo-api.service';

@Component({
  selector: 'app-tab3',
  templateUrl: 'tab3.page.html',
  styleUrls: ['tab3.page.scss']
})
export class Tab3Page {

  constructor(private photoMobileMediaService: PhotoMobileMediaService,
              private photoApi: PhotoApiService) {
    // this.photoMobileMediaService.getPhotos();
  }

  handleButton(): void {
    this.photoApi.getPhotoFile(`/api/photos/thumbnail/1`).subscribe({
      next: (photoFile) => {
        console.log('photoFile', JSON.stringify(photoFile));
        //console.log('photoFile.base64URL', photoFile.base64URL);
      },
      complete: () => {
        console.log('complete');
      },
      error: (err) => {
        console.error('getPhotoFile error' + err);
      }
    });
  }

}
