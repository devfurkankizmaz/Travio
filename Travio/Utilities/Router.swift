//
//  TravioRouter.swift
//  Travio
//
//  Created by Furkan Kızmaz on 25.08.2023.
//

import Alamofire
import Foundation

enum TravioRouter {
    case login(params: Parameters)
    case register(params: Parameters)
    case getAllPlaces
    case getPopularPlaces(limit: Int)
    case getNewPlaces(limit: Int)
    case getPlaceById(id: String)
    case getGalleryByPlaceId(id: String)
    case postGalleryByPlaceId(params: Parameters)
    case getAllVisits
    case postPlace(params: Parameters)
    case postVisit(params: Parameters)
    case uploadImage(imageData: [Data])
    case deleteVisitById(id: String)
    case getVisitByPlace(id: String)

    var baseURL: URL {
        URL(string: "https://api.iosclass.live")!
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"
        case .register:
            return "/v1/auth/register"
        case .getAllPlaces:
            return "/v1/places"
        case .getPopularPlaces:
            return "/v1/places/popular"
        case .getNewPlaces:
            return "/v1/places/last"
        case .getPlaceById(let placeId):
            return "/v1/places/\(placeId)"
        case .getGalleryByPlaceId(let placeId):
            return "/v1/galleries/\(placeId)"
        case .postGalleryByPlaceId:
            return "/v1/galleries"
        case .getAllVisits:
            return "/v1/visits"
        case .postPlace:
            return "/v1/places"
        case .postVisit:
            return "/v1/visits"
        case .uploadImage:
            return "/upload"
        case .deleteVisitById(let visitId):
            return "/v1/visits/\(visitId)"
        case .getVisitByPlace(let placeId):
            return "/v1/visits/user/\(placeId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .postPlace, .postVisit, .uploadImage, .postGalleryByPlaceId:
            return .post
        case .getAllPlaces, .getPopularPlaces, .getNewPlaces, .getPlaceById, .getGalleryByPlaceId, .getAllVisits, .getVisitByPlace:
            return .get
        case .deleteVisitById:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let parameters):
            return parameters
        case .register(let parameters):
            return parameters
        case .getAllPlaces:
            return nil
        case .getPopularPlaces(let limit):
            return ["limit": limit]
        case .getNewPlaces(let limit):
            return ["limit": limit]
        case .getPlaceById:
            return nil
        case .getGalleryByPlaceId:
            return nil
        case .postGalleryByPlaceId(let parameters):
            return parameters
        case .getAllVisits:
            return nil
        case .postPlace(let parameters):
            return parameters
        case .postVisit(let parameters):
            return parameters
        case .uploadImage:
            return nil
        case .deleteVisitById:
            return nil
        case .getVisitByPlace:
            return nil
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .login, .register, .getAllPlaces, .getNewPlaces, .getPopularPlaces, .getPlaceById, .getGalleryByPlaceId:
            return [:]
        case .getAllVisits, .postPlace, .postGalleryByPlaceId, .deleteVisitById, .getVisitByPlace, .postVisit:
            return ["Authorization": "Bearer \(KeychainHelper.loadAccessToken()!)"]
        case .uploadImage:
            return ["Content-Type": "multipart/form-data"]
        }
    }
}

extension TravioRouter {
    var multipartFormData: MultipartFormData {
        let formData = MultipartFormData()
        switch self {
        case .uploadImage(let imageData):
            imageData.forEach { image in
                formData.append(image, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            return formData
        default:
            break
        }
        return formData
    }
}

extension TravioRouter: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
}
