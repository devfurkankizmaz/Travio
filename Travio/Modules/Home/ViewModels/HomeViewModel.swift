import Foundation

class HomeViewModel {
    typealias ResultCallback = (Bool) -> Void

    private var popularPlaces: [Place] = []
    private var newPlaces: [Place] = []
    private var visits: [Visit] = []

    enum Section: String, CaseIterable {
        case popular = "Popular Places"
        case new = "New Places"
        case visits = "Visits"
    }

    func fetchPopularPlaces(callback: @escaping ResultCallback) {
        NetworkManager.shared.request(TravioRouter.getPopularPlaces(limit: 5), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                self.popularPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchNewPlaces(callback: @escaping ResultCallback) {
        NetworkManager.shared.request(TravioRouter.getNewPlaces(limit: 5), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                self.newPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchVisits(callback: @escaping ResultCallback) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(page: 1, limit: 5), responseType: VisitResponse.self) { result in
            switch result {
            case .success(let response):
                self.visits = response.data.visits
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func getPlacesForSection(_ section: Section) -> [Place] {
        switch section {
        case .popular:
            return popularPlaces
        case .new:
            return newPlaces
        case .visits:
            return visits.map { $0.place }
        }
    }
}
