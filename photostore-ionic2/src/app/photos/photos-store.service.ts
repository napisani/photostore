import { Injectable } from '@angular/core';
import { PhotoApiService } from './photo-api.service';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { Photo } from './photo';
import { Pagination, reducePagination } from './pagination';
import { mergeMap, scan } from 'rxjs/operators';

@Injectable()
export class PhotosStoreService {

    private pageSubject = new Subject<number>();
    private photos = new BehaviorSubject<Pagination<Photo>>(null);
    private openedPhotoIndex = new BehaviorSubject<number>(null);
    private photoGetter: (page: number) => Observable<Pagination<Photo>> = null;

    constructor(private readonly photoService: PhotoApiService) {
        this.pageSubject
            .pipe(
                // throttleTime(500),
                mergeMap(pageNumber => this.photoGetter(pageNumber)),
                scan(
                    reducePagination,
                    Object.assign({}, this.photos.value ?? {
                        itemSlices: [],
                        items: [],
                        page: 0,
                        remainingPages: 999,
                        perPage: 10
                    } as Pagination<Photo>))
            ).subscribe(page => {
            this.photos.next(page);
            console.log('updating this.photos.value: ', this.photos.value);
        });
    }

    init(photoGetter: (page: number) => Observable<Pagination<Photo>>) {
        this.photoGetter = photoGetter;
    }

    getPageNumber$(): Observable<number> {
        return this.pageSubject.asObservable();
    }

    getPhotos$(): Observable<Pagination<Photo>> {
        return this.photos.asObservable();
    }


    isAtLastPage(): boolean {
        return !this.photos.value || this.photos.value.remainingPages <= 0;
    }

    nextPage(): number {
        const nextPage = (this.photos.value?.page ?? 0) + 1;
        if (nextPage != 1 && this.isAtLastPage()) {
            console.log('nextPage end of all pages');
            return -1;
        }

        console.log('handleInfiniteScroll loading next page ' + nextPage);
        this.pageSubject.next(nextPage);
        return nextPage;

    }

    isLastPhoto(idx: number): boolean {
        if ((idx + 1) < this.photos.value.items.length) {
            return false;
        }
        return this.isAtLastPage();
    }

    openPhoto(idx: number) {

    }


}
