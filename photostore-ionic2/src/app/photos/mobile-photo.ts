interface MobilePhoto {
  thumbnailWidth?: number;
  thumbnailHeight?: number;
  creationDate?: Date;
  location?: MobilePhotoLocation;
  fullHeight?: number;
  fullWidth?: number;
  identifier?: string;
  data?: string;


}

interface MobilePhotoLocation {
  altitude?: number;
  longitude?: number;
  heading?: number;
  speed?: number;
  latitude?: number;
}
