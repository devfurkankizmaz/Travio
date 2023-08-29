import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    enum NetworkError: Error {
        case network(Error)
        case responseDecoding(Error)
    }

    typealias Completion<T: Decodable> = (Result<T, NetworkError>) -> Void

    // MARK: - Public Methods

    func request<T: Decodable>(_ route: TravioRouter, ofType type: T.Type, completion: @escaping Completion<T>) {
        AF.request(route)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    self.handleSuccessResponse(data: data, response: response, completion: completion)
                case .failure(let error):
                    self.handleFailureResponse(error: error, response: response, completion: completion)
                }
            }
    }

    func uploadImage<T: Decodable>(route: TravioRouter, imageData: Data, responseType: T.Type, completion: @escaping Completion<T>) {
        let uploadURL = route.baseURL.appendingPathComponent(route.path)
        AF.upload(
            multipartFormData: { formData in
                formData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: uploadURL,
            method: .post,
            headers: route.headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                self.handleSuccessResponse(data: data, response: response, completion: completion)
            case .failure(let error):
                self.handleFailureResponse(error: error, response: response, completion: completion)
            }
        }
    }

    // MARK: - Private Methods

    private func handleSuccessResponse<T: Decodable>(data: T, response: AFDataResponse<T>, completion: @escaping Completion<T>) {
        if let loginResponse = data as? LoginResponse {
            KeychainHelper.saveAccessToken(loginResponse.accessToken)
        }
        completion(.success(data))
    }

    private func handleFailureResponse<T: Decodable>(error: AFError, response: AFDataResponse<T>, completion: @escaping Completion<T>) {
        if let underlyingError = response.error {
            completion(.failure(.network(underlyingError)))
        } else {
            completion(.failure(.responseDecoding(error)))
        }
    }
}
