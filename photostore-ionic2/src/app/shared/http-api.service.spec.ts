import { TestBed } from '@angular/core/testing';

import { HttpApiService } from './http-api.service';

describe('HttpApiService', () => {
  let service: HttpApiService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(HttpApiService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
