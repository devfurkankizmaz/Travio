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
    case getPlaceById(id: String)
    case getGalleryByPlaceId(id: String)
    case postGalleryByPlaceId(params: Parameters)
    case getAllVisits
    case postPlace(params: Parameters)
    case uploadImage(imageData: Data)

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
        case .uploadImage:
            return "/upload"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .postPlace, .uploadImage, .postGalleryByPlaceId:
            return .post
        case .getAllPlaces, .getPlaceById, .getGalleryByPlaceId, .getAllVisits:
            return .get
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
        case .uploadImage:
            return nil
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .login, .register, .getAllPlaces, .getPlaceById, .getGalleryByPlaceId:
            return [:]
        case .getAllVisits, .postPlace, .postGalleryByPlaceId:
            return ["Authorization": "Bearer \(KeychainHelper.loadAccessToken()!)"]
        case .uploadImage:
            return ["Content-Type": "multipart/form-data"]
        }
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