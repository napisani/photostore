import {Injectable} from '@angular/core';
import {forkJoin, Observable} from 'rxjs';
import {Photo, PhotoFile} from './photo';
import {calculateRemainingPages, Pagination} from './pagination';
import {map, switchMap} from 'rxjs/operators';
import {PhotoService} from './photo.service';
import {HttpApiService} from '../shared/http-api.service';

@Injectable({
  providedIn: 'root'
})
export class PhotoApiService extends PhotoService {

  constructor(protected readonly httpClient: HttpApiService) {
    super(httpClient);
  }

  getPhotos(page = 1, populateThumbs = true): Observable<Pagination<Photo>> {
    const thumbnailSwitchMap = switchMap((page: Pagination<Photo>) => {
      const thumbCalls = page.items.map(item => this.getPhotoFile(this.getThumbnailUrl(item)));
      return forkJoin([...thumbCalls])
        .pipe(map((thumbCallResults: PhotoFile[]) => {
          page.items.forEach((item: Photo, idx: number) => {
            item.thumbnailPhotoFile = thumbCallResults[idx];
            if (!populateThumbs) {
              delete item.thumbnailPhotoFile.base64URL;
            }
          });
          page.items = page.items.sort((a, b) => (b.creationDate as any) - (a.creationDate as any));
          return page;
        }));
    });

    const photos$ = this.httpClient.get(`/api/photos/${page}`)
      .pipe(
        map((resp: any) => {
          const page = {
            page: resp.page,
            perPage: resp.per_page,
            total: resp.total,
            remainingPages: calculateRemainingPages(resp.total, resp.page, resp.per_page),
            items: resp.items.map(item => {
              return {
                id: item.id,
                checksum: item.checksum,
                gphotoId: item.gphoto_id,
                mimeType: item.mime_type,
                creationDate: new Date(item.creation_date),
                filename: item.filename
              } as Photo;
            })
          } as Pagination<Photo>;
          page.itemSlices = [page.items];

          return page;
        }),
        thumbnailSwitchMap
      );


    return photos$;

  }

  getThumbnailUrl(photo: Photo): string {
    return `/api/photos/thumbnail/${photo.id}`;
  }

  getFullsizeUrl(photo: Photo): string {
    return `/api/photos/fullsize/${photo.id}`;
  }


}
