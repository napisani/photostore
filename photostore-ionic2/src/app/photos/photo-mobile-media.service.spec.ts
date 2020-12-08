import { TestBed } from '@angular/core/testing';

import { PhotoMobileMediaService } from './photo-mobile-media.service';

describe('PhotoMobileMediaService', () => {
  let service: PhotoMobileMediaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PhotoMobileMediaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
