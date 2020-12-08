import { Injectable } from '@angular/core';
import { getWidthForDesiredHeight, Photo } from './photo';

@Injectable({
    providedIn: 'root'
})
export class PhotoSectionService {

    constructor() {
    }

    partitionSectionIntoRows(items: Photo[], scrWidth: number, maxPhotoHeight: number, borderBuffer = 1): Photo[][] {
        const rows = [];
        let row = [];
        let currentWidth = 0;
        const borderPx = borderBuffer * 2;
        items.forEach(photo => {
            const photoWidth = getWidthForDesiredHeight(maxPhotoHeight, photo.thumbnailPhotoFile);
            if (currentWidth + photoWidth + borderPx >= scrWidth) {
                rows.push(row);
                row = [];
                currentWidth = 0;
            }
            row.push(photo);
            currentWidth += photoWidth + borderPx;
        });
        row.length && rows.push(row);
        // console.log('rows', rows);
        return rows;
    }

    getPhotoSectionHeight(items: Photo[], scrWidth: number, maxPhotoHeight: number): number {
        return this.partitionSectionIntoRows(items, scrWidth, maxPhotoHeight).length * maxPhotoHeight;
    }

    getTotalPartitionedRows(slices: Photo[][], scrWidth: number, maxPhotoHeight: number) {
        console.log('slices', slices);
        return slices.map(items => {
            const height = this.getPhotoSectionHeight(items, scrWidth, maxPhotoHeight);
            console.log('height', height);
            return height;
        }).reduce((acc, cur) => acc + cur, 0);
    }
}
