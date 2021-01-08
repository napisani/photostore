import {registerWebPlugin, WebPlugin} from '@capacitor/core';
import {GetPhotosResponse, PhotoLibraryPlugin} from './definitions';

export class PhotoLibraryWeb extends WebPlugin implements PhotoLibraryPlugin {
    constructor() {
        super({
            name: 'PhotoLibrary',
            platforms: ['web']
        });
    }

    async getPhotos(): Promise<GetPhotosResponse> {
        throw 'getPhotos does not have a WEB implementation';
    }
}

const PhotoLibrary = new PhotoLibraryWeb();

export {PhotoLibrary};

registerWebPlugin(PhotoLibrary);