//
//  PlaceModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 25.08.2023.
//

import Foundation

struct Place: Codable {
    let id: String
    let creator: String
    let place: String
    let title: String
    let description: String?
    let cover_image_url: String?
    let latitude: Double
    let longitude: Double
    let created_at: String
    let updated_at: String
}

struct PlaceInput {
    let place: String
    let title: String
    let description: String?
    let latitude: Double
    let longitude: Double
}

struct PlacesResponse: Codable {
    let data: PlacesData
    let status: String
}

struct PlacesData: Codable {
    let count: Int
    let places: [Place]
}

struct PlaceResponse: Codable {
    struct Data: Codable {
        let place: Place
    }

    let data: Data
    let status: String
}
