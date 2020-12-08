// import {Injectable} from '@angular/core';
// import {PhotoService} from './photo.service';
// import {forkJoin, from, Observable, of} from 'rxjs';
// import {calculateRemainingPages, Pagination} from './pagination';
// import {Photo, PhotoFile} from './photo';
// import {LibraryItem, PhotoLibrary} from '@ionic-native/photo-library/ngx';
// import {map, switchMap} from 'rxjs/operators';
// import {HttpApiService} from '../shared/http-api.service';
//
// const ITEMS_PER_PAGE = 10;
//
//
// @Injectable({
//   providedIn: 'root'
// })
// export class PhotoMobileRollService extends PhotoService {
//
//   constructor(protected readonly httpClient: HttpApiService, private photoLibrary: PhotoLibrary) {
//     super(httpClient);
//   }
//
//   getPhotos(page: number, populateThumbs: boolean = true): Observable<Pagination<Photo>> {
//     console.log('LOCALLLLLL')
//     return from(this.photoLibrary.requestAuthorization())
//       .pipe(
//         switchMap(() => {
//           return this.photoLibrary.getLibrary();
//         }),
//         switchMap((libItemsIn: LibraryItem[]) => {
//           const libItems = [];
//           for (const lItem of libItemsIn) {
//             libItems.push(lItem);
//           }
//           const pageOfPhotoObservables = libItems
//             .sort((a, b) => (b.creationDate as any) - (a.creationDate as any))
//             .slice(page - 1 * ITEMS_PER_PAGE, page * ITEMS_PER_PAGE)
//             .map(libItem => this.convertLibraryItemToPhoto(libItem))
//           return forkJoin([...pageOfPhotoObservables])
//             .pipe(
//               map((photos: Photo[]) => {
//                 const pageOfPhotos = {
//                   page: page,
//                   perPage: ITEMS_PER_PAGE,
//                   total: libItems.length,
//                   remainingPages: calculateRemainingPages(photos.length, page, ITEMS_PER_PAGE),
//                   items: photos,
//                 } as Pagination<Photo>;
//                 pageOfPhotos.itemSlices = [pageOfPhotos.items];
//                 return pageOfPhotos;
//               }));
//
//         })
//       );
//     // this.photoLibrary.requestAuthorization().then(() => {
//     //     this.photoLibrary.getLibrary().subscribe({
//     //         next: library => {
//     //             library.forEach(function(libraryItem) {
//     //
//     //             });
//     //         },
//     //         error: err => {
//     //             console.log('could not get photos');
//     //         },
//     //         complete: () => {
//     //             console.log('done getting photos');
//     //         }
//     //     });
//     // }).catch(err => console.log('permissions weren\'t granted'));
//     //
//     // return undefined;
//   }
//
//   convertLibraryItemToPhoto(libItemIn: LibraryItem): Observable<Photo> {
//     return of(libItemIn)
//       .pipe(
//         switchMap((libraryItem: LibraryItem) => {
//           return forkJoin([
//             this.getPhotoFile(libraryItem.photoURL),
//             this.getPhotoFile(libraryItem.thumbnailURL),
//           ]).pipe(map((result: [PhotoFile, PhotoFile]) => [...result, libraryItem]));
//         }),
//         map((result: [PhotoFile, PhotoFile, LibraryItem]) => {
//           const [orig, thumb, libraryItem] = result;
//           console.log(libraryItem.id);          // ID of the photo
//           console.log(libraryItem.photoURL);    // Cross-platform access to photo
//           console.log(libraryItem.thumbnailURL);// Cross-platform access to thumbnail
//           console.log(libraryItem.fileName);
//           console.log(libraryItem.width);
//           console.log(libraryItem.height);
//           console.log(libraryItem.creationDate);
//           console.log(libraryItem.latitude);
//           console.log(libraryItem.longitude);
//           console.log(libraryItem.albumIds);    // array of ids of appropriate AlbumItem, only of includeAlbumsData was used
//           const photo: Photo = {
//             filename: libraryItem.fileName,
//             creationDate: libraryItem.creationDate,
//             photoFile: orig,
//             thumbnailPhotoFile: thumb,
//           } as Photo;
//           return photo;
//         })
//       );
//   }
//
//   getThumbnailUrl(photo: Photo): string {
//     return '';
//   }
//
//   getFullsizeUrl(photo: Photo): string {
//     return '';
//   }
//
// }
