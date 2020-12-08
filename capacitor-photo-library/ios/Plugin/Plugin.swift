import Foundation
import Capacitor
import Photos

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(PhotoLibrary)
public class PhotoLibrary: CAPPlugin {

    func getImageResult (quality:CGFloat, imageAsset: PHAsset, image: UIImage) -> [String:Any] {
        let jpegData = image.jpegData(compressionQuality: quality)
        return [
            "id": imageAsset.localIdentifier,
            "createTime":  Int(imageAsset.creationDate!.timeIntervalSince1970 * 1000),
            "location": [
                "latitude": imageAsset.location?.coordinate.latitude,
                "longitude": imageAsset.location?.coordinate.longitude
            ],
            "dataUrl": "data:image/jepg;base64," + jpegData!.base64EncodedString()
        ]
    }

    @objc func getPhotos(_ call: CAPPluginCall) {
        // prepare for params
        let ids = call.getArray("ids", String.self) ?? [],
                width = call.getInt("width") ?? 128,
                height = call.getInt("height") ?? 128,
                quality = call.getInt("quality") ?? 100,
                mode = call.getString("mode") ?? "fast";
        var offset = call.getInt("offset") ?? 0,
                limit = call.getInt("limit") ?? 20;
        var images = [[String:Any]]()
        // check for permission
        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
            if (PHAuthorizationStatus == .authorized) {
                // prepare for fetch options
                let fetchOptions:PHFetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let imageRequestOptions = PHImageRequestOptions()
                imageRequestOptions.isSynchronous = true
                imageRequestOptions.resizeMode = mode == "fast" ? PHImageRequestOptionsResizeMode.fast : PHImageRequestOptionsResizeMode.exact
                // fetch assets
                let fetchResults:PHFetchResult<PHAsset>;
                if (ids.count > 0) {
                    fetchResults = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: fetchOptions)
                    // change offset & limit value
                    offset = 0;
                    limit = ids.count;
                } else {
                    fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                }
                // get photo contents by offset & limit
                let end:Int = min(offset + limit, fetchResults.count);

                // loop
                for i in offset..<end {
                    let imageAsset:PHAsset = fetchResults.object(at: i) as PHAsset;
                    PHImageManager.default().requestImage(for: imageAsset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: imageRequestOptions, resultHandler: { (image, _) in
                        if (image != nil) {
                            images.append(self.getImageResult(quality: CGFloat(quality / 100), imageAsset: imageAsset, image: image!))
                        }

                    });
                }
                // return the result
                call.resolve([
                    "total": fetchResults.count,
                    "images": images
                ])
            } else {
                call.reject("auth/forbidden");
            }
        }
    }
}