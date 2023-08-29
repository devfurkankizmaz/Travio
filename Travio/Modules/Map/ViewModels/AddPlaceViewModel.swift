import Alamofire
import Foundation
import UIKit

class AddPlaceViewModel {
    typealias AddPlaceHandler = (String, Bool) -> Void
    typealias UploadImageHandler = (Bool) -> Void

    private var urls: [String] = []
    private var placeId = ""

    func getImageUrls() -> [String]? {
        return urls
    }

    func getPlaceId() -> String? {
        return placeId
    }

    func uploadImage(images: [UIImage]?, callback: @escaping UploadImageHandler) {
        guard let images = images, !images.isEmpty else {
            callback(true)
            return
        }

        var uploadCounter = images.count
        var uploadSuccess = true

        images.forEach { image in
            guard let imageData = image.convertToData(withFormat: .jpeg(compressionQuality: 0.8)) else {
                print("Convert error.")
                uploadSuccess = false
                uploadCounter -= 1
                return
            }

            NetworkManager.shared.uploadImage(route: TravioRouter.uploadImage(imageData: imageData), imageData: imageData, responseType: UploadResponse.self) { result in
                switch result {
                case .success(let response):
                    print("Image uploaded successfully. URLs: \(response.urls[0])")
                    self.urls.append(response.urls[0])
                case .failure(let error):
                    print("Error uploading image: \(error)")
                    uploadSuccess = false
                }

                uploadCounter -= 1

                if uploadCounter == 0, uploadSuccess {
                    callback(true)
                } else if uploadCounter == 0 {
                    callback(false)
                }
            }
        }
    }

    func postPlace(_ input: PlaceInput, callback: @escaping AddPlaceHandler) {
        let params: Parameters = [
            "place": input.place,
            "title": input.title,
            "description": input.description ?? "",
            "cover_image_url": urls.first ?? "",
            "latitude": input.latitude,
            "longitude": input.longitude
        ]

        NetworkManager.shared.request(TravioRouter.postPlace(params: params), ofType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                self.placeId = response.message
                callback(response.message, true)
            case .failure(let error):
                print(error.localizedDescription)
                callback(error.localizedDescription, true)
            }
        }
    }

    func postGallery(with placeId: String, urls: [String]?, callback: @escaping AddPlaceHandler) {
        guard let urls = urls, !urls.isEmpty else {
            callback("Images nil", false)
            return
        }

        let dispatchGroup = DispatchGroup()
        var success = true

        for url in urls {
            dispatchGroup.enter()

            let params: Parameters = [
                "place_id": placeId,
                "image_url": url
            ]

            NetworkManager.shared.request(TravioRouter.postGalleryByPlaceId(params: params), ofType: ResponseModel.self) { result in
                switch result {
                case .success:
                    print("Gallery image posted successfully. URL: \(url)")
                case .failure(let error):
                    print("Error posting gallery image: \(error.localizedDescription)")
                    success = false
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            callback(success ? "Gallery images posted successfully" : "Error posting gallery images", success)
        }
    }
}
