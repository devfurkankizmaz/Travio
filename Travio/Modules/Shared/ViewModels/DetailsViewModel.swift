//
//  MapViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

class DetailsViewModel {
    typealias DetailHandler = (Bool) -> Void
    typealias DeleteHandler = (String) -> Void
    var place: Place?
    var images: [Image] = []

    func fetchPlace(with placeId: String, callback: @escaping DetailHandler) {
        NetworkManager.shared.request(TravioRouter.getPlaceById(id: placeId), responseType: PlaceResponse.self) { result in
            switch result {
            case .success(let response):
                callback(true)
                self.place = response.data.place
            case .failure(let error):
                callback(false)
                print(error)
            }
        }
    }

    func fetchGallery(with placeId: String, callback: @escaping DetailHandler) {
        NetworkManager.shared.request(TravioRouter.getGalleryByPlaceId(id: placeId), responseType: ImageResponse.self) { result in
            switch result {
            case .success(let response):
                callback(true)
                self.images = response.data.images
            case .failure(let error):
                callback(false)
                print(error)
            }
        }
    }

    func deleteVisit(with visitId: String, callback: @escaping DeleteHandler) {
        NetworkManager.shared.request(TravioRouter.deleteVisitById(id: visitId), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                callback(response.message)
            case .failure(let error):
                callback(error.localizedDescription)
                print(error)
            }
        }
    }

    func checkVisit(with placeId: String, callback: @escaping DetailHandler) {
        NetworkManager.shared.request(TravioRouter.getVisitByPlace(id: placeId), responseType: CheckModel.self) { result in
            switch result {
            case .success:
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func numberOfImages() -> Int {
        return images.count
    }

    func getAnImage(at index: Int) -> Image? {
        return images[index]
    }
}
