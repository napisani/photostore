export interface Photo {
  id?: number;
  checksum?: string;
  gphotoId?: string;
  mimeType?: string;
  creationDate?: Date;
  filename?: string;
  thumbnailPhotoFile?: PhotoFile;
  photoFile?: PhotoFile;
}

export interface PhotoFile {
  base64URL?: string;
  url?: string;
  height: number;
  width: number;
}

export const getWidthForDesiredHeight = (maxHeight: number, photoFile: PhotoFile): number => {
  return Math.ceil((maxHeight / photoFile.height) * photoFile.width);
};
