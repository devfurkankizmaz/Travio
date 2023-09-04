//
//  HomeViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 2.09.2023.
//

import Foundation

class HomeViewModel {
    typealias Completion = (String, Bool) -> Void
    var popularPlaces: [Place] = []
    var newPlaces: [Place] = []
    var onDataFetch: ((Bool) -> Void)?

    func fetchPopularPlaces(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getPopularPlaces(limit: 5), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetch all popular places successfully.", true)
                self.popularPlaces = response.data.places
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func fetchNewPlaces(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getNewPlaces(limit: 5), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetch all new places successfully.", true)
                self.newPlaces = response.data.places
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func numberOfPopularPlaces() -> Int {
        return popularPlaces.count
    }

    func getAPopularPlace(at index: Int) -> Place? {
        return popularPlaces[index]
    }

    func numberOfLastPlaces() -> Int {
        return newPlaces.count
    }

    func getALastPlace(at index: Int) -> Place? {
        return newPlaces[index]
    }
}
