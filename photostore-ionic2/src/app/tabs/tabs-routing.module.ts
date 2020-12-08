import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

const routes: Routes = [
    {
        path: 'tabs',
        component: TabsPage,
        children: [
            {
                path: 'gallery-tab',
                loadChildren: () => import('../gallery-tab/gallery-tab.module').then(m => m.GalleryPageModule)
            },
            {
                path: 'gallery-local-tab',
                loadChildren: () => import('../gallery-local-tab/gallery-local-tab.module').then(m => m.GalleryLocalTabModule)
            },
            {
                path: 'tab3',
                loadChildren: () => import('../tab3/tab3.module').then(m => m.Tab3PageModule)
            },
            {
                path: '',
                redirectTo: '/tabs/gallery-tab',
                pathMatch: 'full'
            }
        ]
    },
    {
        path: '',
        redirectTo: '/tabs/gallery-tab',
        pathMatch: 'full'
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class TabsPageRoutingModule {
}
