import Foundation
import Capacitor
import Photos

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(PhotoLibrary)
public class PhotoLibrary: CAPPlugin {

    func getImageResult(imgType: String,
                        quality: CGFloat,
                        imageAsset: PHAsset,
                        image: UIImage) -> [String: Any] {
        var data: Data?
        if (imgType == "jpeg") {
            data = image.jpegData(compressionQuality: quality)
        } else {
            data = image.pngData()
        }
        return [
            "id": imageAsset.localIdentifier,
            "modificationTime": Int(imageAsset.modificationDate!.timeIntervalSince1970 * 1000),
            "height": imageAsset.pixelHeight,
            "width": imageAsset.pixelWidth,
            "createTime": Int(imageAsset.creationDate!.timeIntervalSince1970 * 1000),
            "location": [
                "latitude": imageAsset.location?.coordinate.latitude,
                "longitude": imageAsset.location?.coordinate.longitude
            ],
            "dataUrl": "data:image/" + imgType + ";base64," + data!.base64EncodedString()
        ]
    }

    func getPhotosAfterAuthorized(call: CAPPluginCall, status: PHAuthorizationStatus) {
        // prepare for params
        let ids = call.getArray("ids", String.self) ?? [],
                width = call.getInt("width") ?? 128,
                height = call.getInt("height") ?? 128,
                quality = call.getInt("quality") ?? 100, // only for jpeg image types
                mode = call.getString("mode") ?? "fast",
                orderAsc = call.getBool("orderAsc") ?? false,
                orderBy = call.getString("orderBy") ?? "creationDate",
                imgType = (call.getString("imageType") ?? "jpeg").lowercased();
        var offset = call.getInt("offset") ?? 0,
                limit = call.getInt("limit") ?? 20;
        var images = [[String: Any]]()

        if (status == .authorized) {
            // prepare for fetch options
            let fetchOptions: PHFetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: orderBy, ascending: orderAsc)]
            let imageRequestOptions = PHImageRequestOptions()
            imageRequestOptions.isSynchronous = true
            imageRequestOptions.resizeMode = mode == "fast" ? PHImageRequestOptionsResizeMode.fast : PHImageRequestOptionsResizeMode.exact
            // fetch assets
            let fetchResults: PHFetchResult<PHAsset>;
            if (ids.count > 0) {
                fetchResults = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: fetchOptions)
                // change offset & limit value
                offset = 0;
                limit = ids.count;
            } else {
                print("getting results")
                fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                print("got results: ", fetchResults)
            }
            // get photo contents by offset & limit
            let end: Int = min(offset + limit, fetchResults.count);
            for i in offset..<end {
                let imageAsset: PHAsset = fetchResults.object(at: i) as PHAsset;
                PHImageManager.default()
                        .requestImage(for: imageAsset,
                                targetSize: CGSize(width: width, height: height),
                                contentMode: .aspectFit,
                                options: imageRequestOptions,
                                resultHandler: { (image, _) in
                                    if (image != nil) {
                                        print("image found: ", image)
                                        images.append(self.getImageResult(imgType: imgType, quality: CGFloat(quality / 100), imageAsset: imageAsset, image: image!))
                                    }

                                });
            }
            call.resolve([
                "total": fetchResults.count,
                "images": images
            ])
        } else {
            print("not authenticated to use PHPhotos status.rawValue:", status.rawValue);
            call.reject("auth/forbidden");
        }
    }

    @objc public func getPhotos(_ call: CAPPluginCall) {
        // check for permission
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                self.getPhotosAfterAuthorized(call: call, status: status)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                self.getPhotosAfterAuthorized(call: call, status: status)
            }
        }
    }
}
