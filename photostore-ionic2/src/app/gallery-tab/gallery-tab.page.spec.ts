import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { GalleryTabPage } from './gallery-tab.page';

describe('Tab1Page', () => {
  let component: GalleryTabPage;
  let fixture: ComponentFixture<GalleryTabPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [GalleryTabPage],
      imports: [IonicModule.forRoot(), ExploreContainerComponentModule]
    }).compileComponents();

    fixture = TestBed.createComponent(GalleryTabPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
