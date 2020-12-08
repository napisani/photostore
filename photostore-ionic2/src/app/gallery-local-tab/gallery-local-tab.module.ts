import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { GalleryLocalTabPage } from './gallery-local-tab.page';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { GalleryTabPageRoutingModule } from './gallery-local-tab-routing.module';
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
  declarations: [GalleryLocalTabPage]
})
export class GalleryLocalTabModule {}
