import { TestBed } from '@angular/core/testing';

import { PhotoApiService } from './photo-api.service';

describe('PhotoApiService', () => {
  let service: PhotoApiService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PhotoApiService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
