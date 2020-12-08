import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { GalleryTabPage } from './gallery-tab.page';

const routes: Routes = [
  {
    path: '',
    component: GalleryTabPage,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class GalleryTabPageRoutingModule {}
