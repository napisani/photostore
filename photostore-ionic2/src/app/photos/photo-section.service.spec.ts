import { TestBed } from '@angular/core/testing';

import { PhotoSectionService } from './photo-section.service';

describe('PhotoSectionService', () => {
  let service: PhotoSectionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PhotoSectionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
