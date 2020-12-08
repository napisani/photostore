import {Injectable} from '@angular/core';
import {Platform} from '@ionic/angular';
import {HttpClient} from '@angular/common/http';
import {HTTP, HTTPResponse} from '@ionic-native/http/ngx';
import {from, Observable} from 'rxjs';
import {map} from 'rxjs/operators';


@Injectable({
  providedIn: 'root'
})
export class HttpApiService {

  constructor(private readonly platform: Platform,
              private readonly ngHttpClient: HttpClient,
              private readonly cordovaHttpClient: HTTP) {

  }


  getFile<T>(url: string, options: any = {method: 'get'}): Observable<any> {
    if (this.isNative()) {
      console.log('using NATIVE http');
      return from(this.cordovaHttpClient.sendRequest(`http://192.168.1.128:5000${url}`, options))
        .pipe(map((resp: HTTPResponse) => {
          console.log('inside map ' + (typeof resp.data));
          return resp.data;
        }));
    }
    console.log('using ANGULAR http');
    return this.ngHttpClient.get<T>(`/proxy${url}`, options);
  }


  get<T>(url: string, options: any = {method: 'get'}): Observable<any> {
    if (this.isNative()) {
      console.log('using NATIVE http');
      return from(this.cordovaHttpClient.sendRequest(`http://192.168.1.128:5000${url}`, options))
        .pipe(map((resp: HTTPResponse) => {
          try {
            return JSON.parse(resp.data);
          } catch (error) {
            return {response: resp.data};
          }
        }));
    }
    console.log('using ANGULAR http');
    return this.ngHttpClient.get<T>(`/proxy${url}`, options);
  }


  private isNative(): boolean {
    return this.platform.is('android') ||
      this.platform.is('ios') ||
      this.platform.is('electron');
  }
}
