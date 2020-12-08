import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { GalleryTabPage } from './gallery-tab.page';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { GalleryTabPageRoutingModule } from './gallery-tab-routing.module';
import { PhotosModule } from '../photos/photos.module';

@NgModule({
    imports: [
        IonicModule,
        CommonModule,
        FormsModule,
        ExploreContainerComponentModule,
        GalleryTabPageRoutingModule,
        PhotosModule
    ],
  declarations: [GalleryTabPage]
})
export class GalleryPageModule {}
