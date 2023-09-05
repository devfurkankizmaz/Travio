class HomeViewModel {
    typealias Completion = (Bool) -> Void

    private var popularPlaces: [Place] = []
    private var newPlaces: [Place] = []
    private var visits: [Visit] = []
    var onDataFetch: ((Bool) -> Void)?

    func fetchPopularPlaces(callback: @escaping Completion) {
        onDataFetch?(true) // Notify the callback to start showing an indicator
        NetworkManager.shared.request(TravioRouter.getPopularPlaces(limit: 5), responseType: PlacesResponse.self) { [weak self] result in
            self?.onDataFetch?(false) // Notify the callback to stop showing the indicator
            switch result {
            case .success(let response):
                self?.popularPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchNewPlaces(callback: @escaping Completion) {
        onDataFetch?(true)
        NetworkManager.shared.request(TravioRouter.getNewPlaces(limit: 5), responseType: PlacesResponse.self) { [weak self] result in
            self?.onDataFetch?(false)
            switch result {
            case .success(let response):
                self?.newPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchVisits(callback: @escaping Completion) {
        onDataFetch?(true)
        NetworkManager.shared.request(TravioRouter.getAllVisits(page: 1, limit: 5), responseType: VisitResponse.self) { [weak self] result in
            self?.onDataFetch?(false)
            switch result {
            case .success(let response):
                self?.visits = response.data.visits
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func getPlacesForSection(_ section: SectionType) -> [Place] {
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
