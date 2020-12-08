import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FullsizePhotoComponent } from './fullsize-photo.component';

describe('FullsizePhotoComponent', () => {
  let component: FullsizePhotoComponent;
  let fixture: ComponentFixture<FullsizePhotoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FullsizePhotoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FullsizePhotoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
