//
//  MapViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

class DetailsViewModel {
    typealias DetailHandler = (Bool) -> Void
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

    func numberOfImages() -> Int {
        return images.count
    }

    func getAnImage(at index: Int) -> Image? {
        return images[index]
    }
}
