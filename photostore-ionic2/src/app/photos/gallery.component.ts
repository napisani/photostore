import { AfterViewInit, Component, Input, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';
import { PhotoApiService } from './photo-api.service';
import { Photo } from './photo';
import { Pagination } from './pagination';
import { PhotoSectionService } from './photo-section.service';
import { PhotosStoreService } from './photos-store.service';
import { IonContent, ModalController } from '@ionic/angular';
import { SinglePhotoModalComponent } from './single-photo-modal.component';
import { Subject } from 'rxjs';
import { GalleryType } from './gallery-type';
import { PhotoMobileMediaService } from './photo-mobile-media.service';

@Component({
    selector: 'photostore2-gallery',
    templateUrl: './gallery.component.html',
    styleUrls: ['./gallery.component.scss'],
    providers: [PhotosStoreService]
})
export class GalleryComponent implements OnInit, AfterViewInit, OnChanges {

    @ViewChild('content') private content: IonContent;

    thumb;

    pagination: Pagination<Photo>;

    pageFillSubject = new Subject();

    // todo figure out what the size should be based on the screen/device
    // this.maxPhotoHeight = 300;
    // this.maxPhotoHeight = Math.floor(this.scrHeight / 6);
    @Input()
    maxPhotoHeight = Math.floor(window.innerHeight / 8);

    @Input()
    galleryType = GalleryType.SERVER;

    // photoSectionHeight = -1;


    constructor(private readonly photoApiService: PhotoApiService,
                // private readonly photoMobileRollService: PhotoMobileRollService,
                private readonly photoMobileMediaService: PhotoMobileMediaService,
                private readonly photoStore: PhotosStoreService,
                private readonly photoSectionService: PhotoSectionService,
                private readonly modalController: ModalController) {
    }

    ngAfterViewInit(): void {
        this.handleCheckMaxDataIsShown();
    }


    ngOnInit(): void {
        // this.photoMobileMediaService.getPhotos();
        // this.photoStore.init(this.galleryType === GalleryType.SERVER ?
        //     this.photoApiService.getPhotos.bind(this.photoApiService) :
        //     this.photoMobileRollService.getPhotos.bind(this.photoMobileRollService));
        this.photoStore.init(
            this.photoApiService.getPhotos.bind(this.photoApiService) );
        this.photoStore.getPhotos$().subscribe(photos => {
            this.pagination = photos;
            this.handleCheckMaxDataIsShown();
        });
        this.photoStore.nextPage();
    }

    ngOnChanges(changes: SimpleChanges): void {
        this.handleCheckMaxDataIsShown();
    }

    handleInfiniteScroll(infiniteScroll?) {
        console.log('handleInfiniteScroll');

        if (infiniteScroll) {
            console.log('handleInfiniteScroll', infiniteScroll);
            infiniteScroll.target.complete();
        }
        if (this.isAtTheEnd()) {
            return;
        }

        this.photoStore.nextPage();
    }

    handleCheckMaxDataIsShown() {
        this.content && this.content.getScrollElement().then((scrollElement) => {
            // console.log('checking for scroll bar');
            // console.log({ scrollElement });
            // console.log({ scrollHeight: scrollElement.scrollHeight });
            // console.log({ clientHeight: scrollElement.clientHeight });
            const hasScrollbar = (scrollElement.scrollHeight > scrollElement.clientHeight);
            console.log('overflow', { hasScrollBar: hasScrollbar });
            if (!hasScrollbar) {
                this.handleInfiniteScroll();
            }
        });
    }


    private isAtTheEnd() {
        return this.photoStore.isAtLastPage();
    }


    async handlePhotoClicked(event: { photo: Photo, section: Photo[] }, sectionIdx: number) {
        const modal = await this.modalController.create({
            component: SinglePhotoModalComponent,
            cssClass: 'single-photo-modal-class',
            swipeToClose: false,
            componentProps: {
                'photo': event.photo
            }
        });
        await modal.present();

    }


}
