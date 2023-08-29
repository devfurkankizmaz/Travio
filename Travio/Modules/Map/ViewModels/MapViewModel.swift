//
//  MapViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

class MapViewModel {
    typealias PlaceHandler = (String, Bool) -> Void
    var places: [Place] = []
    var onDataFetch: ((Bool) -> Void)?

    func fetchPlaces(callback: @escaping PlaceHandler) {
        NetworkManager.shared.request(TravioRouter.getAllPlaces, ofType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetch all places successfully.", true)
                self.places = response.data.places
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func numberOfPlaces() -> Int {
        return places.count
    }

    func getAPlace(at index: Int) -> Place? {
        return places[index]
    }
}
