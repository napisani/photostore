import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SinglePhotoModalComponent } from './single-photo-modal.component';

describe('SinglePhotoModalComponent', () => {
  let component: SinglePhotoModalComponent;
  let fixture: ComponentFixture<SinglePhotoModalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SinglePhotoModalComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SinglePhotoModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
