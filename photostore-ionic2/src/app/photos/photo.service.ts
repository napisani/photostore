import {Observable} from 'rxjs';
import {Pagination} from './pagination';
import {Photo, PhotoFile} from './photo';
import {switchMap, tap} from 'rxjs/operators';
import {HttpApiService} from '../shared/http-api.service';

export abstract class PhotoService {

  protected constructor(protected readonly httpClient: HttpApiService) {
  }

  abstract getPhotos(page: number, populateThumbs: boolean): Observable<Pagination<Photo>>;

  abstract getThumbnailUrl(photo: Photo): string;

  abstract getFullsizeUrl(photo: Photo): string;

  getFileReader(): FileReader {
    // https://github.com/ionic-team/capacitor/issues/1564
    // hack because new FileReader() does not seem to work in native ionic/capacitor apps
    const fileReader = new FileReader();
    const zoneOriginalInstance = (fileReader as any)['__zone_symbol__originalInstance'];
    return zoneOriginalInstance || fileReader;
  }

  protected readFile = (blob: Blob): Observable<string> => new Observable(obs => {
    console.log('inside readFile');
    if (!(blob instanceof Blob)) {
      console.log('not blob readFile');
      obs.error(new Error('`blob` must be an instance of File or Blob.'));
      return;
    }
    console.log('it is a blob readFile');

    const reader = this.getFileReader();

    reader.onerror = err => obs.error(err);
    reader.onabort = err => obs.error(err);
    reader.onload = () => obs.next(reader.result as string);
    reader.onloadend = () => obs.complete();

    return reader.readAsDataURL(blob);
  });

  protected readImageDimensions = (base64Url: string, url?: string): Observable<PhotoFile> => new Observable<PhotoFile>(obs => {
    if (!base64Url) {
      obs.error(new Error('the base64URL passed was not valid'));
    }
    const img = new Image();
    img.onerror = err => {
      obs.error(err);
      obs.complete();
    };
    img.onabort = err => {
      obs.error(err);
      obs.complete();

    };
    img.onload = () => {
      console.log('base64', base64Url);
      const photoFile = {
        base64URL: base64Url,
        height: img.height,
        width: img.width,
        url: url
      } as PhotoFile;
      obs.next(photoFile);
      obs.complete();
    };
    img.src = base64Url;
  });

  public getPhotoFile(imgURL: string): Observable<PhotoFile> {
    return this.httpClient.getFile(imgURL, {responseType: 'blob'})
      .pipe(switchMap(this.readFile))
      .pipe(tap((base64) => {
        console.log('tapped ' + base64);
      }))
      .pipe(switchMap((base64URL: string) => this.readImageDimensions(base64URL, imgURL)));
  }
}
