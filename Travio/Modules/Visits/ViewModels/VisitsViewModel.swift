//
//  MapViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

class VisitsViewModel {
    typealias CompletionHandler = (String, Bool) -> Void
    var visits: [Visit] = []
    var didNotificationTriggered: Bool = false

    func handleNotification() {
        didNotificationTriggered = true
    }

    func fetchVisits(completion: @escaping CompletionHandler) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(), responseType: VisitResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.visits = response.data.visits
                completion("You've fetched all visits successfully.", true)
            case .failure(let error):
                completion(error.localizedDescription, false)
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
