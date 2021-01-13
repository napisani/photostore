import {Injectable} from '@angular/core';
import {PhotoService} from './photo.service';
import {forkJoin, from, Observable, of} from 'rxjs';
import {calculateRemainingPages, Pagination} from './pagination';
import {Photo, PhotoFile} from './photo';
import {map, switchMap, throttleTime} from 'rxjs/operators';
import {HttpApiService} from '../shared/http-api.service';
import {GetPhotosParams, GetPhotosResponse, Photo as CapacitorPhoto, PhotoLibraryPlugin} from 'capacitor-photo-library';
import {Plugins} from '@capacitor/core';

const ITEMS_PER_PAGE = 10;


@Injectable({
  providedIn: 'root'
})
export class PhotoMobileRollService extends PhotoService {

  constructor(protected readonly httpClient: HttpApiService) {
    super(httpClient);
  }

  getPhotos(page: number, populateThumbs: boolean = true): Observable<Pagination<Photo>> {
    console.log('LOCALLLLLL');
    const params = {
      // offset: (page - 1 * ITEMS_PER_PAGE),
      // limit: (page * ITEMS_PER_PAGE),
      offset: 0,
      limit: 3,
      mode: 'fast'
    } as GetPhotosParams;
    return from((Plugins.PhotoLibrary as PhotoLibraryPlugin).getPhotos(params))
      .pipe(
        throttleTime(500),
        switchMap((resp: GetPhotosResponse) => {
          const libItems = [];
          for (const lItem of resp.images) {
            libItems.push(lItem);
          }
          const pageOfPhotoObservables = libItems
            .map(libItem => this.convertCapacitorPhotoToPhoto(libItem));
          return forkJoin([...pageOfPhotoObservables])
            .pipe(
              map((photos: Photo[]) => {
                const pageOfPhotos = {
                  page,
                  perPage: ITEMS_PER_PAGE,
                  total: libItems.length,
                  remainingPages: calculateRemainingPages(photos.length, page, ITEMS_PER_PAGE),
                  items: photos,
                } as Pagination<Photo>;
                pageOfPhotos.itemSlices = [pageOfPhotos.items];
                return pageOfPhotos;
              }));

        })
      );
  }

  convertCapacitorPhotoToPhoto(libItemIn: CapacitorPhoto): Observable<Photo> {
    return of(libItemIn)
      .pipe(
        map((capPhoto: CapacitorPhoto) => {
          console.log(capPhoto.id);          // ID of the photo
          // console.log(capPhoto.dataUrl);    // Cross-platform access to photo
          console.log(capPhoto.width);
          console.log(capPhoto.height);
          const photo: Photo = {
            filename: capPhoto.id + '.jpg',
            creationDate: new Date(capPhoto.createTime),
            photoFile: {
              base64URL: capPhoto.dataUrl,
              height: capPhoto.height,
              width: capPhoto.width,
              url: capPhoto.dataUrl
            } as PhotoFile,
            thumbnailPhotoFile: {
              base64URL: capPhoto.dataUrl,
              height: capPhoto.height,
              width: capPhoto.width,
              url: capPhoto.dataUrl
            } as PhotoFile,
          } as Photo;
          return photo;
        })
      );
  }

  getThumbnailUrl(photo: Photo): string {
    return '';
  }

  getFullsizeUrl(photo: Photo): string {
    return '';
  }

}
