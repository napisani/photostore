import { TestBed } from '@angular/core/testing';

import { PhotosStoreService } from './photos-store.service';

describe('PhotosStoreService', () => {
  let service: PhotosStoreService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PhotosStoreService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
