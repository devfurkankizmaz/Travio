//
//  MapViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

class VisitsViewModel {
    typealias VisitHandler = (String, Bool) -> Void
    var visits: [Visit] = []
    // var onDataFetch: ((Bool) -> Void)?

    func fetchVisits(callback: @escaping VisitHandler) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(), responseType: VisitResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetched all visits successfully.", true)
                self.visits = response.data.visits
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func numberOfVisits() -> Int {
        return visits.count
    }

    func getAVisit(at index: Int) -> Visit? {
        return visits[index]
    }
}
