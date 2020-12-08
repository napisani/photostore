import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { GalleryLocalTabPage } from './gallery-local-tab.page';

describe('Tab1Page', () => {
  let component: GalleryLocalTabPage;
  let fixture: ComponentFixture<GalleryLocalTabPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [GalleryLocalTabPage],
      imports: [IonicModule.forRoot(), ExploreContainerComponentModule]
    }).compileComponents();

    fixture = TestBed.createComponent(GalleryLocalTabPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
