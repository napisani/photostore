declare module "@capacitor/core" {
  interface PluginRegistry {
    PhotoLibrary: PhotoLibraryPlugin;
  }
}

export interface GetPhotosParams {
  offset: number; // fetch offset
  limit: number; // fetch limit
  width: number; // thumbnail width
  height: number; // thumbnail height
  quality: number; // thumbnail quality - only used for JPEG
  mode: "fast" | "exact"; // fetch mode: "fast" | "exact"
  orderAsc: boolean;
  orderBy: string;
  imageType: 'png' | 'jpeg',
  ids: string[] // only return specific ids
}

export interface GetPhotosResponse {
  total: number; // total number of all photos
  images: Photo[]; // image list
}

export interface Photo {
  id: string;
  createTime: number;
  modificationTime: number;
  height: number;
  width: number;
  location: {
    latitude: number;
    longitude: number;
  };
  dataUrl: string;
}

export interface PhotoLibraryPlugin {
  getPhotos(options: GetPhotosParams): Promise<GetPhotosResponse>;
}