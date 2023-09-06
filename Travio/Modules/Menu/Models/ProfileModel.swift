//
//  ProfileModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Foundation

struct Profile: Codable {
    let id: String
    let fullName: String
    let email: String
    let role: String
    let ppUrl: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case role
        case ppUrl = "pp_url"
        case createdAt = "created_at"
    }
}
