//
//  HomeViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 2.09.2023.
//

import Foundation

class HomeViewModel {
    typealias Completion = (String, Bool) -> Void
    private var popularPlaces: [Place] = []
    private var newPlaces: [Place] = []
    private var visits: [Visit] = []

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
                print(error.localizedDescription)
            }
        }
    }

    func fetchVisits(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(page: 1, limit: 5), responseType: VisitResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetch all visits successfully.", true)
                self.visits = response.data.visits
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func getAllPopularPlaces() -> [Place] {
        return popularPlaces
    }

    func getAllLastPlaces() -> [Place] {
        return newPlaces
    }

    func getAllVisits() -> [Place] {
        var places: [Place] = []
        visits.forEach { visit in
            places.append(visit.place)
        }
        return places
    }
}
